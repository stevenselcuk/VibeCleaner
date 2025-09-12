import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {

    // Ana yönlendirici fonksiyon
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            completionHandler(nil)
            return
        }
        
        // Info.plist'te tanımladığımız kimlikler
        let cleanCommentsIdentifier = bundleIdentifier + ".CleanCommentsCommand"
        let cleanPrintsIdentifier = bundleIdentifier + ".CleanPrintsCommand"
        
        // Hangi komutun çağrıldığını kontrol et ve ilgili fonksiyonu çalıştır
        switch invocation.commandIdentifier {
        case cleanCommentsIdentifier:
            handleCleanComments(in: invocation.buffer)
        case cleanPrintsIdentifier:
            handleCleanPrints(in: invocation.buffer)
        default:
            break // Bilinmeyen bir komutsa hiçbir şey yapma
        }
        
        completionHandler(nil)
    }
    
    // Yorumları temizleyen fonksiyon
    private func handleCleanComments(in buffer: XCSourceTextBuffer) {
        var content = buffer.completeBuffer
        
        // 1. Çok satırlı yorumları (/* ... */) temizle
        let multiLineCommentPattern = "/\\*.*?\\*/"
        if let regex = try? NSRegularExpression(pattern: multiLineCommentPattern, options: .dotMatchesLineSeparators) {
            let range = NSRange(content.startIndex..., in: content)
            content = regex.stringByReplacingMatches(in: content, options: [], range: range, withTemplate: "")
        }
        
        // 2. Tek satırlı yorumları (ama MARK'ları koru) temizle
        var lines = content.components(separatedBy: .newlines)
        let singleLineCommentPattern = #"^\s*//(?! MARK:).*"#
        
        lines.removeAll { line in
            line.range(of: singleLineCommentPattern, options: .regularExpression) != nil
        }
        
        // 3. Dosyayı güncelle
        let finalContent = lines.joined(separator: "\n")
        buffer.lines.removeAllObjects()
        buffer.lines.add(finalContent)
    }
    
    // Print ifadelerini temizleyen fonksiyon
    private func handleCleanPrints(in buffer: XCSourceTextBuffer) {
        var linesToRemove: [Int] = []
        let printPattern = #"^\s*print\s*\(.*\)\s*$"#
        
        // 1. Silinecek satırların index'lerini bul
        for (index, line) in buffer.lines.enumerated() {
            guard let line = line as? String else { continue }
            if line.range(of: printPattern, options: .regularExpression) != nil {
                linesToRemove.append(index)
            }
        }
        
        // 2. Bulunan satırları tersten sil
        if !linesToRemove.isEmpty {
            buffer.lines.removeObjects(at: IndexSet(linesToRemove.reversed()))
        }
    }
}
