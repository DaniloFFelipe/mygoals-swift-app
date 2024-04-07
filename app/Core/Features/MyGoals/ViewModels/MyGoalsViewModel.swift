import SwiftUI

@Observable
class MyGoalsViewModel {
    var myGoals: [Goal] = []
    var latestTransactions: [Transaction] = []
    var isLoadingGoals: Bool = false
    var isLoadingTransactions: Bool = false
    var hasFetchGoalsError: Bool = false
    var hasFetchTransactionsError: Bool = false
    
    var createViewModel: CreateGoalViewModel? = nil
    var destination: Destination? = nil
    
    var isSignOut: Bool = false
    
    var onSignOut: () -> Void
    
    init(
        myGoals: [Goal] = [],
        onSignOut: @escaping () -> Void = {}
    ) {
        self.myGoals = myGoals
        self.onSignOut = onSignOut
    }
    
    var isLoading: Bool {
        isLoadingGoals || isLoadingTransactions
    }
    
    var hasError: Bool {
        hasFetchGoalsError || hasFetchTransactionsError
    }
    
    var goalsRepo: GoalsRepo {
        LocatorService
            .shared
            .resolve(for: GoalsRepo.self)
    }
    
    var transactionsRepo: TransactionsRepo {
        LocatorService
            .shared
            .resolve(for: TransactionsRepo.self)
    }
    
    @MainActor func fetchActiveGoals() async {
        isLoadingGoals = true
        
        let goalsResult = await self.goalsRepo.active()
        switch goalsResult {
        case .success(let goals): self.myGoals = goals
        case .failure: self.hasFetchGoalsError = true;
        }
        
        isLoadingGoals = false
    }
    
    @MainActor func fetchLatestTransactions() async {
        isLoadingTransactions = true
        
        let result = await self.transactionsRepo.latests()
        switch result {
        case .success(let data): self.latestTransactions = data
        case .failure(let err): 
            print("Error", err)
            hasFetchTransactionsError = true
        }
        
        isLoadingTransactions = false
    }
    
    func refetch() {
        Task {
            await fetchActiveGoals()
            await fetchLatestTransactions()
        }
    }
    
    func didTapToCreateNewGoal() {
        let createViewModel = CreateGoalViewModel()
        createViewModel.onGoalCreated = {
            Task { [weak self] in
                await self?.onGoalCreated()
            }
        }
        self.createViewModel = createViewModel
    }
    
    @MainActor func onGoalCreated() async {
        let goalsResult = await self.goalsRepo.active()
        switch goalsResult {
        case .success(let goals): self.myGoals = goals
        case .failure: self.hasFetchGoalsError = true;
        }
    }
    
    func didTapOnGoal(of goal: Goal) {
        self.destination = .goal(goal: goal)
    }
    
    func didToSignOut() {
        self.isSignOut = true
    }
    
    func didTapToConfirmSignOut() {
        onSignOut()
    }
}


extension MyGoalsViewModel {
    enum Destination: Hashable {
        case goal(goal: Goal)
    }
}
