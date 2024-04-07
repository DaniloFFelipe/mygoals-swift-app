//
//  CreateGoalView.swift
//  app
//
//  Created by Danilo Felipe Araujo on 03/04/24.
//

import SwiftUI
import Combine

struct CreateGoalView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var viewModel: CreateGoalViewModel
    
    var body: some View {
        Screen(background: .muted) { Content() }
    }
    
    @ViewBuilder
    private func Content() -> some View {
        VStack(spacing: .Spacing.xl) {
            Header()
            
            Input(text: $viewModel.name, placeholder: "Nome da meta", backgroundColor: .background)
            
            MaskedInput(
                text: $viewModel.value,
                placeholder: "Valor",
                backgroundColor: .background,
                formatter: CurrrencyFormatter()
            )
            .keyboardType(.decimalPad)
        
            AppButton(label: "Criar", loading: viewModel.isLoading, action: {
                Task {
                    await viewModel.didTapToCreateGoal()
                    dismiss()
                }
            })
        }
        .padding(.Spacing.xxl)
        .screen(alignment: .topLeading)
    }
    
    
    @ViewBuilder
    private func Header() -> some View {
        HStack {
            Text("Nova meta")
                .font(.strong)
                .foregroundStyle(Color.foreground)
            
            Spacer()
            
            AppButton(config: .link, action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.mutedforeground)
            }
        }
    }
}
