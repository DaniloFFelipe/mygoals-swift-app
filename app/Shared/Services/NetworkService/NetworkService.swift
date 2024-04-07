import Foundation
import Alamofire
import Combine

class Network {
    var baseUrl: String? = nil
    
    private var urlSession: URLSession
    private var headers = HTTPHeaders()
    var bearerToken: String?
    
    init(
        baseUrl: String? = nil,
        urlSession: URLSession = .shared,
        bearerToken: String? = nil
    ) {
        self.baseUrl = baseUrl
        self.urlSession = urlSession
        self.bearerToken = bearerToken
    }
    
    func addBearerToken(_ token: String) {
        headers.add(name: "Authorization", value: "Bearer \(token)")
    }
    
    func removeBearerToken() {
        headers.remove(name: "Authorization")
    }
    
    func serve<R: Decodable, E>(to endpoint: Endpoint<E, R>) async -> Result<R, NetworkError> {
        var url = URL(string: endpoint.path)
        if let baseUrl {
            url = URL(string: "\(baseUrl)\(endpoint.path)")
        }
        
        guard let url else {
            return .failure(.invalidUrl)
        }
        
        return await withUnsafeContinuation { cont in
            AF.request(
                url,
                method: endpoint.method,
                parameters: endpoint.body,
                headers: headers
            )
            .response { data in
                if let error = data.error {
                    if let code = error.responseCode {
                        return cont.resume(returning: .failure(.fromStatusCode(code)))
                    }
                    
                    return cont.resume(returning: .failure(.unexpected))
                }
                
                if let resp = data.response, resp.statusCode >= 400 {
                    if let data = data.data, let dataErrorString = String(data: data, encoding: .utf8) {
                        print("RESPONSE ERR: \(dataErrorString)")
                    }
                    
                    return cont.resume(returning: .failure(.fromStatusCode(resp.statusCode)))
                }
                
                guard let respData = data.data else {
                    return cont.resume(returning: .failure(.decodableError))
                }
                
                do {
                    let decoder = JSONDecoder()
                    let json = try decoder.decode(R.self, from: respData)
                    
                    return cont.resume(returning: .success(json))
                } catch {
                    print("DECODE: ", error)
                    return cont.resume(returning: .failure(.decodableError))
                }
            }
        }
    }
        
    static var shared: Network = Network(baseUrl: Config.apiBaseUrl)
}

