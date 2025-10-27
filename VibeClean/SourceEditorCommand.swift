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
        
        let lines = content.components(separatedBy: .newlines)
        var finalLines: [String] = []
        
        for line in lines {
            var commentStartIndex: String.Index?
            var inString = false
            var isEscaped = false

            for i in line.indices {
                if isEscaped {
                    isEscaped = false
                    continue
                }

                let char = line[i]
                if char == "\\" {
                    isEscaped = true
                    continue
                }

                if char == "\"" {
                    inString = !inString
                }

                if !inString && char == "/" {
                    let nextIndex = line.index(after: i)
                    if nextIndex < line.endIndex && line[nextIndex] == "/" {
                        commentStartIndex = i
                        break
                    }
                }
            }

            if let startIndex = commentStartIndex {
                let codePart = String(line[..<startIndex])

                if !codePart.trimmingCharacters(in: .whitespaces).isEmpty {
                    var finalLine = codePart
                    while let lastChar = finalLine.last, lastChar.isWhitespace {
                        finalLine.removeLast()
                    }
                    finalLines.append(finalLine)
                }
            } else {
                finalLines.append(line)
            }
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
            let reversedIndexes = IndexSet(linesToRemove.reversed())
            buffer.lines.removeObjects(at: reversedIndexes)
        }
    }
}
