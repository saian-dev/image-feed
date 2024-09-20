import Foundation


struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
    
    var loginName: String { return "@\(username)" }
    var fullName: String { return "\(firstName) \(lastName)" }
}

struct Profile {
    let username: String
    let name: String
    let bio: String?
    let loginName: String
}

final class ProfileService {
    static let shared = ProfileService()
    
    private init() {}
    private(set) var profile: Profile?
    
    func fetchProfile(_ token: String?, completion: @escaping (Result<Profile?, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let token else {
            print("Access token is not acquired.")
            return
        }
                
        guard
            let request = buildProfileRequest(token: token)
        else {
            completion(.failure(AuthServiceError.invalidRequest(msg: "Failed to build URL.")))
            return
        }
        
        let task = URLSession.shared.data(for: request) {[weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let userInfo = try SnakeCaseJSONDecoder().decode(ProfileResult.self, from: data)
                    profile = Profile(
                        username: userInfo.username,
                        name: userInfo.fullName,
                        bio: userInfo.bio,
                        loginName: userInfo.loginName
                    )
                    print(profile!)
                    completion(.success(profile))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Failed to get user info")
                print(error)
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func buildProfileRequest(token: String) -> URLRequest? {
        guard let url = URL(string: Constants.unsplashUserProfileURL) else {
            print("Failed to build url: \(Constants.unsplashUserProfileURL).")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    
}
