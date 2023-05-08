//
//  PagesViewModel.swift
//  Wisdom
//
//  Created by KOSURU UDAY SAIKUMAR on 08/05/23.
//

import UIKit
import SDWebImage

class PagesViewModel: NSObject {
    static var pageSharedInstance = PagesViewModel()
    func getResponseFromNetworkManager(completion: @escaping(Result<[PagesModel], DemoError>) -> Void) {
        NetworkManager.shared.fetchRequest(type: [PagesModel].self) { result in
            switch result {
            case .success(let data):
                data.map { model in
                    if model.download_url != "" {
                        if let url = URL(string:model.download_url) {
                            UIImageView().sd_setImage(with:url, placeholderImage:nil, options: .refreshCached) {(image, error, _ , _ ) in
                                if error == nil ,let image = image {
                                    DispatchQueue.main.async {
                                        SDImageCache.shared.store(image, forKey: url.absoluteString)
                                    }
                                }
                            }
                        }
                    }
                }
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
