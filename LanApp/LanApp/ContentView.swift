struct PinLockView: View {
    @Binding var isUnlocked: Bool
    @State private var pin: String = ""
    private let correctPin = "1234"

    var body: some View {
        VStack(spacing: 24) {
            Text("Enter PIN")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)

            SecureField("PIN", text: $pin)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.white)
                .frame(width: 200)

            Button(action: {
                if pin == correctPin {
                    isUnlocked = true
                } else {
                    pin = ""
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            }) {
                Text("Unlock")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: 200)
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
    }
}
//
//  ContentView.swift
//  LanApp
//
//  Created by Diego Villarreal on 6/9/25.
//

import AudioToolbox
import SwiftUI
import UIKit
import AudioToolbox
// MARK: - ImagePicker for photo upload
struct ImagePicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}


struct MainView: View {
    @State private var phoneNumber: String = ""
    @State private var amount: String = ""
    @State private var isLoading = true
    @Binding var balance: Double
    @Binding var recentTransactions: [String]
    @State private var selectedRecipient: String?
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Hero Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("LanApp")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)

                    // Card background with CardBG color and shadow
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color("CardBG"))
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 5, y: 5)
                            .shadow(color: .white.opacity(0.1), radius: 10, x: -5, y: -5)
                            .animation(.easeInOut(duration: 0.4), value: balance)
                            .frame(height: 160)

                        VStack {
                            Text("Balance")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("$\(String(format: "%.2f", balance))")
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .padding(.top, 10)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 24)

                    HStack(spacing: 16) {
                        Button(action: {
                            // Deposit action
                        }) {
                            Text("Deposit money")
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.purple, Color.blue]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }

                        Button(action: {
                            // Withdraw action
                        }) {
                            Text("Withdraw")
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.purple, Color.blue]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.top, 60)

                // Dashboard Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Quick send")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)

                    HStack(spacing: 16) {
                        ForEach(["Hector", "Carlos", "Jose"], id: \.self) { name in
                            Button(action: {
                                selectedRecipient = name
                            }) {
                                VStack {
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 50, height: 50)
                                    Text(name)
                                        .foregroundColor(.white)
                                        .font(.caption)
                                }
                                .frame(width: 100, height: 100)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal, 24)

                    Text("Recent Activity")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)

                    VStack(spacing: 8) {
                        ForEach(recentTransactions.prefix(3), id: \.self) { transaction in
                            HStack {
                                Image(systemName: transaction.contains("You sent") ? "arrow.up.right.circle" : "arrow.down.left.circle")
                                    .foregroundColor(transaction.contains("You sent") ? .red : .green)
                                    .frame(width: 30)

                                Text(transaction)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding()
                            .background(transaction.contains("You sent") ? Color.red.opacity(0.15) : Color.green.opacity(0.15))
                            .cornerRadius(10)
                            .padding(.horizontal, 24)
                        }
                    }
                }

            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("NewTransaction"))) { notification in
            if let entry = notification.object as? String {
                recentTransactions.insert(entry, at: 0)
            }
        }
        .background(Color.black)
        .preferredColorScheme(.dark)
        .sheet(item: $selectedRecipient) { recipient in
            QuickSendView(recipient: recipient, isAsk: false, transactionLog: $recentTransactions, balance: $balance)
                .onDisappear {
                    print("Dismissed QuickSendView, recentTransactions: \(recentTransactions)")
                }
        }
    }
}

struct AnimatedTabIcon: View {
    let icon: String
    let isSelected: Bool

    var body: some View {
        Image(systemName: icon)
            .scaleEffect(isSelected ? 1.2 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isSelected)
            .onChange(of: isSelected) { newValue in
                if newValue {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
            }
    }
}

// struct ContentView is intentionally not marked with @main.
struct ContentView: View {
    @State private var showSplash = true
    @State private var transactionLog: [String] = [
        "You sent $20.00 to Hector",
        "Carlos sent you $50.00",
        "You sent $30.00 to Jose",
        "You sent $100.00 to Maria",
        "Luis sent you $25.50",
        "You sent $60.75 to Ana",
        "You sent $10.00 to Oscar",
        "Emma sent you $15.00",
        "You sent $45.00 to Pablo",
        "You sent $5.00 to Raul",
        "You sent $80.00 to Sofia",
        "Marco sent you $35.00",
        "You sent $90.00 to Leo",
        "Lucia sent you $12.50",
        "You sent $55.00 to Laura",
        "You sent $40.00 to Diego",
        "Andrea sent you $20.00",
        "You sent $65.00 to Bruno",
        "You sent $30.00 to Valeria",
        "Sebastian sent you $100.00"
    ]
    @State private var selectedTab = 0
    @State private var balance: Double = 120.00
    @State private var transactions: [Transaction] = []
    @State private var isUnlocked = false

    var body: some View {
        ZStack {
            if isUnlocked {
                ZStack {
                    Color.black
                    if showSplash {
                        SplashView(showSplash: $showSplash)
                    } else {
                        TabView(selection: $selectedTab) {
                            MainView(balance: $balance, recentTransactions: $transactionLog)
                                .tabItem {
                                    AnimatedTabIcon(icon: "creditcard", isSelected: selectedTab == 0)
                                }
                                .tag(0)

                            ContactsView(transactionLog: $transactionLog, balance: $balance)
                                .tabItem {
                                    AnimatedTabIcon(icon: "person.2.fill", isSelected: selectedTab == 1)
                                }
                                .tag(1)

                            HistoryView(transactions: transactionLog)
                                .tabItem {
                                    AnimatedTabIcon(icon: "clock.arrow.circlepath", isSelected: selectedTab == 2)
                                }
                                .tag(2)

                            SettingsView()
                                .tabItem {
                                    AnimatedTabIcon(icon: "gearshape.fill", isSelected: selectedTab == 3)
                                }
                                .tag(3)
                        }
                        .accentColor(.green)
                    }
                }
                .ignoresSafeArea()
                .preferredColorScheme(.dark)
            } else {
                PinLockView(isUnlocked: $isUnlocked)
            }
        }
    }
}

#Preview {
    ContentView()
}

struct SplashView: View {
    @Binding var showSplash: Bool
    @State private var scale: CGFloat = 0.3
    @State private var opacity: Double = 0.0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            Text("$")
                .font(.system(size: 100))
                .fontWeight(.bold)
                .foregroundColor(.green)
                .scaleEffect(scale)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeOut(duration: 0.3)) {
                        opacity = 1.0
                        scale = 1.2
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            scale = 1.0
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                        withAnimation {
                            showSplash = false
                        }
                    }
                }
        }
    }
}

struct QuickSendView: View {
    let recipient: String
    let isAsk: Bool
    @Binding var transactionLog: [String]
    @Binding var balance: Double
    @Environment(\.dismiss) var dismiss
    @State private var amount: String = ""
    @State private var note: String = ""
    @State private var tappedKey: String? = nil
    @State private var showConfirmation = false
    @State private var isProcessing = false
    @State private var isTyping = false

    // Define the keypad rows as a constant outside the body
    let keypad: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        [".", "0", "⌫"]
    ]

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()

                Text("Send to \(recipient)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()

                Text(amount)
                    .font(.system(size: 36, weight: .bold))
                    .scaleEffect(isTyping ? 1.05 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.4), value: isTyping)

                TextField("Add a note", text: $note)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                    .padding(.horizontal)

                Spacer()

                VStack(spacing: 1) {
                    ForEach(keypad.indices, id: \.self) { rowIndex in
                        let row = keypad[rowIndex]
                        HStack(spacing: 1) {
                            ForEach(row, id: \.self) { item in
                                Button(action: {
                                    // Unified haptic and sound for all keys
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    AudioServicesPlaySystemSound(1104) // iOS keyboard tap

                                    if item == "⌫" {
                                        isTyping = true
                                        handleInput(item)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            isTyping = false
                                        }
                                    } else if item == "." {
                                        isTyping = true
                                        handleInput(item)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            isTyping = false
                                        }
                                    } else {
                                        // item is digit 0-9
                                        isTyping = true
                                        amount += item
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            isTyping = false
                                        }
                                    }
                                    tappedKey = item
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                        tappedKey = nil
                                    }
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.2))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                            )

                                        Text(item)
                                            .font(.title)
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: 100, height: 100)
                                    .scaleEffect(tappedKey == item ? 0.92 : 1.0)
                                    .animation(.easeInOut(duration: 0.1), value: tappedKey)
                                }
                            }
                        }
                    }
                }

                Button(action: {
                    guard !isProcessing else { return }
                    isProcessing = true

                    if let amt = Double(amount), !amt.isZero {
                        let entry = isAsk
                            ? "\(recipient) sent you $\(String(format: "%.2f", amt))\(note.isEmpty ? "" : "|note:\(note)")"
                            : "You sent $\(String(format: "%.2f", amt)) to \(recipient)\(note.isEmpty ? "" : "|note:\(note)")"
                        transactionLog.insert(entry, at: 0)
                        NotificationCenter.default.post(name: Notification.Name("NewTransaction"), object: entry)
                        if isAsk {
                            balance += amt
                        } else {
                            balance -= amt
                        }
                    }

                    let feedback = UINotificationFeedbackGenerator()
                    feedback.notificationOccurred(.success)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        withAnimation {
                            showConfirmation = true
                            isProcessing = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            dismiss()
                        }
                    }
                }) {
                    if isProcessing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(12)
                    } else {
                        Text(isAsk ? "Request Money" : "Send Money")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.purple, Color.blue]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(12)
                    }
                }
                .disabled(isProcessing)
                .padding(.horizontal, 24)
                .padding(.top, 10)
            }
            .opacity(showConfirmation ? 0 : 1)

            // Confirmation checkmark animation with bounce effect and background
            if showConfirmation {
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.green)
                        .scaleEffect(showConfirmation ? 1.2 : 0.5)
                        .animation(.interpolatingSpring(stiffness: 100, damping: 10), value: showConfirmation)

                    Text(isAsk ? "Request Sent!" : "Sent!")
                        .font(.title)
                        .foregroundColor(.white)
                }
                .background(Color.black.opacity(0.8).ignoresSafeArea())
                .transition(.opacity)
            }
        }
        .background(Color.black.ignoresSafeArea())
        //.navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                        Text("Back")
                            .foregroundColor(.white)
                    }
                    .padding(8)
                    .background(Color.green)
                    .cornerRadius(10)
                }
            }
        }
    }

    func handleInput(_ value: String) {
        switch value {
        case "⌫":
            if !amount.isEmpty {
                amount.removeLast()
            }
        case ".":
            if !amount.contains(".") {
                amount.append(".")
            }
        default:
            amount.append(value)
        }
    }
}

extension String: @retroactive Identifiable {
    public var id: String { self }
}

struct ContactsView: View {
    @State private var contacts: [String] = []
    let myUsername = "diegov"
    let myName = "Diego Villarreal"
    @Binding var transactionLog: [String]
    @Binding var balance: Double
    @State private var isLoading = true

    var body: some View {
        NavigationStack {
            if isLoading {
                ShimmerPlaceholderList()
            } else {
                List {
                    Section(header: Text("Me").foregroundColor(.white)) {
                        NavigationLink(destination: ProfileView(name: myName, username: myUsername, isMe: true, transactionLog: $transactionLog, balance: $balance)) {
                            HStack {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 40, height: 40)
                                VStack(alignment: .leading) {
                                    Text(myName)
                                        .foregroundColor(.white)
                                    Text("@\(myUsername)")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                }
                                .padding(.leading, 8)
                            }
                            .padding(.vertical, 8)
                        }
                    }

                    Section(header: Text("Contacts").foregroundColor(.white)) {
                        ForEach(contacts, id: \.self) { contact in
                            NavigationLink(destination: ProfileView(name: contact, username: "\(contact.lowercased())", isMe: false, transactionLog: .constant(transactionLog), balance: $balance)) {
                                HStack {
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 40, height: 40)
                                    VStack(alignment: .leading) {
                                        Text(contact)
                                            .foregroundColor(.white)
                                        Text("@\(contact.lowercased())")
                                            .foregroundColor(.gray)
                                            .font(.caption)
                                    }
                                    .padding(.leading, 8)
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }

                    // Invite a Friend CTA Section
                    Section {
                        Button(action: {
                            // Placeholder for invite functionality
                            print("Invite a Friend tapped")
                        }) {
                            HStack {
                                Spacer()
                                Text("Invite a Friend – Get $5 when they join!")
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                    .padding()
                                Spacer()
                            }
                            .background(Color.green)
                            .cornerRadius(10)
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.black)
                .navigationTitle("Contacts")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: AddContactView()) {
                            Image(systemName: "plus")
                                .foregroundColor(.green)
                        }
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                var savedContacts = UserDefaults.standard.stringArray(forKey: "contacts") ?? []
                let defaults = ["Hector", "Carlos", "Jose"]
                for name in defaults {
                    if !savedContacts.contains(name) {
                        savedContacts.append(name)
                    }
                }
                UserDefaults.standard.set(savedContacts, forKey: "contacts")
                contacts = savedContacts
                isLoading = false
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct ProfileView: View {
    let name: String
    let username: String
    var isMe: Bool = false
    @Binding var transactionLog: [String]
    @Binding var balance: Double

    @State private var profileImage: Image? = nil
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var profileOpacity: Double = 0.0
    @State private var profileScale: CGFloat = 1.0

    func loadImage() {
        guard let inputImage = inputImage else { return }
        profileImage = Image(uiImage: inputImage)
    }

    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                if let image = profileImage {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 100, height: 100)
                        .overlay(Text(name.prefix(1))
                            .font(.largeTitle)
                            .foregroundColor(.black))
                }
            }
            .scaleEffect(profileScale)
            .animation(.spring(), value: profileScale)
            .onTapGesture {
                if isMe {
                    showingImagePicker = true
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) {
                        profileScale = 1.2
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.spring()) {
                            profileScale = 1.0
                        }
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $inputImage)
            }

            HStack(spacing: 8) {
                VStack(spacing: 8) {
                    Text(name)
                        .font(.title)
                        .foregroundColor(.white)
                        .fontWeight(.bold)

                    Text("@\(username)")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                if !transactionLog.filter({ $0.contains(name) }).isEmpty {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                }
            }

            HStack(spacing: 20) {
                NavigationLink(destination: QuickSendView(recipient: name, isAsk: true, transactionLog: isMe ? $transactionLog : .constant([]), balance: $balance)) {
                    Text("Ask")
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }

                NavigationLink(destination: QuickSendView(recipient: name, isAsk: false, transactionLog: isMe ? $transactionLog : .constant([]), balance: $balance)) {
                    Text("Deposit")
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)

            Divider()
                .background(Color.white)

            Text(isMe ? "Deposits to Me" : "Transactions with \(name)")
                .foregroundColor(.white)
                .font(.headline)
                .padding(.top)

            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    let transactions = isMe
                        ? transactionLog.filter { $0.contains("sent you") }
                        : transactionLog.filter { $0.contains("to \(name)") || $0.contains("\(name) sent") }
                    ForEach(transactions, id: \.self) { txn in
                        Text(txn)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
            }

            Spacer()
        }
        .opacity(profileOpacity)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                profileOpacity = 1.0
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .navigationTitle("My Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddContactView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var username: String = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("Name", text: $name)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .foregroundColor(.white)

            TextField("Username", text: $username)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .foregroundColor(.white)

            Button(action: {
                if !name.isEmpty {
                    var savedContacts = UserDefaults.standard.stringArray(forKey: "contacts") ?? []
                    if !savedContacts.contains(name) {
                        savedContacts.append(name)
                    }
                    UserDefaults.standard.set(savedContacts, forKey: "contacts")
                    dismiss()
                }
            }) {
                Text("Save")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
                    .foregroundColor(.black)
            }
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("Add Contact")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// New HistoryView at end of file
struct HistoryView: View {
    let transactions: [String]
    @State private var selectedFilter: String = "All"

    var body: some View {
        NavigationStack {
            ScrollView {
                // Inserted History title before VStack
                Text("History")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.top)

                Picker("Filter", selection: $selectedFilter) {
                    Text("All").tag("All")
                    Text("Sent").tag("Sent")
                    Text("Received").tag("Received")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    let filteredTransactions = transactions.filter { txn in
                        if selectedFilter == "Sent" {
                            return txn.contains("You sent")
                        } else if selectedFilter == "Received" {
                            return txn.contains("sent you")
                        }
                        return true
                    }

                    ForEach(Array(filteredTransactions.enumerated()), id: \.element) { index, txn in
                        ZStack {
                            NavigationLink(destination: TransactionDetailView(transaction: txn)) {
                                HStack {
                                    Image(systemName: txn.contains("You sent") ? "arrow.up.right.circle" : "arrow.down.left.circle")
                                        .foregroundColor(txn.contains("You sent") ? .red : .green)
                                        .frame(width: 30)

                                    Text(txn)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding()
                                .background(txn.contains("You sent") ? Color.red.opacity(0.15) : Color.green.opacity(0.15))
                                .cornerRadius(10)
                                .padding(.horizontal)
                            }
                        }
                        .rotationEffect(.degrees(Double(index % 2 == 0 ? -1 : 1)))
                        .offset(x: 0, y: CGFloat(index * 2))
                    }
                }
                .padding(.top)
            }
            .background(Color.black)
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct TransactionDetailView: View {
    let transaction: String

    var body: some View {
        VStack(spacing: 24) {
            Text("Transaction Details")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)

            HStack(spacing: 12) {
                Image(systemName: transaction.contains("sent you") ? "arrow.down.left.circle" : "arrow.up.right.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(transaction.contains("sent you") ? .green : .red)

                Text(transaction.contains("sent you") ? "Received from someone" : "You sent")
                    .font(.headline)
                    .foregroundColor(.white)
            }

            if let amountPart = transaction.components(separatedBy: "$").last?.components(separatedBy: " ").first {
                Text("$\(amountPart)")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }

            // Static for now; can add actual date tracking later
            Text("June 12, 2025 at 12:00 PM")
                .foregroundColor(.gray)
                .font(.subheadline)

            // Parse note if included as: |note:Your note here
            if let note = transaction.components(separatedBy: "|note:").last, transaction.contains("|note:") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Note:")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    Text(note)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("This tab is under construction.")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Transaction model
struct Transaction: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let isSent: Bool
    let date: Date
}


extension ContentView {
    // Function to handle send/ask logic
    func sendMoney(to name: String, amountString: String, isAsking: Bool) {
        guard let amountValue = Double(amountString) else { return }

        let transaction = Transaction(name: name, amount: amountValue, isSent: !isAsking, date: Date())
        transactions.insert(transaction, at: 0)

        if !isAsking {
            balance -= amountValue
        }
    }

    var balanceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Balance")
                .font(.title2)
                .bold()

            Text("$\(balance, specifier: "%.2f")")
                .font(.largeTitle)
                .bold()

            Divider()

            Text("Recent Activity")
                .font(.headline)
                .padding(.top, 8)

            ForEach(transactions.prefix(3)) { transaction in
                HStack {
                    Image(systemName: transaction.isSent ? "arrow.up.right.circle" : "arrow.down.left.circle")
                        .foregroundColor(transaction.isSent ? .red : .green)
                    VStack(alignment: .leading) {
                        Text(transaction.name)
                        Text(transaction.date.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text("$\(transaction.amount, specifier: "%.2f")")
                        .bold()
                }
            }
        }
        .padding()
    }
}

// Shimmer placeholder for loading contacts
struct ShimmerPlaceholderList: View {
    var body: some View {
        VStack(spacing: 16) {
            ForEach(0..<5) { _ in
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.1), Color.gray.opacity(0.3)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(height: 60)
                    .shimmering()
            }
        }.padding()
    }
}

extension View {
    func shimmering() -> some View {
        self
            .modifier(ShimmerModifier())
    }
}

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [.clear, Color.white.opacity(0.4), .clear]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .rotationEffect(.degrees(30))
                .offset(x: phase)
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 350
                }
            }
    }
}

