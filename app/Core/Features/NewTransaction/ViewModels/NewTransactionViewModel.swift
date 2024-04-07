//
//  NewTransactionViewModel.swift
//  app
//
//  Created by Danilo Felipe Araujo on 05/04/24.
//

import SwiftUI

@Observable
class NewTransactionViewModel: Identifiable {
    var goalId: String
    var value: String
    var isLoading = false
    var transationType: Transaction.TransactionType = .income
    
    var onTransactionCreated: ((String, Transaction.TransactionType, Int) -> Void)? = nil
    
    var transactionRepo: TransactionsRepo {
        LocatorService
            .shared
            .resolve(for: TransactionsRepo.self)
    }
    
    init(
        goalId: String,
        value: String = "",
        transationType: Transaction.TransactionType = .income
    ) {
        self.goalId = goalId
        self.value = value
        self.transationType = transationType
    }
    
    func didSelectTransactionType(_ type: Transaction.TransactionType) {
        self.transationType = type
    }
    
    @MainActor func didTapToCreateTransaction(onSuccess: @escaping () -> Void = {}) async {
        guard
            let target = Double(value)
        else {return}
        
        isLoading = true
        let valueInCents = Int(target * 100)
        let result = await self.transactionRepo.create(
            goalId,
            .init(type: transationType.rawValue, valueInCents: valueInCents)
        )
        
        switch result {
        case .success:
            isLoading = false
            onTransactionCreated?(goalId, transationType, valueInCents)
            onSuccess()
        case .failure(let err):
            isLoading = false
        }
    }
}
