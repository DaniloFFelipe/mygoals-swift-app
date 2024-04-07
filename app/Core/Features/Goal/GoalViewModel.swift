import SwiftUI

@Observable
class GoalViewModel {
    var goal: Goal
    private var nextPageIndex: Int? = 0
    private(set) var transactions: [Transaction] = []
    
    var newTransactionViewModel: NewTransactionViewModel? = nil
    
    var transactionRepo: TransactionsRepo {
        LocatorService
            .shared
            .resolve(for: TransactionsRepo.self)
    }
    
    init(
        goal: Goal
    ) {
        self.goal = goal
    }
    
    
    @MainActor func fetchTransacitons() async {
        let result = await transactionRepo.byGoal(
            goal.id, 
            .init(pageIndex: nextPageIndex ?? 0)
        )
        switch result {
        case .success(let success):
            transactions = success.data
            self.nextPageIndex = success.meta.nextPageIndex
        case .failure(let failure):
            print(failure)
            break
        }
    }
    
    
    @MainActor func fetchNextPageOfTransacitons(_ lastId: String) async {
        guard let last = transactions.last, last.id == lastId else {return}
        guard let nextPageIndex else {return}
        
        let result = await transactionRepo.byGoal(
            goal.id,
            .init(pageIndex: nextPageIndex)
        )
        switch result {
        case .success(let success):
            transactions.append(contentsOf: success.data)
            self.nextPageIndex = success.meta.nextPageIndex
        case .failure(let failure):
            print(failure)
            break
        }
    }
    
    func didTapToCreateTransaction() {
        let viewModel: NewTransactionViewModel = .init(goalId: goal.id)
        viewModel.onTransactionCreated = { _, type, value in
            Task { [weak self] in
                await self?.fetchTransacitons()
                self?.updateGoal(type: type, value: value)
            }
        }
        self.newTransactionViewModel = viewModel
    }
    
    private func updateGoal(type: Transaction.TransactionType, value: Int) {
        withAnimation {
            switch type {
            case .income:
                goal.currentValueInCents += value
            case .outcome:
                goal.currentValueInCents -= value
            }
        }
    }
}
