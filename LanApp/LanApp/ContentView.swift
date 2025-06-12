//
//  ContentView.swift
//  LanApp
//
//  Created by Diego Villarreal on 6/9/25.
//

import SwiftUI


struct MainView: View {
    @State private var phoneNumber: String = ""
    @State private var amount: String = ""
    @State private var balance: Double = 200.00
    @State private var recentTransactions: [String] = ["Hector - $500.00", "Hector + $500.00", "Diego - $900.10"]
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
                        .padding(.horizontal)

                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 160)
                            .cornerRadius(12)
                            .padding(.horizontal)
                            .overlay(
                                Text("$239.10")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                            )
                    }

                    HStack(spacing: 16) {
                        Button(action: {
                            // Deposit action
                        }) {
                            Text("Deposit money")
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .foregroundColor(.black)
                                .cornerRadius(12)
                        }

                        Button(action: {
                            // Withdraw action
                        }) {
                            Text("Withdraw")
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .foregroundColor(.black)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 60)

                // Dashboard Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Quick send")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal)

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
                    .padding(.horizontal)

                    Text("Recent Activity")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal)

                    VStack(spacing: 8) {
                        ForEach(recentTransactions, id: \.self) { transaction in
                            HStack {
                                Circle()
                                    .fill(Color.green.opacity(0.3))
                                    .frame(width: 30, height: 30)
                                Text(transaction)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                    }
                }

                // Send Money Section
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text("Da de alta a la persona, si no la tienes en contacto")
                        .font(.title)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .padding(.horizontal)

                    VStack(spacing: 12) {
                        TextField("Phone number or username", text: $phoneNumber)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.horizontal)

                        HStack {
                            Button("Cancel") {
                                phoneNumber = ""
                                amount = ""
                            }
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(8)

                            Spacer()

                            Button("Send") {
                                if let amt = Double(amount) {
                                    recentTransactions.insert("Sent to \(phoneNumber) -$\(String(format: "%.2f", amt))", at: 0)
                                    balance -= amt
                                    phoneNumber = ""
                                    amount = ""
                                }
                            }
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.black)
                            .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
            }
        }
        .background(Color.black)
        .preferredColorScheme(.dark)
        .sheet(item: $selectedRecipient) { recipient in
            QuickSendView(recipient: recipient, transactionLog: $recentTransactions)
        }
    }
}

struct ContentView: View {
    @State private var showSplash = true

    var body: some View {
        ZStack {
            Color.black
            if showSplash {
                SplashView(showSplash: $showSplash)
            } else {
                TabView {
                    MainView()
                        .tabItem {
                            Image(systemName: "dollarsign.circle")
                            Text("Balance")
                        }

                    Text("Contacts View")
                        .tabItem {
                            Image(systemName: "person.2")
                            Text("Contacts")
                        }

                    Text("History View")
                        .tabItem {
                            Image(systemName: "clock")
                            Text("History")
                        }

                    Text("Settings View")
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                }
                .accentColor(.green)
            }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
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
    @Binding var transactionLog: [String]
    @Environment(\.dismiss) var dismiss
    @State private var amount: String = ""
    @State private var note: String = ""
    @State private var tappedKey: String? = nil
    @State private var showConfirmation = false

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

                Text("$\(amount)")
                    .font(.system(size: 64, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 20)
                    .multilineTextAlignment(.center)
                
                TextField("Add a note", text: $note)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                    .padding(.horizontal)

                Spacer()

                VStack(spacing: 10) {
                    ForEach(keypad.indices, id: \.self) { rowIndex in
                        let row = keypad[rowIndex]
                        HStack(spacing: 12) {
                            ForEach(row, id: \.self) { item in
                                Button(action: {
                                    tappedKey = item
                                    withAnimation(.easeInOut(duration: 0.1)) {
                                        handleInput(item)
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                        tappedKey = nil
                                    }
                                }) {
                                    Text(item)
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .frame(width: 80, height: 80)
                                        .background(tappedKey == item ? Color.green : Color.gray.opacity(0.3))
                                        .cornerRadius(40)
                                        .scaleEffect(tappedKey == item ? 1.1 : 1.0)
                                }
                            }
                        }
                    }

                    Button(action: {
                        if let amt = Double(amount), !amt.isZero {
                            let entry = "Sent to \(recipient) -$\(String(format: "%.2f", amt)) \(note.isEmpty ? "" : "(\(note))")"
                            transactionLog.insert(entry, at: 0)
                        }
                        withAnimation {
                            showConfirmation = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            dismiss()
                        }
                    }) {
                        Text("Send Money")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                .padding(.bottom)
            }
            .opacity(showConfirmation ? 0 : 1)

            // Confirmation checkmark animation (original, no biometrics)
            if showConfirmation {
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.green)
                        .scaleEffect(showConfirmation ? 1 : 0.5)
                        .animation(.easeInOut(duration: 0.3), value: showConfirmation)

                    Text("Sent!")
                        .font(.title)
                        .foregroundColor(.white)
                }
                .transition(.scale)
            }
        }
        .background(Color.black.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
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

extension String: Identifiable {
    public var id: String { self }
}

