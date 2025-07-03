//
//  MainView.swift
//  LanApp
//
//  Created by Diego Villarreal on 7/1/25.
//

import SwiftUI

struct MainView: View {
    @State private var phoneNumber: String = ""
    @State private var amount: String = ""
    @State private var isLoading = true
    @Binding var balance: Double
    @Binding var recentTransactions: [String]
    @State private var selectedRecipient: String?
    @Binding var accentColor: Color

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("LanApp")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)

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
                        Button(action: {}) {
                            Text("Deposit money")
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [accentColor, Color.blue]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }

                        Button(action: {}) {
                            Text("Withdraw")
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [accentColor, Color.blue]),
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
            QuickSendView(recipient: recipient, isAsk: false, transactionLog: $recentTransactions, balance: $balance, accentColor: $accentColor)
                .onDisappear {
                    print("Dismissed QuickSendView, recentTransactions: \(recentTransactions)")
                }
        }
    }
}
