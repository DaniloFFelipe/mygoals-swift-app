import SwiftUI

@Observable
class LoginViewModel {
    var email: String
    var password: String
    var errorMessage: String?
    
    var isLoadingLogin: Bool = false
    
    var destination: Destination? = nil
    
    var delegate: LoginViewModelDelegate? = nil
    
    init(
        email: String = "",
        password: String = "",
        destination: Destination? = nil,
        delegate: LoginViewModelDelegate? = nil
    ) {
        self.email = email
        self.password = password
        self.errorMessage = errorMessage
    
        self.destination = destination
        self.delegate = delegate
    }
    
    var accountSessionRepo: AccountSessionRepo {
        LocatorService
            .shared
            .resolve(for: AccountSessionRepo.self)
    }
    
    func didTapToLoginIn() async {
        guard validateForm() else {return}
        
        isLoadingLogin = true
        let result = await accountSessionRepo
            .loginWithPassword(.init(email: email.lowercased(), password: password))
        
        switch result {
        case let .success(session):
            delegate?.onLogin(session)
        case let .failure(error):
            isLoadingLogin = false
            switch error {
            case let .invalidCredentails(message: message):
                errorMessage = message
            default:
                errorMessage = "Ops, nao foi possivel enviar seu codigo, tente novamente"
            }
        }
    }
    
    func didTapToLoginWithoutPassword() {
        self.destination = .loginWithoutPassword
    }
    
    func didTapToSignUp() {
        self.destination = .signUp
    }
    
    enum Destination: Equatable {
        case signUp
        case loginWithoutPassword
    }
    
    private func validateForm() -> Bool{
        if email.isEmpty {
            errorMessage = "Email obrigatório"
            return false
        }
        
        if !email.isEmail() {
            errorMessage = "Email inválido"
            return false
        }
        
        if !password.isPassword() {
            errorMessage = "Sua senha deve ter pelo menos 6 digitos"
            return false
        }
        
        return true
    }
}

struct LoginViewModelDelegate {
    var onLogin: (AccountSession) -> Void
}
