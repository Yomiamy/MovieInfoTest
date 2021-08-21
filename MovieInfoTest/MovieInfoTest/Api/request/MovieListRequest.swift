import Foundation

struct MovieListRequest: Codable {
    let apiKey:String
    let primaryReleaseDate:String
    let sortBy:String
    let page:Int
    
    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case primaryReleaseDate = "primary_release_date.lte"
        case sortBy = "sort_by"
        case page
    }
}
