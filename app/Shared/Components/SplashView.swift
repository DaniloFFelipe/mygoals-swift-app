//
//  SplashView.swift
//  app
//
//  Created by Danilo Felipe Araujo on 06/04/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        Screen {
            VStack {
                Text("💰")
                    .font(.system(size: 64))
                
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(1.5)
                    .tint(Color.foreground)
            }
            .screen()
        }
    }
}

#Preview {
    SplashView()
}
