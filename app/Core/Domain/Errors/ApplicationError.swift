import Foundation

enum ApplicationError: Error {
    case invalidCredentails(message: String)
    case unexpected
    case invalidParams
}
