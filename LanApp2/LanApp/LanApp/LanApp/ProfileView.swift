//
//  ProfileView.swift
//  LanApp
//
//  Created by Diego Villarreal on 7/1/25.
//

import AudioToolbox
import SwiftUI
import UIKit
import AudioToolbox

struct ProfileView: View {
    let name: String
    let username: String
    var isMe: Bool = false
    @Binding var transactionLog: [String]
    @Binding var balance: Double
    @Binding var accentColor: Color

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
                        .fill(accentColor)
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
                        .foregroundColor(.accentColor)
                }
            }

            HStack(spacing: 20) {
                NavigationLink(destination: QuickSendView(recipient: name, isAsk: true, transactionLog: isMe ? $transactionLog : .constant([]), balance: $balance, accentColor: $accentColor)) {
                    Text("Ask")
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(accentColor)
                        .cornerRadius(10)
                }

                NavigationLink(destination: QuickSendView(recipient: name, isAsk: false, transactionLog: isMe ? $transactionLog : .constant([]), balance: $balance, accentColor: $accentColor)) {
                    Text("Deposit")
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(accentColor)
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

