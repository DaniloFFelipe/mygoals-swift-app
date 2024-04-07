import Foundation

extension GoalsRepo {
    static var live: GoalsRepo {
        GoalsRepo(
            active: {
                let result = await ApiClient.shared.activeGoals()
                switch result {
                case .success(let success):
                    return .success(success)
                case .failure:
                    return .failure(.unexpected)
                }
            },
            createGoal: { data in
                let result = await ApiClient.shared.createGoal(name: data.name, targetInCents: data.targetInCents)
                switch result {
                case .success:
                    return .success(.init())
                case let .failure(err):
                    print(err)
                    if err == .badRequest {
                        return .failure(.invalidParams)
                    }
                    
                    return .failure(.unexpected)
                }
            }
        )
    }
}
