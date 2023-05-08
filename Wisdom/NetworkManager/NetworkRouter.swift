

import UIKit
import Foundation
import Alamofire

enum endPoints {
    static let page = "list"
}

public struct APIRouter {
    static let baseURL = NetworkConfiguration.sharedInstance.appGatewayEndPoint()
}

// MARK: Pages
public enum Pages: URLRequestConvertible {
    case pages
    var getInfo: PathInfo {
        switch self {
        case .pages:
            let path = endPoints.page
            return PathInfo(path: path, method: .get, parameters: [:], encoding: URLEncoding.default)
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = URL(string: APIRouter.baseURL)
        let info = self.getInfo
        var request = URLRequest(url: url!.appendingPathComponent(info.path))
        request.httpMethod = info.method.rawValue
        let encoding = info.encoding
        return try! encoding.encode(request, with: info.parameters)
    }
}


struct PathInfo {
    let path: String
    let method: Alamofire.HTTPMethod
    let parameters: Parameters
    let encoding: ParameterEncoding
}
