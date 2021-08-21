import Foundation

struct MovieDetailRequest: Codable {
    let apiKey:String
    
    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
    }
}
