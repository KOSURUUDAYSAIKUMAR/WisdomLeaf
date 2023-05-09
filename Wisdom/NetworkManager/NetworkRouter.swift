

import UIKit
import Foundation
import Alamofire

enum endPoints {
    static let page = "list?"
}

public struct APIRouter {
    static let baseURL = NetworkConfiguration.sharedInstance.appGatewayEndPoint()
}

// MARK: Pages
public enum Pages: URLRequestConvertible {
    case pages(page_ID: String)
    var getInfo: PathInfo {
        switch self {
        case .pages(page_ID: let pagination):
            let path = (endPoints.page + pagination).removingPercentEncoding ?? ""
            return PathInfo(path: path, method: .get, parameters: [:], encoding: URLEncoding.default)
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let info = self.getInfo
        let infoPath = info.path.removingPercentEncoding ?? ""
        let url = URL(string: APIRouter.baseURL + infoPath)!
        var request = URLRequest(url: url)
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
