import SwiftUI

struct Transaction: Codable, Identifiable {
    let id: String
    let type: String
    let valueInCents: Int
    let description: String?
    let goalId: String
    let createdAt: String
    let updatedAt: String
    let goalName: String?
    
    
    var formatedValue: String {
        let value: Double = Double(self.valueInCents/100)
        return "\(value.rounded().formatted(.currency(code: "brl")))"
    }
    
    var transactionType: TransactionType {
        TransactionType.init(rawValue: self.type)!
    }
    
    var formatedCreatedAt: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: Date())
    }
    
    enum TransactionType: String {
        case income = "INCOME"
        case outcome = "OUTCOME"
        
        var color: Color {
            switch self {
            case .income:
                return Color.success
            case .outcome:
                return Color.destructive
            }
        }
        
        var sign: String {
            switch self {
            case .income:
                return "+"
            case .outcome:
                return "-"
            }
        }
        
        var operationLabel: String {
            switch self {
            case .income:
                return "Depósito"
            case .outcome:
                return "Saque"
            }
        }
    }
}
