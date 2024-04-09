import Foundation

extension Endpoint {
    static func loginWithPassword(body: AccountSessionRepo.LoginWithPassword) -> Endpoint<AccountSessionRepo.LoginWithPassword, AccountSession> {
        Endpoint<AccountSessionRepo.LoginWithPassword, AccountSession>(
            path: "/sessions/auth/password",
            body: body,
            method: .post,
            response: AccountSession.self
        )
    }
    
    static func loginWithCode(body: AccountSessionRepo.LoginWithCode) -> Endpoint<AccountSessionRepo.LoginWithCode, AccountSession> {
        .init(path: "/sessions/auth/code", body: body, method: .post, response: AccountSession.self)
    }
    
    static func sendAuthCode(body: AccountSessionRepo.SendCode) -> Endpoint<AccountSessionRepo.SendCode, AuthCodeSession> {
        .init(path: "/sessions/auth/request-code", body: body, method: .post, response: AuthCodeSession.self)
    }
    
    static var activeGoal: Endpoint<EmptyCodable, [Goal]> {
        .init(path: "/goals/active", body: nil, response: [Goal].self)
    }
    
    static var latestTransactions: Endpoint<EmptyCodable, [Transaction]> {
        .init(path: "/transactions/latest", body: nil, response: [Transaction].self)
    }
    
    static func goalTransactions(goalId: String, pageIndex: Int) -> Endpoint<TransactionsRepo.ByGoal, Paginated<[Transaction]>> {
        .init(
            path: "/goals/\(goalId)/transactions",
            body: .init(pageIndex: pageIndex),
            response: Paginated<[Transaction]>.self
        )
    }
    
    static func createTransaction(goalId: String, data: TransactionsRepo.Create) -> Endpoint<TransactionsRepo.Create, EmptyCodable> {
        .init(
            path: "/goals/\(goalId)/transactions",
            body: data,
            method: .post,
            response: EmptyCodable.self
        )
    }

    static func createGoal(_ data: GoalsRepo.CreateGoal) -> Endpoint<GoalsRepo.CreateGoal, EmptyCodable> {
        .init(path: "/goals", body: data, method: .post, response: EmptyCodable.self)
    }
    
    static func register(_ data: AccountSessionRepo.Register) -> Endpoint<AccountSessionRepo.Register, EmptyCodable> {
        .init(path: "/accounts/register", body: data, method: .post, response: EmptyCodable.self)
    }
}

