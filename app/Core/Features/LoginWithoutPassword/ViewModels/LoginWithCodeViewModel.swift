import SwiftUI

@Observable
class LoginWithCodeViewModel {
    var token: String
    var code: String = ""
    
    var accountSessionRepo: AccountSessionRepo {
        LocatorService
            .shared
            .resolve(for: AccountSessionRepo.self)
    }
    
    init(token: String) {
        self.token = token
    }
    
    func didTapToLoginIn() async {
        guard code.count == 6 else {return}
        
        let result = await accountSessionRepo
            .loginWithCode(.init(code: code, token: token))
        
        switch result {
        case let .success(session): print(session)
        case let .failure(err): print(err)
        }
    }
}
