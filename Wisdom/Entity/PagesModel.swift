//
//  PagesModel.swift
//  Wisdom
//
//  Created by KOSURU UDAY SAIKUMAR on 08/05/23.
//

import UIKit

class PagesModel: Codable, Identifiable {
    var id = "", author : String = ""
    var url = "", download_url : String = ""
    enum CodingKeys: String, CodingKey {
        case download_url = "download_url"
    }
}
