import SwiftUI

struct GoalView: View {
    @Environment(\.dismiss) var dismiss
    @State var viewModel: GoalViewModel
    
    var body: some View {
        Screen {
            ScrollView {
                LazyVStack {
                    Text("\(viewModel.goal.formatedCurrent) de \(viewModel.goal.formatedTarget)")
                        .font(.base1)
                        .foregroundStyle(Color.mutedforeground)
                        .padding(.bottom, .Spacing.xxxl)
                        .hAlign(alignment: .leading)
                    
                    
                    Progress(value: viewModel.goal.tagertPercentage)
                    
                    Text("Transações")
                        .font(.head3)
                        .foregroundStyle(Color.foreground)
                        .hAlign(alignment: .leading)
                        .padding(.top, .Spacing.xxl)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .frame(height: 1)
                        .foregroundStyle(Color.border)
                        .padding(.top, .Spacing.xs)
                        .padding(.bottom)
                    
                    ForEach(viewModel.transactions) { transaction in
                        TransactionCell(transaction)
                            .onAppear {
                                Task {
                                    await viewModel.fetchNextPageOfTransacitons(transaction.id)
                                }
                            }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 64)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbarBackground(Color.background, for: .navigationBar)
        .navigationTitle(viewModel.goal.name)
        .toolbarTitleDisplayMode(.large)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {dismiss()} label: {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(Color.foreground)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.didTapToCreateTransaction()
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(Color.foreground)
                }
            }
        }
        .tint(Color.foreground)
        .sheet(item: $viewModel.newTransactionViewModel, content: { newTransactionViewModel in
            NewTransactionView(viewModel: newTransactionViewModel)
                .presentationDetents([.fraction(0.37)])
        })
        .task {
            await viewModel.fetchTransacitons()
        }

    }
    
    @ViewBuilder
    private func Progress(value: Double) -> some View {
        let percentage = Int(value * 100)
        
        Capsule()
            .fill(Color.muted)
            .hAlign(alignment: .leading)
            .frame(height: 24)
            .overlay(alignment: .leading) {
                GeometryReader { geometry in
                    let wProgress = min(geometry.size.width * value, geometry.size.width)
                    
                    Capsule()
                        .fill(Color.appPrimary)
                        .frame(width: wProgress, height: 24)
                }
            }
            .overlay(alignment: .trailing) {
                Text("\(percentage)%")
                    .lineLimit(1)
                    .font(.base2)
                    .foregroundStyle(Color.foreground)
                    .padding(.trailing, 12)
            }
    }
    
    @ViewBuilder
    private func TransactionCell(_ transaction: Transaction) -> some View {
        Button {} label: {
            HStack {
                Text("\(transaction.transactionType.sign) \(transaction.formatedValue)")
                    .font(.base1)
                    .foregroundStyle(transaction.transactionType.color)
                
                Spacer()
                
                Text(transaction.formatedCreatedAt)
                    .font(.base2)
                    .foregroundStyle(Color.mutedforeground.opacity(0.5))
            }
            .padding(.horizontal, .Spacing.lg)
            .hAlign(alignment: .center)
            .frame(height: 64)
            .background(
                RoundedRectangle(cornerRadius: Radii.md.rawValue)
                    .fill(Color.muted)
            )
        }
    }
}
