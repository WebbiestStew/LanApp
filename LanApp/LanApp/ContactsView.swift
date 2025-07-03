//
//  ContactsView.swift
//  LanApp
//
//  Created by Diego Villarreal on 7/1/25.
//

import AudioToolbox
import SwiftUI
import UIKit
import AudioToolbox

struct ContactsView: View {
    @State private var contacts: [String] = []
    let myUsername = "diegov"
    let myName = "Diego Villarreal"
    @Binding var transactionLog: [String]
    @Binding var balance: Double
    @State private var isLoading = true
    @Binding var accentColor: Color

    var body: some View {
        NavigationStack {
            if isLoading {
                ShimmerPlaceholderList()
            } else {
                List {
                    Section(header: Text("Me").foregroundColor(.white)) {
                        NavigationLink(destination: ProfileView(name: myName, username: myUsername, isMe: true, transactionLog: $transactionLog, balance: $balance, accentColor: $accentColor)) {
                            HStack {
                                Circle()
                                    .fill(accentColor)
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
                            NavigationLink(destination: ProfileView(name: contact, username: "\(contact.lowercased())", isMe: false, transactionLog: .constant(transactionLog), balance: $balance, accentColor: $accentColor)) {
                                HStack {
                                    Circle()
                                        .fill(accentColor)
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
                            .background(accentColor)
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
                        NavigationLink(destination: AddContactView(accentColor: $accentColor)) {
                            Image(systemName: "plus")
                                .foregroundColor(.accentColor)
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
