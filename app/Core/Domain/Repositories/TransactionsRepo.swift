import Foundation

struct TransactionsRepo {
    var latests: () async -> Result<[Transaction], ApplicationError>
    var byGoal: (String, ByGoal) async -> Result<Paginated<[Transaction]>, ApplicationError>
    var create: (String, Create) async ->  Result<EmptyCodable, ApplicationError>
}

extension TransactionsRepo {
    struct ByGoal: Codable {
        var pageIndex: Int = 0
    }
    
    struct Create: Codable {
        var type: String
        var valueInCents: Int
    }
}
