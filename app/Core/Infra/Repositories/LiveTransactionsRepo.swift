import Foundation

extension TransactionsRepo {
    static var live: TransactionsRepo {
        TransactionsRepo(
            latests: {
                let result = await ApiClient.shared.latestTransactions()
                switch result {
                case .success(let success): return .success(success)
                case .failure(let failure):
                    print("Failure", failure)
                    return .failure(.unexpected)
                }
            },
            byGoal: { goalId, pagination in
                let result = await ApiClient.shared.goalTransactions(goalId: goalId, pageIndex: pagination.pageIndex)
                switch result {
                case .success(let success): return .success(success)
                case .failure(let failure):
                    print("Failure", failure)
                    return .failure(.unexpected)
                }
            },
            create: { goalId, data in
                let result = await ApiClient.shared.createTransactions(goalId: goalId, data: data)
                switch result {
                case .success(let success): return .success(.init())
                case .failure(let failure):
                    print("Failure", failure)
                    return .failure(.unexpected)
                }
                
            }
        )
    }
}
