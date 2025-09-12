import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            // The Icon
            Image(systemName: "paintbrush.fill")
                .font(.system(size: 50))
                .foregroundColor(.orange)
                .padding()
                .background(Color.orange.opacity(0.15))
                .clipShape(Circle())
            
            // The "Honest" Title
            VStack {
                Text("VibeCleaner")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                Text("Cleans up after your 'assistant'.")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            
            // The Real Talk
            Text("Tired of GPT and other bots vomiting useless comments and `print` statements all over your beautiful code? ")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Text("This Xcode extension is the digital mop you didn't know you needed.")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
                
            // The Simple, No-Bullshit Instructions
            GroupBox(label: Label("Activation Sequence", systemImage: "powerplug.fill")) {
                VStack(alignment: .leading, spacing: 15) {
                    InstructionView(step: "1", text: "Go to **System Settings > Extensions > Xcode Source Editor** and enable **VibeCleaner**.")
                    InstructionView(step: "2", text: "Quit and **restart Xcode**. (Yes, really. It needs a good slap to wake up.)")
                    InstructionView(step: "3", text: "Find the command under the **Editor** menu to nuke the AI junk.")
                }
                .padding(.top, 10)
            }
            .padding(.horizontal)
            
            // The Sign-off
            Text("You can close this window now.(Disclaimer: Gemini wrote this launch screen.)")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 10)
                
        }
        .padding(30)
        .frame(minWidth: 550, minHeight: 480)
    }
}

// A helper view to make instructions look clean
struct InstructionView: View {
    let step: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(step)
                .font(.caption.bold())
                .padding(6)
                .background(Color.secondary.opacity(0.2))
                .clipShape(Circle())

            Text(try! AttributedString(markdown: text))
                .padding(.top, 2)
        }
    }
}
