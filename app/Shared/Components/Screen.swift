import SwiftUI

struct Screen<Content: View>: View {
    var background: Color = .background
    var alignment: Alignment = .topLeading
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        content()
            .screen(alignment: alignment)
            .background(
                background
                    .ignoresSafeArea()
            )
    }
}

