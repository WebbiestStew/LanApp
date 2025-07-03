import Supabase
import Foundation

final class SupabaseManager {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient

    private init() {
        client = SupabaseClient(
            supabaseURL: URL(string: "https://ylhlcpupqqnxwnjzzaaw.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlsaGxjcHVwcXFueHduanp6YWF3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTEzMjY4NjksImV4cCI6MjA2NjkwMjg2OX0.206r5tFdAk43YhSTurIXyvKvyTTIeaAIOSFIBKXbQkw"
        )
    }
}
