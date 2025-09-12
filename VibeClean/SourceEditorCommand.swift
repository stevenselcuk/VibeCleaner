import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            completionHandler(nil)
            return
        }
        
        let cleanCommentsIdentifier = bundleIdentifier + ".CleanCommentsCommand"
        let cleanPrintsIdentifier = bundleIdentifier + ".CleanPrintsCommand"
        
        switch invocation.commandIdentifier {
        case cleanCommentsIdentifier:
            handleCleanComments(in: invocation.buffer)
        case cleanPrintsIdentifier:
            handleCleanPrints(in: invocation.buffer)
        default:
            break
        }
        
        completionHandler(nil)
    }
    
    private func handleCleanComments(in buffer: XCSourceTextBuffer) {
        var content = buffer.completeBuffer
        
        let multiLineCommentPattern = "/\\*.*?\\*/"
        if let regex = try? NSRegularExpression(pattern: multiLineCommentPattern, options: .dotMatchesLineSeparators) {
            let range = NSRange(content.startIndex..., in: content)
            content = regex.stringByReplacingMatches(in: content, options: [], range: range, withTemplate: "")
        }
        
        var lines = content.components(separatedBy: .newlines)
        let singleLineCommentPattern = #"^\s*//(?! MARK:).*"#
        
        lines.removeAll { line in
            line.range(of: singleLineCommentPattern, options: .regularExpression) != nil
        }
        
        let finalContent = lines.joined(separator: "\n")
        buffer.lines.removeAllObjects()
        buffer.lines.add(finalContent)
    }
    
    private func handleCleanPrints(in buffer: XCSourceTextBuffer) {
        var linesToRemove: [Int] = []
        let printPattern = #"^\s*print\s*\(.*\)\s*$"#
        
        for (index, line) in buffer.lines.enumerated() {
            guard let line = line as? String else { continue }
            if line.range(of: printPattern, options: .regularExpression) != nil {
                linesToRemove.append(index)
            }
        }
        
        if !linesToRemove.isEmpty {
            buffer.lines.removeObjects(at: IndexSet(linesToRemove.reversed()))
        }
    }
}
