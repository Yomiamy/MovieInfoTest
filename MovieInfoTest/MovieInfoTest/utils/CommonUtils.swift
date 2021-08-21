import Foundation
import CommonCrypto
import UIKit
import Alamofire

public class CommonUtils {
    
    // MARK: - Properties
    public static var APP_VERSION:String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "Error"
        }
        return version
    }
    
    public static var APP_BUNDLE_ID:String {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            return "Error"
        }
        return bundleId
    }
    private static let jsonEncoder:JSONEncoder = JSONEncoder()
    private static let jsonDecorder:JSONDecoder = JSONDecoder()
    private static let dateFormatter:DateFormatter = DateFormatter()
    private static let networkManager:NetworkReachabilityManager? = NetworkReachabilityManager()
    
    // MARK: - JSON
    public static func getJsonEncoder() -> JSONEncoder {
        return jsonEncoder
    }
    
    public static func getJsonDecoder() -> JSONDecoder {
        return jsonDecorder
    }
    
    public static func getJsonData<Type:Codable>(data:Type) -> Data {
        return (try? jsonEncoder.encode(data)) ?? Data()
    }
    
    // MARK: - Date
    public static func convertDateToString(formatStr:String, date:Date) -> String {
        dateFormatter.dateFormat = formatStr
        return dateFormatter.string(from: date)
    }
    
    public static func convertStringToDate(formatStr:String, dateStr:String) -> Date {
        dateFormatter.dateFormat = formatStr
        return dateFormatter.date(from: dateStr) ?? Date()
    }
    
    public static func convertStringToDate(timezone:TimeZone? = TimeZone.current, dateStr:String, dateFormatStr:String, amSymbol:String? = nil, pmSymbol:String? = nil) -> Date? {
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatStr
        dateFormatter.timeZone = timezone
        //        dateFormatter.locale = Locale.current
        dateFormatter.amSymbol = amSymbol ?? ""
        dateFormatter.pmSymbol = pmSymbol ?? ""
        return dateFormatter.date(from: dateStr)
    }
    
    public static func convertDateToString(timezone:TimeZone? = TimeZone.current, date:Date, targetDateFormatStr:String, amSymbol:String? = nil, pmSymbol:String? = nil) -> String {
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = targetDateFormatStr
        dateFormatter.timeZone = timezone
        //        dateFormatter.locale = Locale.current
        dateFormatter.amSymbol = amSymbol ?? ""
        dateFormatter.pmSymbol = pmSymbol ?? ""
        return dateFormatter.string(from: date)
    }
    
    // MARK: - UserDefault
    public static func writeToUserDefault<DataType:Codable>(suiteName:String = "", key:String, data:DataType) {
        guard let userDefaultStand = suiteName.isEmpty ? UserDefaults.standard : UserDefaults(suiteName: suiteName) else {
            return
        }
        
        if data is Array<Any> {
            let data = try? jsonEncoder.encode(data)
            userDefaultStand.set(data, forKey: key)
        } else {
            userDefaultStand.set(data, forKey: key)
        }
        userDefaultStand.synchronize()
    }
    
    public static func readFromUserDefault<DataType:Codable>(suiteName:String = "", key:String) -> DataType? {
        guard let userDefaultStand = suiteName.isEmpty ? UserDefaults.standard : UserDefaults(suiteName: suiteName) else {
            return nil
        }
        
        if DataType.self is String.Type {
            return userDefaultStand.string(forKey: key) as? DataType
        } else if DataType.self is Array<Any>.Type {
            return userDefaultStand.object(forKey: key) as? DataType
        } else {
            guard let rawData = userDefaultStand.data(forKey: key),
                let data = try? jsonDecorder.decode(DataType.self, from:rawData) else {
                    return nil
            }
            return data
        }
    }
    
    public static func clearUserDefault(suiteName:String = "", key:String) {
        guard let userDefaultStand = suiteName.isEmpty ? UserDefaults.standard : UserDefaults(suiteName: suiteName) else {
            return
        }
        
        userDefaultStand.removeObject(forKey: key)
        userDefaultStand.synchronize()
    }
    
    // MARK: - Encryption
    public static func convertToSha512(input: String) -> String {
        let data = input.data(using: .utf8) ?? Data()
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA512($0.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map({ String(format: "%02hhx", $0) }).joined(separator: "")
    }
    
    // MARK: - QR & Bar
    public static func generateQRCode(qrCode: String) -> UIImage? {
        let data = qrCode.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 5, y: 5)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    public static func generateBarCode(barcode: String) -> UIImage? {
        let data = barcode.data(using: .ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            
            if let ciImage = filter.outputImage {
                return UIImage(ciImage: ciImage)
            }
        }
        return nil
    }
    
    // MARK: - Network
    public static func getQueryStringParameter(url: String, keyStr: String, separator:String) -> String? {
        let params = url.components(separatedBy: separator)
        let matchParam = params.first { param -> Bool in
            return param.contains(keyStr)
        }
        return matchParam
    }
    
    public static func openUrl(urlStr:String, completionHandler:((Bool) -> Void)? = nil) {
        guard let url = URL(string:urlStr), UIApplication.shared.canOpenURL(url) else {
            return
        }
        
        // can open succeeded.. opening the url
        UIApplication.shared.open(url, options: [:], completionHandler: completionHandler)
    }
    
    // MARK: - String matcher
    public static func isMatchFormat(data:String, pattern:String, options:NSRegularExpression.Options) -> Bool {
        do {
            let regex:NSRegularExpression = try NSRegularExpression(pattern: pattern, options: options)
            return regex.matches(in: data, options: [], range: NSMakeRange(0, data.count)).count > 0
        } catch {
            print("isMatchFormat error: \(error.localizedDescription)")
            return false
        }
    }
    
    //MARK: - Global
    public static func openSettings(completionHandler:((Bool) -> Void)? = nil) {
        let url = URL(string:UIApplication.openSettingsURLString)
        if UIApplication.shared.canOpenURL(url!){
            // can open succeeded.. opening the url
            UIApplication.shared.open(url!, options: [:], completionHandler: completionHandler)
        }
    }
    
    public static func isConnected() -> Bool {
        networkManager?.isReachable ?? true
    }
}
