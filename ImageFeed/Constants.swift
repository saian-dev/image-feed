import Foundation


enum Constants {
    static let accessKey = "access-key"
    static let secretKey = "secret-key"
    static let redirectURI = "url"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = "https://api.unsplash.com"
    
    static let unsplashAuthorizeURL = "https://unsplash.com/oauth/authorize"
    static let unsplashAccessTokenURL = "https://unsplash.com/oauth/token"
    static let unsplashAuthCodeURLPath = "/oauth/authorize/native"
}
