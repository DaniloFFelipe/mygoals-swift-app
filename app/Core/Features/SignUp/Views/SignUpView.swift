import SwiftUI
import PhotosUI

struct SignUpView: View {
    @Environment(\.dismiss) var dissmiss
    @State var viewModel: SignUpViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            Button {
                dissmiss()
            } label: {
                Image(systemName: "chevron.left")
            }
            .hAlign(alignment: .leading)
            .padding(.bottom, .Spacing.xxl)
            
//            AvatarPicker()
//                .padding(.bottom, .Spacing.xxl)
            
            Input(text: $viewModel.name, placeholder: "Nome") {
                Image(systemName: "person")
            }
            .padding(.bottom, .Spacing.md)
            .autocorrectionDisabled()
            
            Input(text: $viewModel.email, placeholder: "E-mail") {
                Image(systemName: "at")
            }
            .padding(.bottom, .Spacing.md)
            .autocorrectionDisabled()
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            
            SecureInput(text: $viewModel.password, placeholder: "Password") {
                Image(systemName: "lock")
            }
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            
            Spacer()
            
            AppButton(config: .regular, label: "Cadastrar-se") {
                Task {
                    await viewModel.didTapToRegister {
                        dissmiss()
                    }
                }
            }
            .padding(.bottom, .Spacing.xl)
            
        }
        .padding(.horizontal)
        .screen(alignment: .topLeading)
        .background(Color.background)
        .toolbar(.hidden, for: .navigationBar)
        .onChange(of: viewModel.avatarItem) { oldValue, newValue in
            viewModel.onAvatarSelected()
        }
        .alert(
            "Ops!!",
            isPresented: .init(get: { viewModel.error != nil }, set: { if !$0 { viewModel.error = nil  } }),
            presenting: viewModel.error) { error in
                Button("Ok", role: .cancel) {
                    
                }
            } message: { details in
                Text(details)
            }
    }
    
    @ViewBuilder
    func AvatarPicker() -> some View {
        PhotosPicker(selection: $viewModel.avatarItem, matching: .images) {
            Circle()
                .fill(.clear)
                .stroke(Color.border, lineWidth: 1)
                .frame(width: 120, height: 120)
                .overlay {
                    if let image = viewModel.avatarImage {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(.circle)
                    } else {
                        Image(systemName: "person.fill.badge.plus")
                            .foregroundStyle(Color.foreground)
                            .font(.title)
                    }
                }
        }
    }
}

