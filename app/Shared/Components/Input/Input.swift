//
//  Input.swift
//  app
//
//  Created by Danilo Felipe Araujo on 27/03/24.
//

import SwiftUI

struct Input<Left: View>: View {
    @Binding var text: String
    let placeholder: String
    let error: String?
    var backgroundColor: Color
    var formatter: Formatter? = nil
    let left: () -> Left
    
    init(text: Binding<String>, placeholder: String, error: String? = nil, backgroundColor: Color = .clear, formatter: Formatter? = nil, @ViewBuilder left: @escaping () -> Left) {
        _text = text
        self.placeholder = placeholder
        self.error = error
        self.left = left
        self.backgroundColor = backgroundColor
        self.formatter = formatter
    }
    
    var body: some View {
        HStack(spacing: 16) {
            left()
                .foregroundStyle(Color.mutedforeground.opacity(0.6))
            
            if let formatter {
                TextField(value: $text, formatter: formatter) {
                    Text(placeholder)
                        .font(.base2)
                        .foregroundStyle(Color.mutedforeground.opacity(0.6))
                }
                .hAlign(alignment: .leading)
                .foregroundStyle(Color.mutedforeground)
                .font(.base2)
            } else {
                TextField(text: $text) {
                    Text(placeholder)
                        .font(.base2)
                        .foregroundStyle(Color.mutedforeground.opacity(0.6))
                }
                .hAlign(alignment: .leading)
                .foregroundStyle(Color.mutedforeground)
                .font(.base2)
            }
        }
        .padding(.horizontal)
        .frame(height: 48)
        .hAlign(alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(backgroundColor)
                .stroke(error != nil ? Color.destructive : Color.border, lineWidth: 1)
        )
    }
}

extension Input where Left == EmptyView {
    init(text: Binding<String>, placeholder: String, error: String? = nil, backgroundColor: Color = .clear, formatter: Formatter? = nil) {
        _text = text
        self.placeholder = placeholder
        self.error = error
        self.backgroundColor = backgroundColor
        self.formatter = formatter
        self.left = {
            EmptyView()
        }
    }
}

#Preview {
    ZStack {
        Color.background
            .ignoresSafeArea()
        
        Input(text: .constant(""), placeholder: "Placeholder") {
            Image(systemName: "at")
        }
    }
}
