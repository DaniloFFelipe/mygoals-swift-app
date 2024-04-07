import Foundation
import Combine

struct AccountSessionRepo {
    var loginWithPassword: (LoginWithPassword) async -> Result<AccountSession, ApplicationError>
    var loginWithCode: (LoginWithCode) async -> Result<AccountSession, ApplicationError>
    var sendCode: (SendCode) async -> Result<AuthCodeSession, ApplicationError>
    var restore: () async -> AccountSession?
    var store: (AccountSession) async -> Void
    var signOut: () async -> Void
}

extension AccountSessionRepo {
    struct LoginWithPassword: Codable {
        var email: String
        var password: String
    }
    
    struct LoginWithCode: Codable {
        var code: String
        var token: String
    }
    
    struct SendCode: Codable {
        var email: String
    }
}
