//
//  RegisterView.swift
//  LanApp
//
//  Created by Diego Villarreal on 7/1/25.
//

import SwiftUI
import Supabase

struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sign Up!")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)

            TextField("Email", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

            Button(action: {
                register()
            }) {
                Text("Register")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.12, green: 0.12, blue: 0.12))
                    .cornerRadius(24)
                    .fontWeight(.bold)
            }

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
            }

            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Back to Login")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.12, green: 0.12, blue: 0.12))
                    .cornerRadius(24)
                    .fontWeight(.bold)
            }

        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
    
    func register() {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }

        Task {
            do {
                try await SupabaseManager.shared.client.auth.signUp(email: email, password: password)
                presentationMode.wrappedValue.dismiss() // Back to Login after success
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    RegisterView()
}
