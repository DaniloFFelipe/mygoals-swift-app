//
//  NewTransactionView.swift
//  app
//
//  Created by Danilo Felipe Araujo on 05/04/24.
//

import SwiftUI
import Combine

struct NewTransactionView: View {
    @State var viewModel: NewTransactionViewModel
    @Environment(\.dismiss) var dismiss
    
    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
          formatter.numberStyle = .currency
          return formatter
    }
    
    var body: some View {
        Screen(background: .muted) {
            VStack {
                Header()
                
                HStack {
                    TransactionTypeButton(.income)
                    TransactionTypeButton(.outcome)
                }
                .hAlign(alignment: .leading)
                .padding(.top)
                
                MaskedInput(
                    text: $viewModel.value,
                    placeholder: "0,00",
                    formatter: CurrrencyFormatter()
                )
                .padding(.top)
                .keyboardType(.decimalPad)
            
                AppButton(label: "Criar", loading: viewModel.isLoading, action: {
                    Task {
                        await viewModel.didTapToCreateTransaction {
                            dismiss()
                        }
                    }
                })
                .padding(.top, .Spacing.md)
            }
            .padding()
            .screen(alignment: .topLeading)
        }
    }
    
    @ViewBuilder
    private func Header() -> some View {
        HStack {
            Text("Nova transação")
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
    
    @ViewBuilder
    private func TransactionTypeButton(_ type: Transaction.TransactionType) -> some View {
        Button {
            viewModel.didSelectTransactionType(type)
        } label: {
            HStack {
                Text(type.sign)
                    .font(.base1)
                    .foregroundStyle(type.color)
                
                Text(type.operationLabel)
                    .font(.base1)
                    .foregroundStyle(Color.foreground)
            }
            .padding(.vertical, .Spacing.md)
            .padding(.horizontal, .Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: Radii.sm.rawValue)
                    .fill(Color.background)
            )
            .opacity(viewModel.transationType == type ? 1 : 0.5)
        }
    }
}

