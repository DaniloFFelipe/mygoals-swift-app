import SwiftUI


typealias Reducer<State, Action> = (_ state: State, _ action: Action) -> State
typealias Middleware<State, Action> = (_ state: State, _ dispatch: (Action) -> Void) -> Void

@Observable
class Store<State, Action> {
    private var reducer: Reducer<State, Action>
    var state: State
    private var middleware: [Middleware<State, Action>]
    
    init(
        state: State,
        middleware: [Middleware<State, Action>] = [],
        reducer: @escaping Reducer<State, Action>
    ) {
        self.reducer = reducer
        self.state = state
        self.middleware = middleware
    }
    
    func dispatch(_ action: Action) {
        self.state = reducer(state, action)
    }
}
