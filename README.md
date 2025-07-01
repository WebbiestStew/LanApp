# LanApp
💸 LanApp – Personal Cash App Clone

LanApp is a modern, clean, and user-friendly peer-to-peer payment app inspired by Cash App. It focuses on speed, aesthetics, and next-gen design, while allowing basic financial interactions like sending, requesting, and tracking money between contacts.

⸻

🚀 Features
	•	🔒 PIN Lock Authentication
Secure entry using a 4-digit PIN before accessing the app.
	•	🎨 Accent Color Personalization
Switch between green and purple themes to match your vibe.
	•	💰 Balance Dashboard
Real-time balance updates with a gradient card and animated transitions.
	•	⚡ Quick Send/Request
Instantly send or request money from contacts with an interactive, animated number pad.
	•	🕘 Transaction History
Detailed transaction tracking with filters (Sent, Received, All) and individual transaction views.
	•	📇 Contacts Management
Save, view, and manage your contacts directly inside the app.
	•	✅ Invite Friends
Get $5 when a friend joins via your invitation (visual CTA placeholder).
	•	✨ Premium Visuals & Haptics
	•	Animated Tab Bar icons
	•	Shimmer placeholders during loading
	•	Bounce animations
	•	Haptic feedback on key interactions

⸻

📱 Built With
	•	SwiftUI – Declarative UI framework
	•	UIKit – For image picking and haptic feedback
	•	UserDefaults – Local storage for contacts
	•	NotificationCenter – Real-time UI updates across views


 STRUCTURE
 LanApp
├── ContentView.swift          // App navigation and entry point
├── MainView.swift             // Balance dashboard and quick actions
├── QuickSendView.swift        // Send/request money interface
├── ContactsView.swift         // Contacts list and management
├── HistoryView.swift          // Transaction history and filters
├── TransactionDetailView.swift// Detailed transaction info
├── ProfileView.swift          // User and contact profiles
├── AddContactView.swift       // Add new contact screen
├── PinLockView.swift          // PIN lock authentication screen
├── SettingsView.swift         // Accent color customization
├── SplashView.swift           // Launch animation screen
├── ImagePicker.swift          // UIKit image picker integration
├── ShimmerPlaceholderList.swift // Shimmer loading placeholder
├── Extensions.swift           // Global helpers and modifiers
└── Models.swift               // Transaction model


🛠️ Getting Started
	1.	Clone the repo:
 git clone https://github.com/yourusername/LanApp.git
 	2.	Open the .xcodeproj or .xcodeworkspace in Xcode.
	3.	Run the project on your device or simulator.

 🙌 Credits

Built with love fr by Diego Villarreal (iOS app) and Hector Leal (web app) for personal learning, prototyping, and sharing with friends.
