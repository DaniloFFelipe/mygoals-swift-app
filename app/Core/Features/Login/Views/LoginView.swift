import SwiftUI

struct LoginView: View {
    @State var viewModel: LoginViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Suas Metas")
                .font(.head1)
                .foregroundStyle(Color.foreground)
                .padding(.bottom, .Spacing.sm)
                .hAlign(alignment: .leading)
            
            Text("Poupe hoje para colher os frutos amanhã.")
                .font(.base1)
                .foregroundStyle(Color.mutedforeground)
                .padding(.bottom, .Spacing.xxxl)
                .hAlign(alignment: .leading)
            
            Input(text: $viewModel.email, placeholder: "E-mail") {
                Image(systemName: "at")
            }
            .padding(.bottom, .Spacing.md)
            
            SecureInput(text: $viewModel.password, placeholder: "Password") {
                Image(systemName: "lock")
            }
            .padding(.bottom, .Spacing.lg)
            
            AppButton(config: .regular, label: "Entrar", loading: viewModel.isLoadingLogin) {
                Task {
                    await viewModel.didTapToLoginIn()
                }
            }
            .padding(.bottom, .Spacing.lg)
            
            AppButton(config: .ghost, label: "Entrar sem senha") {
                viewModel.didTapToLoginWithoutPassword()
            }
            
            Spacer()
            
            AppButton(config: .link, label: "Não possui conta? Cadastre-se agora") {
                viewModel.didTapToSignUp()
            }
            
        }
        .padding(.top, 24)
        .padding(.horizontal)
        .screen(alignment: .topLeading)
        .background(Color.background)
        .navigationDestination(item: $viewModel.destination) { destination in
            switch destination {
            case .loginWithoutPassword:
                LoginWithoutPasswordView(viewModel: .init(email: "danilo@client.com"))
            case .signUp:
                SignUpView(viewModel: SignUpViewModel())
            }
        }
        .alert(
            isPresented: .init(
                get: { viewModel.errorMessage != nil },
                set: { data in if !data { viewModel.errorMessage = nil } }
            )
        ) {
            Alert(
                title: Text("Ops!"),
                message: Text(viewModel.errorMessage ?? ""),
                dismissButton: .cancel()
            )
        }
        
    }
}

#Preview {
    AppView()
}
