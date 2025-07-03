import Foundation
import Supabase

class AccountService {
    static let shared = AccountService()
    private let client = SupabaseManager.shared.client

    private init() {}

    func signUp(email: String, password: String) async throws -> Session {
        let response = try await client.auth.signUp(email: email, password: password)
        guard let session = response.session else {
            throw NSError(domain: "SignUpError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Session not found"])
        }
        return session
    }

    func signIn(email: String, password: String) async throws -> Session {
        let session = try await client.auth.signIn(email: email, password: password)
        return session
    }

    func signOut() async throws {
        try await client.auth.signOut()
    }

    func getCurrentUser() -> User? {
        return client.auth.currentUser
    }
}
