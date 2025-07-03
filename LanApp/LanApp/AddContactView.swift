//
//  AddContactView.swift
//  LanApp
//
//  Created by Diego Villarreal on 7/1/25.
//

import AudioToolbox
import SwiftUI
import UIKit
import AudioToolbox

struct AddContactView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var username: String = ""
    @Binding var accentColor: Color

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
                    .background(accentColor)
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
