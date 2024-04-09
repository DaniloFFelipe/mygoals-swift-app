import SwiftUI


extension String {
    func isEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isPassword() -> Bool {
        guard self.count >= 6 else {return false}
        return true
    }
    
    func isName() -> Bool {
        guard self.count >= 3 else {return false}
        return true
    }
}
