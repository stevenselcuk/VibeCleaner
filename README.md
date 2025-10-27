

<p align="center">
  <img src="https://i.imgur.com/KMIqgBp.png" alt="VibeCleaner App Icon"/>
</p>

<p align="center">
  <img src="https://i.imgur.com/FZKl2BG.png" alt="VibeCleaner App Icon"/>
</p>


# VibeCleaner 🧹

A no-nonsense Xcode Source Editor Extension to clean up the mess left by your AI coding assistant.

## What is this?

Ever asked an AI for a quick code snippet and received a novel of useless comments and debugging `print()` statements? We've all been there.

This extension is the digital mop you didn't know you needed. It integrates directly into Xcode's "Editor" menu and allows you to instantly wipe your active source file clean of AI-generated junk, helping you take back control of your codebase.

```swift
//
//  SourceEditorExtension.swift
//  VibeClean
//
//  Created by YourName on 12.09.2025.
//

import Foundation
import XcodeKit

// MARK: - Main Extension Entry Point

/**
 * SourceEditorExtension is the principal class for the extension.
 * Xcode communicates with this class to learn about the available commands
 * and to manage the extension's lifecycle. Hate this? Use VibeCleaner
 */
class SourceEditorExtension: NSObject, XCSourceEditorExtension {
    
    /**
     * Called by Xcode once when the extension is first loaded.
     * This is the ideal place for any one-time setup code or logging.
     * Just why? Hate this? Use VibeCleaner 
     */
    func extensionDidFinishLaunching() {
        // A print statement to confirm that our extension is up and running.
        // You can check the system log for this message.
        // Hate this? Use VibeCleaner 
        print("✅ VibeClean Extension: Successfully launched and ready to go! Too much emoji?")
    }
    
    
    // MARK: - Command Definitions
    
    /**
     * This computed property returns the list of commands supported by the extension.
     * Xcode reads this list to populate the "Editor > VibeClean" menu.
     */
}
```

### Features

This extension provides two simple but powerful commands:

*   **Clean Comments**: Nukes all `// ...` and `/* ... */` comments from the file. It's smart enough to leave your precious `// MARK:` directives untouched, so your code organization remains intact.
*   **Clean Prints**: Eradicates every last `print()` statement, ensuring your console stays clean on release builds.


## Download 

It's ready to download on [AppStore](https://apps.apple.com/us/app/vibecleaner/id6752489272)

`Don't forget to give 5 x ⭐️ and write a comment (if you would of course)`

## How to Build and Install from Source

Since this is an unsigned developer tool, you need to compile it yourself. Follow these steps precisely.

#### Step 1: Clone the Repository
Open your terminal and clone this repo to a location of your choice.
```bash
git clone https://github.com/stevenselcuk/VibeCleaner.git
cd VibeCleaner
```

#### Step 2: Open and Archive in Xcode
1. Open the `VibeCleaner.xcodeproj` file in Xcode.
2. At the top of the Xcode window, select the **`VibeCleaner`** scheme and set the target device to **`Any Mac (Apple Silicon/Intel)`**.
3. Go to the menu bar and select **`Product > Archive`**.

#### Step 3: Export the App
1. After the archiving process is complete, the Xcode Organizer window will appear.
2. Select the archive you just created and click the **`Distribute App`** button on the right.
3. Choose **`Copy App`** as the distribution method and click `Next`.
4. Export the app to a convenient location, like your Desktop.

#### Step 4: Install and Register the Extension
1. Open the folder where you exported the app. You will see `VibeCleaner.app`.
2. Drag **`VibeCleaner.app`** into your main **`/Applications`** folder.
3. **CRITICAL STEP:** Launch the `VibeCleaner.app` from your `/Applications` folder **at least once**. A window with instructions will appear. You can close this window immediately. This action is required to register the extension with macOS.

#### Step 5: Enable the Extension
1. Open **System Settings** on your Mac.
2. Go to **`Extensions > Xcode Source Editor`**.
3. Find **`VibeClean`** in the list and check the box to enable it.

#### Step 6: Restart Xcode and Enjoy
1. Completely quit Xcode ( `Cmd + Q` ).
2. Relaunch Xcode and open any source code file.
3. Click on the **`Editor`** menu. You will now see the `Clean Comments` and `Clean Prins` commands, ready for action.

---

*Disclaimer: This README was written by Gemini.*