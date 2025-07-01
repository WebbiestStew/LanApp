import Foundation
import Supabase

class AuthService {
    private let client = SupabaseManager.shared.client
    
    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Task {
            do {
                try await client.auth.signUp(email: email, password: password)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Task {
            do {
                try await client.auth.signIn(email: email, password: password)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    func signOut(completion: @escaping (Error?) -> Void) {
        Task {
            do {
                try await client.auth.signOut()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    func getCurrentUser() async -> User? {
        do {
            return try await client.auth.session.user
        } catch {
            print("Error getting user: \(error)")
            return nil
        }
    }
    
    func isLoggedIn() async -> Bool {
        do {
            _ = try await client.auth.session
            return true
        } catch {
            return false
        }
    }
}
