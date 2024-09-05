import Foundation

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    var accessToken: String? {
        get {
            UserDefaults.standard.string(forKey: "accessToken")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "accessToken")
        }
    }
}
