//
//  SecureInput.swift
//  app
//
//  Created by Danilo Felipe Araujo on 27/03/24.
//

import SwiftUI

struct SecureInput<Left: View>: View {
    @Binding var text: String
    let placeholder: String
    let left: () -> Left
    
    init(text: Binding<String>, placeholder: String, @ViewBuilder left: @escaping () -> Left) {
        _text = text
        self.placeholder = placeholder
        self.left = left
    }
    
    var body: some View {
        HStack(spacing: 16) {
            left()
                .foregroundStyle(Color.mutedforeground.opacity(0.6))
            
            SecureField(text: $text) {
                Text(placeholder)
                    .font(.base2)
                    .foregroundStyle(Color.mutedforeground.opacity(0.6))
            }
            .hAlign(alignment: .leading)
            .foregroundStyle(Color.mutedforeground)
            .font(.base2)
        }
        .padding(.horizontal)
        .frame(height: 48)
        .hAlign(alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(.clear)
                .stroke(Color.border, lineWidth: 1)
        )
    }
}

extension SecureInput where Left == EmptyView {
    init(text: Binding<String>, placeholder: String) {
        _text = text
        self.placeholder = placeholder
        self.left = {
            EmptyView()
        }
    }
}

#Preview {
    ZStack {
        Color.background
            .ignoresSafeArea()
        
        SecureInput(text: .constant(""), placeholder: "Placeholder") {
            Image(systemName: "at")
        }
    }
}
