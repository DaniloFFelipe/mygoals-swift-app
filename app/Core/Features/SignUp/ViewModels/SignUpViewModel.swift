import SwiftUI
import PhotosUI

@Observable
class SignUpViewModel {
    var name: String = ""
    var email: String = ""
    var password: String = ""
    
    var isLoading: Bool = false
    
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
}

