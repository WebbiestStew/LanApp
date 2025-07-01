struct PinLockView: View {
    @Binding var isUnlocked: Bool
    @Binding var accentColor: Color
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
                    .background(accentColor)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.black)
        .ignoresSafeArea()
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

// struct ContentView is intentionally not marked with @main.
struct ContentView: View {
    @State private var accentColor: Color = .green
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
                    Color.black.ignoresSafeArea()
                    if showSplash {
                        SplashView(showSplash: $showSplash)
                    } else {
                        TabView(selection: $selectedTab) {
                            MainView(balance: $balance, recentTransactions: $transactionLog, accentColor: $accentColor)
                                .tabItem {
                                    AnimatedTabIcon(icon: "creditcard", isSelected: selectedTab == 0)
                                }
                                .tag(0)

                            ContactsView(transactionLog: $transactionLog, balance: $balance, accentColor: $accentColor)
                                .tabItem {
                                    AnimatedTabIcon(icon: "person.2.fill", isSelected: selectedTab == 1)
                                }
                                .tag(1)

                            HistoryView(transactions: transactionLog, accentColor: $accentColor)
                                .tabItem {
                                    AnimatedTabIcon(icon: "clock.arrow.circlepath", isSelected: selectedTab == 2)
                                }
                                .tag(2)

                            SettingsView(accentColor: $accentColor)
                                .tabItem {
                                    AnimatedTabIcon(icon: "gearshape.fill", isSelected: selectedTab == 3)
                                }
                                .tag(3)
                        }
                        .accentColor(accentColor)
                    }
                }
                .ignoresSafeArea()
                .preferredColorScheme(.dark)
            } else {
                PinLockView(isUnlocked: $isUnlocked, accentColor: $accentColor)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ChangeAccentColor"))) { notification in
            if let newColor = notification.object as? Color {
                accentColor = newColor
            }
        }
    }
}

#Preview {
    ContentView()
}



extension String: @retroactive Identifiable {
    public var id: String { self }
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

extension View {
    func shimmering() -> some View {
        self
            .modifier(ShimmerModifier())
    }
}


