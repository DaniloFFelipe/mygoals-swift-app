//
//  ContentView.swift
//  app
//
//  Created by Danilo Felipe Araujo on 25/03/24.
//

import SwiftUI

struct AppView: View {
    @State var viewModel: AppViewModel
    
    init (viewModel: AppViewModel = AppViewModel.defaults) {
        self.viewModel = viewModel
        
        startLocatorService()
    }
    
    var body: some View {
        NavigationStack {
            if viewModel.isAuthenticated {
                MyGoalsView(
                    viewModel: MyGoalsViewModel(
                        onSignOut: viewModel.signUp
                    )
                )
            } else if viewModel.isLoading {
                SplashView()
            } else {
                LoginView(
                    viewModel: .init(
                        delegate: LoginViewModelDelegate(
                            onLogin: viewModel.signUp(session:)
                        )
                    )
                )
            }
        }
        .environment(viewModel)
        .preferredColorScheme(.dark)
        .task {
            await viewModel.findLastSession()
        }
    }
    
    
    func startLocatorService() {
        LocatorService.shared.startLocator()
    }
}

#Preview {
//    let viewModel = AppViewModel(session: .mock)
    return AppView()
}
