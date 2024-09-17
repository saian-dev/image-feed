import Foundation

enum AuthServiceError: LocalizedError {
    case invalidRequest(msg: String)
    
    var failureReason: String? {
        switch self {
        case .invalidRequest(let msg):
            return "Invalid Request: \(msg)"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .invalidRequest(let msg):
            return "Please, try again."
        }
    }
}


final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private init() {}

    func fetchOAuthToken(withCode code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard lastCode != code else {
            completion(.failure(AuthServiceError.invalidRequest(msg: "Duplicated requests are not allowed.")))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard
            let request = buildOAuthRequest(code: code)
        else {
            completion(.failure(AuthServiceError.invalidRequest(msg: "Failed to build URL.")))
            return
        }

        let task = URLSession.shared.data(for: request) {[weak self] result in
            switch result {
            case .success(let data):
                do {
                    let body = try SnakeCaseJSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(body.accessToken))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
            self?.task = nil
            self?.lastCode = nil
        }
        self.task = task
        task.resume()
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
        
        guard let url = urlComponents?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
