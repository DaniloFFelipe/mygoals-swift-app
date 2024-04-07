//
//  LoginWithoutPasswordView.swift
//  app
//
//  Created by Danilo Felipe Araujo on 28/03/24.
//

import SwiftUI

struct LoginWithoutPasswordView: View {
    @State var viewModel: LoginWithoutPasswordViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Digite seu email")
                .font(.head1)
                .foregroundStyle(Color.foreground)
                .padding(.bottom, .Spacing.sm)
                .hAlign(alignment: .leading)
            
            Text("Digite seu email para enviarmos seu codigo de acesso")
                .font(.base1)
                .foregroundStyle(Color.mutedforeground)
                .padding(.bottom, .Spacing.xxxl)
                .hAlign(alignment: .leading)
            
            Input(text: $viewModel.email, placeholder: "E-mail") {
                Image(systemName: "at")
            }
            .padding(.bottom, .Spacing.md)
            
            
            AppButton(config: .regular, label: "Continuar") {
                Task {
                    await viewModel.didTapToSendCode()
                }
            }
            .padding(.bottom, .Spacing.lg)
            
            Spacer()
        }
        .padding(.top, 24)
        .padding(.horizontal)
        .screen(alignment: .topLeading)
        .background(Color.background)
        .navigationDestination(item: $viewModel.destination) { destination in
            switch destination {
            case let .authCode(token: token):
                LoginWithCodeView(viewModel: .init(token: token))
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginWithoutPasswordView(viewModel: .init())
    }
}
