import Foundation
import Alamofire

//enum HTTPMethod: String {
//    case get = "GET"
//    case put = "PUT"
//    case post = "POST"
//}

struct Endpoint<Body: Encodable, RespType: Decodable> {
    let path: String
    let body: Body?
    var method: HTTPMethod = .get
    
    let response: RespType.Type
}
