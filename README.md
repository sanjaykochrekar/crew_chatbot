# crew_chatbot 💬

## 🛠 Tech Stack

Component	Technology
Language	Swift
Framework	SwiftUI (iOS 26 Optimized)
Architecture	MVVM (Model-View-ViewModel)
Persistence	CoreData
Image Loading	Kingfisher

## 🏗 Architecture

The project follows the MVVM pattern to ensure a clean separation of concerns and high testability:

- Models: CoreData entities (Chat, Message, FileAttachment) managed via a centralized persistence controller.

- Views: Declarative SwiftUI views using @ObservedObject and @StateObject for reactive UI updates.


## 📥 Getting Started

Prerequisites:
    - Xcode 17.0+
    - iOS 26.0+ SDK
    - Swift Package Manager (SPM)


## Installation:

1. Clone the repository:

```
git clone https://github.com/sanjaykochrekar/crew_chatbot.git
```

2. Open crew_chat.xcodeproj in Xcode.

3. Wait for Kingfisher to resolve via Swift Package Manager.

4. Build and run on a physical device or simulator.

## Few Points
- Camera will not work in simulator.
- Some times textField, file slection works very slow when connected to debugger, may issue with xcode. Will testing please disconnect the debugger.

## Recording
```https://github.com/sanjaykochrekar/crew_chatbot/blob/main/screen_recording.MP4```