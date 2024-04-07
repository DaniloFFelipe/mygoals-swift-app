import Foundation

struct StorageService {
    enum Keys: String {
        case session = "@MyGoals:Session"
    }
    
    static func getValue<D: Decodable>(forKey key: Keys, of type: D.Type) -> D? {
        guard let data = UserDefaults.standard.data(forKey: key.rawValue) else {return nil}
        return try? JSONDecoder().decode(type, from: data)
    }
    
    static func setValue<D: Encodable>(forKey key: Keys, data: D) {
        guard let data = try? JSONEncoder().encode(data) else {return}
        UserDefaults.standard.setValue(data, forKey: key.rawValue)
    }
    
    static func removeValue(forKey key: Keys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
