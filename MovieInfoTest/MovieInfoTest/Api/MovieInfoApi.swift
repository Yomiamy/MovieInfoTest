import Foundation


import Foundation
import Moya

enum MovieInfoApi:TargetType {
    
    case MovieList([String:Any])
    
    case MovieDetail(String, [String:Any])

    var baseURL: URL {
        return URL(string: Constants.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .MovieList:
            return "/3/discover/movie"
        case .MovieDetail(let id, _):
            return "/3/movie/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .MovieList, .MovieDetail:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .MovieList(contentDict),
             let .MovieDetail(_, contentDict):
            return .requestParameters(parameters: contentDict, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Accept": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}
