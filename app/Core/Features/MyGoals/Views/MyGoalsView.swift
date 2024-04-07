import SwiftUI

struct MyGoalsView: View {
    @State var viewModel: MyGoalsViewModel
    
    var body: some View {
        Screen {
            if viewModel.isLoading {
                Loading()
            } else if viewModel.hasError {
                HasError()
            } else {
                Content()
                    .navigationTitle("Suas Metas")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                viewModel.didToSignOut()
                            } label: {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .foregroundStyle(Color.foreground)
                                    .font(.system(size: 16))
                            }
                        }
                    }
                    .confirmationDialog("Deseja sair", isPresented: $viewModel.isSignOut) {
                        Button("Sair", role: .destructive) {
                            Task {
                                await viewModel.didTapToConfirmSignOut()
                            }
                        }
                        
                        Button("Cancel", role: .cancel) {
                            viewModel.isSignOut = false
                        }
                    } message: {
                        Text("Deseja sair do MyGoals")
                    }
            }
        }
        .task {
            await viewModel.fetchActiveGoals()
            await viewModel.fetchLatestTransactions()
        }
        .sheet(item: $viewModel.createViewModel) { createGoalViewModel in
            CreateGoalView(viewModel: createGoalViewModel)
                .presentationDetents([.fraction(0.37)])
        }
        .navigationDestination(item: $viewModel.destination) { destination in
            switch destination {
            case let .goal(goal: goal):
                GoalView(viewModel: .init(goal: goal))
            }
        }
    }
    
    @ViewBuilder
    private func Content() -> some View {
        VStack {            
            Text("Poupe hoje para colher os frutos amanhã.")
                .font(.base1)
                .foregroundStyle(Color.mutedforeground)
                .padding(.bottom, .Spacing.xxxl)
                .hAlign(alignment: .leading)
            
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: .Spacing.lg) {
                    AddButton()
                    
                    ForEach(viewModel.myGoals) { goal in
                        GoalCell(goal)
                    }
                }
                .padding(.trailing, 64)
            }
            .frame(height: 164)
            .scrollClipDisabled()
            .scrollIndicators(.hidden)
            
            
            HStack {
                Text("Últimas Transações")
                    .font(.head3)
                    .foregroundStyle(Color.foreground)
                    .hAlign(alignment: .leading)
                
                
//                AppButton(config: .link, label: "Ver mais", action: {})
            }
            .padding(.top, .Spacing.xxl)
            
            RoundedRectangle(cornerRadius: 20)
                .frame(height: 1)
                .foregroundStyle(Color.border)
                .padding(.top, .Spacing.xs)
            
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.latestTransactions) { transaction in
                        TransactionCell(transaction)
                    }
                }
                .padding(.bottom, 64)
            }
            .scrollIndicators(.hidden)
            
        }
        .padding(.horizontal)
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    @ViewBuilder
    private func Loading() -> some View {
        VStack {
            ProgressView()
                .progressViewStyle(.circular)
                .tint(Color.foreground)
                .scaleEffect(1.5)
        }
        .screen(alignment: .center)
    }
    
    @ViewBuilder
    private func HasError() -> some View {
        VStack {
            Text("Nāo foi possivel buscas suas metas, tente novamente mais tarde")
                .font(.head1)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.foreground)
                .padding(.bottom, .Spacing.sm)
                .hAlign(alignment: .leading)
            
            AppButton(config: .ghost, label: "Recaregar") {
                viewModel.refetch()
            }
        }
        .padding()
        .screen(alignment: .center)
    }
    
    @ViewBuilder
    private func AddButton() -> some View {
        Button {
            viewModel.didTapToCreateNewGoal()
        } label: {
            RoundedRectangle(cornerRadius: Radii.md.rawValue)
                .fill(Color.appPrimary)
                .frame(width: 64, height: 164)
                .overlay {
                    Image(systemName: "plus")
                        .foregroundStyle(Color.foreground)
                }
        }
    }
    
    @ViewBuilder
    private func GoalCell(_ goal: Goal) -> some View {
        Button {
            viewModel.didTapOnGoal(of: goal)
        } label: {
            VStack(alignment: .leading) {
                Text(goal.name)
                    .lineLimit(1)
                    .font(.head4)
                    .foregroundStyle(Color.foreground)
                
                Spacer()
                
                Text(goal.formatedCurrent)
                    .lineLimit(1)
                    .font(.base1)
                    .foregroundStyle(Color.foreground)
                Text("de \(goal.formatedTarget)")
                    .lineLimit(1)
                    .font(.base2)
                    .foregroundStyle(Color.mutedforeground)
                
                Spacer()
                
                Progress(value: goal.tagertPercentage)
                
            }
            .padding(.vertical, 24)
            .padding(.horizontal)
            .frame(width: 148, height: 164, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: Radii.md.rawValue)
                    .fill(Color.muted)
            )
        }
    }
    
    @ViewBuilder
    private func Progress(value: Double) -> some View {
        let percentage = Int(value * 100)
        
        Capsule()
            .fill(Color.background)
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
                VStack(alignment: .leading, spacing: 4) {
                    if let goalName = transaction.goalName {
                        Text(goalName)
                            .font(.base1)
                            .foregroundStyle(Color.foreground)
                    }
                    Text("\(transaction.transactionType.sign) \(transaction.formatedValue)")
                        .font(.base1)
                        .foregroundStyle(transaction.transactionType.color)
                }
                
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

