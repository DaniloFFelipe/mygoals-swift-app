import Foundation

struct GoalsRepo {
    let active: () async ->  Result<[Goal], ApplicationError>
    let createGoal: (CreateGoal) async -> Result<EmptyCodable, ApplicationError>
}

extension GoalsRepo {
    struct CreateGoal: Codable {
        let name: String
        let targetInCents: Int
    }
}

extension GoalsRepo {
    static var successMock: GoalsRepo {
        GoalsRepo(
            active: {
                return .success([
                    .init(
                        id: UUID().uuidString,
                        name: "iPhone",
                        currentValueInCents: 500,
                        targetInCents: 1000,
                        completedAt: nil,
                        createdAt: Date().ISO8601Format(),
                        updatedAt: Date().ISO8601Format()
                    ),
                    .init(
                        id: UUID().uuidString,
                        name: "Macbook",
                        currentValueInCents: 500,
                        targetInCents: 1000,
                        completedAt: nil,
                        createdAt: Date().ISO8601Format(),
                        updatedAt: Date().ISO8601Format()
                    ),
                    .init(
                        id: UUID().uuidString,
                        name: "Sony Headphone",
                        currentValueInCents: 500,
                        targetInCents: 1000,
                        completedAt: nil,
                        createdAt: Date().ISO8601Format(),
                        updatedAt: Date().ISO8601Format()
                    )
                ])
            },
            createGoal: { _ in .success(.init()) }
        )
    }
}
