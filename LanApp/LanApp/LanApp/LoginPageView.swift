import SwiftUI

struct LoginPageView: View {
    @Binding var isLoggedIn: Bool
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Sign In")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            // Email Field
            TextField("you@email.com", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

            // Password Field
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

            // Sign In Button
            Button(action: {
                // Handle sign in
            }) {
                Text("Sign In")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(8)
            }

            // Login Methods
            HStack {
                Button("Use Username") { }
                    .padding()
                    .background(Color(.darkGray))
                    .foregroundColor(.white)
                    .cornerRadius(8)

                Button("Use Email") { }
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(8)

                Button("Use Phone Number") { }
                    .padding()
                    .background(Color(.darkGray))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            // Navigation
            Button("Go to Register Form") { }
                .foregroundColor(.purple)

            Button("Forgot Password?") { }
                .foregroundColor(.purple)

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

struct LoginPageView_Previews: PreviewProvider {
    static var previews: some View {
        LoginPageView(isLoggedIn: .constant(false))
    }
}
