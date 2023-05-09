//
//  NetworkManager.swift
//  Wisdom
//
//  Created by KOSURU UDAY SAIKUMAR on 08/05/23.
//

import UIKit
import Alamofire
import SwiftyJSON

enum DemoError: Error {
    case BadURL
    case NoData
    case DecodingError
}

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    let aPIHandler: APIHandlerDelegate
    init(aPIHandler: APIHandlerDelegate = APIHandler()) {
        self.aPIHandler = aPIHandler
    }
    func fetchRequest<T: Codable>(type: T.Type, pageIndex: String, completion: @escaping(Result<[PagesModel], DemoError>) -> Void) {
        aPIHandler.fetchData(responseObjectType: [PagesModel].self, pageIndex: pageIndex) { success in
            completion(.success(success))
        } failure: { error in
            completion(.failure(.NoData))
        }
    }
}

protocol APIHandlerDelegate {
    func fetchData<T: Decodable>(responseObjectType: T.Type, pageIndex: String,
                                 success: @escaping ([PagesModel]) -> Void,
                                 failure: @escaping (AFError) -> Void)
}

class APIHandler: APIHandlerDelegate {
    func fetchData<T: Decodable>(responseObjectType: T.Type, pageIndex: String,
                                 success: @escaping ([PagesModel]) -> Void,
                                 failure: @escaping (AFError) -> Void) {
        AF.request(Pages.pages(page_ID: pageIndex) ).validate()
            .responseDecodable(of: [PagesModel].self) { response in
                switch response.result {
                case .success(let data):
                    success(data)
                case .failure(let error):
                    failure(error)
                }
            }
    }
}
