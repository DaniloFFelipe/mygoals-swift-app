import SwiftUI

struct Goal: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    var currentValueInCents: Int
    let targetInCents: Int
    let completedAt: String?
    let createdAt: String
    let updatedAt: String
    
    var tagertPercentage: Double {
        return Double(currentValueInCents) / Double(targetInCents)
    }
    
    var formatedCurrent: String {
        let value: Double = Double(self.currentValueInCents/100)
        return "\(value.rounded().formatted(.currency(code: "brl")))"
    }
    
    var formatedTarget: String {
        let value: Double = Double(self.targetInCents/100)
        return "\(value.rounded().formatted(.currency(code: "brl")))"
    }
}
