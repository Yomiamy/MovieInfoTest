import Foundation

struct MovieListRequest: Codable {
    var apiKey:String
    var primaryReleaseDate:String
    var sortBy:String
    var page:Int
    
    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case primaryReleaseDate = "primary_release_date.lte"
        case sortBy = "sort_by"
        case page
    }
}
