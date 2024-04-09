import SwiftUI

@Observable
class LoginWithoutPasswordViewModel {
    var email: String
    var destination: Destination?
    var errorMessage: String? = nil
    
    var accountSessionRepo: AccountSessionRepo {
        LocatorService
            .shared
            .resolve(for: AccountSessionRepo.self)
    }
    
    init(
        email: String = "danilo@client.com",
        destination: Destination? = nil
    ) {
        self.email = email
        self.destination = destination
    }
    
    func didTapToSendCode() async {
        guard !email.isEmail() else {
            errorMessage = "Email inválido"
            return
        }
        
        let result = await accountSessionRepo.sendCode(.init(email: email))
        switch result {
        case let .success(authCode): self.destination = .authCode(token: authCode.token)
        case let .failure(error):
            switch error {
            case let .invalidCredentails(message: message):
                errorMessage = message
            default:
                errorMessage = "Ops, nao foi possivel enviar seu codigo, tente novamente"
            }
        }
    }
    
    enum Destination: Hashable {
        case authCode(token: String)
    }
}
