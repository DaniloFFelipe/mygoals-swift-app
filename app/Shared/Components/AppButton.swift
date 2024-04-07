import SwiftUI

struct AppButton<C: View>: View {
    var content: () -> C
    var action: () -> Void
    
    var config: Config
    
    var loading: Bool
    var disabled: Bool
    
    init(
        config: Config = .regular,
        loading: Bool = false,
        disabled: Bool = false,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> C
    ) {
        self.action = action
        self.content = content
        self.config = config
        self.loading = loading
        self.disabled = disabled
    }
    
    var body: some View {
        Button {action()} label: {
            !loading ?
                config.apply(AnyView(content())) :
                config.apply(AnyView(Loading()))
            
        }
        .disabled(disabled || loading)
        .opacity(disabled ? 0.5 : 1)
    }
    
    @ViewBuilder
    func Loading() -> some View {
        ProgressView()
            .progressViewStyle(.circular)
            .tint(Color.foreground)
    }
}

extension AppButton where C == Text {
    init(
        config: Config = .regular,
        label: String,
        loading: Bool = false,
        disabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.action = action
        self.config = config
        self.loading = loading
        self.disabled = disabled
        self.content = {
            Text(label)
                .font(.strong1)
        }
    }
}

extension AppButton {
    enum Config {
        case regular
        case outline
        case ghost
        case link
        
        
        @ViewBuilder
        func apply<B: View>(_ view: B) -> some View {
            switch self {
            case .regular:
                view
                    .frame(height: 48)
                    .hAlign()
                    .background(Color.appPrimary)
                    .radii(.sm)
                    .font(.base2)
            case .outline:
                view
                    .frame(height: 48)
                    .hAlign()
                    .background(
                        RoundedRectangle(cornerRadius: Radii.sm.rawValue)
                            .fill(.clear)
                            .stroke(Color.border, lineWidth: 1)
                    )
                    .font(.base2)
                
            case .ghost:
                view
                    .padding(.horizontal, .Spacing.lg)
                    .padding(.vertical, .Spacing.md)
                    .background(Color.muted)
                    .radii(.sm)
                    .font(.base2)
                
            case .link:
                view
                    .font(.base2)
            }
        }
    }
}


#Preview {
    AppButton(config: .regular, label: "Button", loading: true) {
        
    }
}
