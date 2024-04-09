import Foundation
import Combine

extension AccountSessionRepo {
    static var live: AccountSessionRepo {
        .init(
            register: { data in
                let result  = await ApiClient
                    .shared
                    .register(name: data.email, email: data.email, password: data.password)
                
                switch result {
                case .success(let success):
                    return .success(success)
                    
                case .failure(let failure):
                    print("FAILURE: \(failure)")
                    switch failure {
                    case .badRequest, .unauthorized:
                        return .failure(.invalidCredentails(message: "Invalid email or password"))
                    default: return .failure(.unexpected)
                    }
                }
            },
            loginWithPassword: { data in
                let result  = await ApiClient
                    .shared
                    .loginWithPassword(email: data.email, password: data.password)
                
                switch result {
                case .success(let success):
                    return .success(success)
                    
                case .failure(let failure):
                    print("FAILURE: \(failure)")
                    switch failure {
                    case .badRequest, .unauthorized:
                        return .failure(.invalidCredentails(message: "Invalid email or password"))
                    default: return .failure(.unexpected)
                    }
                }
            },
            loginWithCode: {
                let result = await ApiClient
                    .shared
                    .loginWithCode(code: $0.code, token: $0.token)
                
                switch result {
                case .success(let success):
                    return .success(success)
                case .failure(let failure):
                    switch failure {
                    case .badRequest, .unauthorized:
                        return .failure(.invalidCredentails(message: "Invalid code"))
                    default: return .failure(.unexpected)
                    }
                }
            },
            sendCode: { data in
                let result = await ApiClient
                    .shared
                    .requestAuthCode(email: data.email)
                
                switch result {
                case .success(let success):
                    return .success(success)
                case .failure(let failure):
                    switch failure {
                    case .badRequest, .unauthorized:
                        return .failure(.invalidCredentails(message: "Invalid code"))
                    default: return .failure(.unexpected)
                    }
                }
            },
            restore: {
                let lastSession = StorageService.getValue(forKey: .session, of: AccountSession.self)
                return lastSession
            },
            store: { session in
                StorageService.setValue(forKey: .session, data: session)
            },
            signOut: {
                StorageService.removeValue(forKey: .session)
            }
        )
    }
}
