import Foundation

@Observable
class AppViewModel {
    var isLoading: Bool = true
    var session: AccountSession?
    
    var isAuthenticated: Bool {
        self.session != nil
    }
    
    var accountSessionRepo: AccountSessionRepo {
        LocatorService
            .shared
            .resolve(for: AccountSessionRepo.self)
    }
    
    init(session: AccountSession? = nil) {
        if let session {
            Network.shared.addBearerToken(session.token)
        }
        
        self.session = session
    }
    
    func signUp(session: AccountSession) {
        Network.shared.addBearerToken(session.token)
        self.session = session
        
        Task {
            await accountSessionRepo.store(session)
        }
    }
    
    func signUp() {
        self.session = nil
        Network.shared.removeBearerToken()
        
        Task {
            await accountSessionRepo.signOut()
        }
    }
    
    @MainActor func findLastSession() async {
        defer {self.isLoading = false}
        guard let result = await accountSessionRepo.restore() else {return}
        self.signUp(session: result)
    }
}

extension AppViewModel {
    static var defaults: AppViewModel {
        AppViewModel()
    }
}
