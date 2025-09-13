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
            content = regex.stringByReplacingMatches(in: content, options: [], range: range, withTemplate: "\n")
        }
        
        let lines = content.components(separatedBy: .newlines)
        var finalLines: [String] = []
        
        let fullLineCommentPattern = #"^\s*//.*"#
        let trailingCommentPattern = #"\s*//.*$"#
        let trailingRegex = try? NSRegularExpression(pattern: trailingCommentPattern, options: [])
        
        for line in lines {
            if line.range(of: fullLineCommentPattern, options: .regularExpression) != nil {
                continue
            }
            
            var processedLine = line
            if let regex = trailingRegex {
                let range = NSRange(processedLine.startIndex..., in: processedLine)
                processedLine = regex.stringByReplacingMatches(in: processedLine, options: [], range: range, withTemplate: "")
            }
            
            finalLines.append(processedLine)
        }
        
        buffer.lines.removeAllObjects()
        buffer.lines.addObjects(from: finalLines)
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
