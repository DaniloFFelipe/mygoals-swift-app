import SwiftUI
import PhotosUI

@Observable
class SignUpViewModel {
    var name: String = ""
    var email: String = ""
    var password: String = ""
    
    var error: String? = nil
    
    var isLoading: Bool = false
    
    var accountSessionRepo: AccountSessionRepo {
        LocatorService
            .shared
            .resolve(for: AccountSessionRepo.self)
    }
    
    var avatarItem: PhotosPickerItem? = nil
    var avatarImage: Image? = nil
    
    var destination: PresentationDestination? = nil
    
    enum PresentationDestination: Equatable {
        case imagePicker
    }
    
    func didTapToSelectAvatar() {
        self.destination = .imagePicker
    }
    
    func onAvatarSelected() {
        Task {
            if let loaded = try? await avatarItem?.loadTransferable(type: Image.self) {
                avatarImage = loaded
            } else {
                print("Failed")
            }
        }
    }
    
    @MainActor func didTapToRegister(onSuccess: @escaping () -> Void = {}) async {
        guard validateForm() else {return}
        let result = await accountSessionRepo.register(
            .init(
                fullName: name,
                email: email,
                password: password
            )
        )
        
        switch result {
        case .success:
            onSuccess()
        case .failure(let error):
            switch error {
            case .invalidCredentails(message: let msg): self.error = msg
            default: self.error = "Error interno"
            }
        }
    }
    
    private func validateForm() -> Bool{
        if !name.isName() {
            error = "O nome deve ter pelo menos 3 digitos"
            return false
        }
        
        if email.isEmpty || !email.isEmail() {
            error = "Email inválido"
            return false
        }
        
        if !password.isPassword() {
            error = "Sua senha deve ter pelo menos 6 digitos"
            return false
        }
        
        return true
    }
}

