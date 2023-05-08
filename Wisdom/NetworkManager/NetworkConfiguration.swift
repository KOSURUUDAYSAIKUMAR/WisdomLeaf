//
//  NetworkConfiguration.swift
//  Wisdom
//
//  Created by KOSURU UDAY SAIKUMAR on 08/05/23.
//

import UIKit

class NetworkConfiguration: NSObject {
    static var sharedInstance = NetworkConfiguration()
    var configs: NSDictionary!
   
    override init() {
        let path = Bundle.main.path(forResource: PathEndPoints.config.rawValue, ofType: PathEndPoints.type.rawValue)!
        configs = NSDictionary(contentsOfFile: path)!.object(forKey: ConfigEndPoint.development.rawValue) as? NSDictionary
    }
}

extension NetworkConfiguration {
    func appGatewayEndPoint() -> String {
        return configs.object(forKey: ApplicationGateWayEndPoint.EndPoint.rawValue) as! String
    }
}

enum ApplicationGateWayEndPoint: String {
    case EndPoint = "ApplicationGateWay"
}

enum PathEndPoints :String {
    case config = "NetworkConfigure"
    case type   = "plist"
}

enum ConfigEndPoint : String {
    case development  = "Development"
}
