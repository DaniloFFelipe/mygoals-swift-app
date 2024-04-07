import SwiftUI

enum Radii: CGFloat {
    case sm = 5
    case md = 10
    case lg = 15
    case full = 0
}

extension View {
    @ViewBuilder
    func radii(_ value: Radii) -> some View {
        switch value {
        case .full:
            self.clipShape(.circle)
        default:
            self.clipShape(.rect(cornerRadius: value.rawValue))
        }
    }
}
