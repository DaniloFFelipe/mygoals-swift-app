import Foundation

extension CGFloat {
    struct Spacing {
        static let xs: CGFloat = 2
        static let sm: CGFloat = 4
        static let md: CGFloat = 8
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let xxxl: CGFloat = 32
        static let xxxxl: CGFloat = 48
        
        
        static func custom(scale: CGFloat) -> CGFloat {
            return scale * 4
        }
    }
    
    static let spacings = Spacing()
}
