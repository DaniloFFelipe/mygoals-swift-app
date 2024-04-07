import Foundation

struct Meta: Codable {
    let nextPageIndex: Int?
    let pageIndex: Int
    let perPage: Int
    let total: Int
}

struct Paginated<Data: Decodable>: Decodable {
    let meta: Meta
    let data: Data
}
