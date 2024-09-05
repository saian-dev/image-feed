import Foundation


final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}

    func fetchOAuthToken(withCode code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let request = buildOAuthRequest(code: code)
        guard let request else { return }
        
        let urlSessionTask = URLSession.shared.data(for: request) {result in
            switch result {
            case .success(let data):
                do {
                    let body = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(body.accessToken))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        urlSessionTask.resume()
    }
    
    private func buildOAuthRequest(code: String) -> URLRequest? {
        var urlComponents = URLComponents(string: Constants.unsplashAccessTokenURL)
        if urlComponents == nil {
            return nil
        }
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]
        
        var request = URLRequest(url: urlComponents!.url!)
        request.httpMethod = "POST"
        return request
    }
}
