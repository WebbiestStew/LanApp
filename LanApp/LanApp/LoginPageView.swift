import SwiftUI
import Supabase

struct LoginPageView: View {
    @Binding var isLoggedIn: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    // Removed showRegister state

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
            // Title
            Text("Sign In")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            // Email Field
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)

            // Password Field
            SecureField("Password", text: $password)
                .keyboardType(.default)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)

            // Sign In Button
            Button(action: {
                Task {
                    do {
                        let session = try await SupabaseManager.shared.client.auth.signIn(email: email, password: password)
                        isLoggedIn = session.user != nil
                    } catch {
                        print("Error signing in: \(error.localizedDescription)")
                    }
                }
            }) {
                HStack {
                    Image(systemName: "arrow.right.circle.fill")
                    Text("Sign In")
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0.12, green: 0.12, blue: 0.12))
                .cornerRadius(24)
                .fontWeight(.bold)
            }

            // Login Methods
            HStack {
                Button("Use Username") { }
                    .frame(width: 100, height: 70)
                    .background(Color(red: 0.12, green: 0.12, blue: 0.12))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .cornerRadius(24)
                Button("Use Email") { }
                    .frame(width: 100, height: 70)
                    .background(Color(red: 0.12, green: 0.12, blue: 0.12))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .cornerRadius(24)
                Button("Use Phone Number") {
                    // Set phone number input logic
                    // This is where you would switch the TextField to accept phone input
                }
                .frame(width: 100, height: 70)
                .background(Color(red: 0.12, green: 0.12, blue: 0.12))
                .foregroundColor(.white)
                .fontWeight(.bold)
                .cornerRadius(24)
            }

            // Navigation
            NavigationLink(destination: RegisterView()) {
                HStack {
                    Image(systemName: "person.badge.plus")
                    Text("Register")
                        .fontWeight(.bold)
                }
                .foregroundColor(.white)
                .padding()
                .background(Color(red: 0.12, green: 0.12, blue: 0.12))
                .cornerRadius(24)
            }

            NavigationLink(destination: ForgotPasswordView()) {
                Text("Forgot Password?")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(24)
            }

            // Call-to-Action Button
            Button(action: {
                // Invite Friend action
            }) {
                Text("Invite a Friend – Get $5 when they join!")
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green) // Let me know the specific green you want
                    .cornerRadius(16)
                    .padding(.top, 30)
            }

            }
            .padding()
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}

//forgot password view
struct ForgotPasswordView: View {
    @State private var resetEmail: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Forgot Password")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("No problem!")
                .font(.headline)
                .fontWeight(.bold)
            Text("Enter your email and we’ll send you a reset link.")
                .multilineTextAlignment(.center)
                .padding()

            TextField("Email", text: $resetEmail)
                .keyboardType(.emailAddress)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)

            Button(action: {
                Task {
                    do {
                        try await SupabaseManager.shared.client.auth.resetPasswordForEmail(resetEmail)
                        print("Reset link sent.")
                    } catch {
                        print("Failed to send reset link: \(error.localizedDescription)")
                    }
                }
            }) {
                Text("Send Reset Link")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.12, green: 0.12, blue: 0.12))
                    .cornerRadius(24)
                    .fontWeight(.bold)
            }

            Spacer()
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
}

struct LoginPageView_Previews: PreviewProvider {
    static var previews: some View {
        LoginPageView(isLoggedIn: .constant(false))
    }
}
