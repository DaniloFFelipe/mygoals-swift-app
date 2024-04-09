import Foundation
import Combine

struct ApiClient {
    func register(name: String, email: String, password: String) async -> Result<EmptyCodable, NetworkError> {
        await Network
            .shared
            .serve(
                to: .register(
                    .init(fullName: name, email: email, password: password)
                )
            )
    }
    
    func requestAuthCode(email: String) async -> Result<AuthCodeSession, NetworkError> {
         await Network
            .shared
            .serve(to: .sendAuthCode(body: .init(email: email)))
    }
    
    
    func loginWithCode(code: String, token: String) async -> Result<AccountSession, NetworkError> {
        await Network
            .shared
            .serve(to: .loginWithCode(body: .init(code: code, token: token)))
    }
    
    func loginWithPassword(email: String, password: String) async -> Result<AccountSession, NetworkError> {
        await Network
            .shared
            .serve(to: .loginWithPassword(body: .init(email: email, password: password)))
    }
    
    func activeGoals() async -> Result<[Goal], NetworkError>{
        await Network
            .shared
            .serve(to: .activeGoal)
    }
    
    func latestTransactions() async -> Result<[Transaction], NetworkError>{
        await Network
            .shared
            .serve(to: .latestTransactions)
    }
    
    func createGoal(
        name: String,
        targetInCents: Int
    ) async -> Result<EmptyCodable, NetworkError> {
        await Network
            .shared
            .serve(to: .createGoal(.init(name: name, targetInCents: targetInCents)))
    }
    
    func goalTransactions(goalId: String, pageIndex: Int? = nil) async -> Result<Paginated<[Transaction]>, NetworkError>{
        await Network
            .shared
            .serve(to: .goalTransactions(goalId: goalId, pageIndex: pageIndex ?? 0))
    }
    
    func createTransactions(goalId: String, data: TransactionsRepo.Create) async -> Result<EmptyCodable, NetworkError>{
        await Network
            .shared
            .serve(to: .createTransaction(goalId: goalId, data: data))
    }
}


extension ApiClient {
    static var shared: ApiClient {
        ApiClient()
    }
}
