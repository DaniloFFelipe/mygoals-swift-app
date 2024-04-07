import SwiftUI

@Observable
class CreateGoalViewModel: Identifiable {
    var onGoalCreated: (() -> Void)? = nil
    var onGoalCreationError: ((ApplicationError) -> Void)? = nil
    
    var name: String = ""
    var value: String = ""
    var isLoading = false
    
    func valueMask(value: String) -> String {
        let value: Double = Double(Int(value) ?? 0/100)
        return "\(value.rounded().formatted(.currency(code: "brl")))"
    }
    
    var goalsRepo: GoalsRepo {
        LocatorService
            .shared
            .resolve(for: GoalsRepo.self)
    }
    
    func didTapToCreateGoal() async {
        guard
            let target = Double(value),
            !name.isEmpty
        else {return}
        
        isLoading = true
        let result = await self.goalsRepo.createGoal(
            .init(
                name: name,
                targetInCents: Int(target * 100)
            )
        )
        
        switch result {
        case .success:
            isLoading = false
            onGoalCreated?()
        case .failure(let err):
            isLoading = false
            onGoalCreationError?(err)
        }
    }
}
