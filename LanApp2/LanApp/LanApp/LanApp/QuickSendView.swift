//
//  QuickSendView.swift
//  LanApp
//
//  Created by Diego Villarreal on 7/1/25.
//

import AudioToolbox
import SwiftUI
import UIKit
import AudioToolbox

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
    @Binding var accentColor: Color

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
                                    if item == "⌫" {
                                        isTyping = true
                                        handleInput(item)
                                        AudioServicesPlaySystemSound(1104) // iOS keyboard tap
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            isTyping = false
                                        }
                                    } else if item == "." {
                                        isTyping = true
                                        handleInput(item)
                                        AudioServicesPlaySystemSound(1104) // iOS keyboard tap
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            isTyping = false
                                        }
                                    } else {
                                        // item is digit 0-9
                                        isTyping = true
                                        amount += item
                                        AudioServicesPlaySystemSound(1104) // iOS keyboard tap
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
                                    gradient: Gradient(colors: [accentColor, Color.blue]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(12)
                    }
                }
                .disabled(isProcessing)
                .padding(.horizontal)
                .padding(.top, 10)
            }
            .opacity(showConfirmation ? 0 : 1)

            // Confirmation checkmark animation with bounce effect and background
            if showConfirmation {
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.accentColor)
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
        .background(Color.black)
        .ignoresSafeArea()
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
                    .background(accentColor)
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
