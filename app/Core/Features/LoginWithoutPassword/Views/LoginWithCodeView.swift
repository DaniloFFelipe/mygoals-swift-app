//
//  LoginWithCodeView.swift
//  app
//
//  Created by Danilo Felipe Araujo on 28/03/24.
//

import SwiftUI

struct LoginWithCodeView: View {
    @Environment(\.dismiss) var dismiss
    @State var viewModel: LoginWithCodeViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Digite seu codigo")
                .font(.head1)
                .foregroundStyle(Color.foreground)
                .padding(.bottom, .Spacing.sm)
                .hAlign(alignment: .leading)
            
            Text("Digite o codigo que enviarmos para o seu e-mail")
                .font(.base1)
                .foregroundStyle(Color.mutedforeground)
                .padding(.bottom, .Spacing.xxxl)
                .hAlign(alignment: .leading)
            
            Input(text: $viewModel.code, placeholder: "Seu codigo de acesso")
            .padding(.bottom, .Spacing.md)
            
            AppButton(config: .ghost, label: "Reenviar") {
                Task {
                    await viewModel.didTapToLoginIn()
                }
            }
            
            Spacer()
            
            AppButton(config: .regular, label: "Entrar") {
                Task {
                    await viewModel.didTapToLoginIn()
                }
            }
            .padding(.bottom, .Spacing.lg)
        }
        .padding(.top, 24)
        .padding(.horizontal)
        .screen(alignment: .topLeading)
        .background(Color.background)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.foreground)
                }
            }
        }
    }
}

#Preview {
    AppView()
}
