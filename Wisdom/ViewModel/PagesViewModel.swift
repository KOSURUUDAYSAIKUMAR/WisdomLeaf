//
//  PagesViewModel.swift
//  Wisdom
//
//  Created by KOSURU UDAY SAIKUMAR on 08/05/23.
//

import UIKit

class PagesViewModel: NSObject {
    static var pageSharedInstance = PagesViewModel()
    func getResponseFromNetworkManager(completion: @escaping(Result<[PagesModel], DemoError>) -> Void) {
        NetworkManager.shared.fetchRequest(type: [PagesModel].self) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
