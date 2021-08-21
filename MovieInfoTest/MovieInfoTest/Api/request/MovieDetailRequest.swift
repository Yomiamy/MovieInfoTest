import Foundation

struct MovieDetailRequest: Codable {
    var apiKey:String
    
    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
    }
}
