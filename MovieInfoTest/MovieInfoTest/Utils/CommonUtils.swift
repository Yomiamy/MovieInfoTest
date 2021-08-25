import Foundation
import CommonCrypto
import UIKit
import Alamofire

public class CommonUtils {
    
    private static let jsonEncoder:JSONEncoder = JSONEncoder()
    
    // MARK: - JSON
    public static func getJsonEncoder() -> JSONEncoder {
        return jsonEncoder
    }
    
    public static func openUrl(urlStr:String, completionHandler:((Bool) -> Void)? = nil) {
        guard let url = URL(string:urlStr), UIApplication.shared.canOpenURL(url) else {
            return
        }
        
        // can open succeeded.. opening the url
        UIApplication.shared.open(url, options: [:], completionHandler: completionHandler)
    }
}
