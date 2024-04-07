import Foundation

struct User: Codable {
    var id: String
    var email: String
    var fullName: String
    var avatarUrl: String?
}
