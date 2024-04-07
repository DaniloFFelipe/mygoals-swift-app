import Foundation

enum NetworkError: Int, Error {
    case badRequest = 400
    case forbidden = 403
    case unauthorized = 401
    case notFound = 404
    case serverError = 500
    case unexpected = 0
    
    case decodableError = -1
    case encodableError = -2
    case invalidUrl = -3
    
    static func fromStatusCode(_ code: Int) -> NetworkError {
        guard let err = NetworkError(rawValue: code) else {
            return .unexpected
        }
        
        return err
    }
}
