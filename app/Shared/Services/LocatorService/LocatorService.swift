import Foundation
import Swinject

class LocatorService {
    static let shared: LocatorService = .init()
    private let container = Container()
    
    
    func resolve<T>(for type: T.Type) -> T {
        guard let dep = container.resolve(type) else {
            fatalError("Type was not registered")
        }
        
        return dep
    }
    
    func start(_ cb: @escaping (Container) -> Void) {
        cb(self.container)
    }
    
    func startLocator() {
        container.register(AccountSessionRepo.self, factory: { _ in .live })
        container.register(GoalsRepo.self, factory: { _ in .live })
        container.register(TransactionsRepo.self, factory: { _ in .live })
    }
}
