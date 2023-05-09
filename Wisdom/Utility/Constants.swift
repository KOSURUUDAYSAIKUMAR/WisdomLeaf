//
//  Constants.swift
//  Wisdom
//
//  Created by KOSURU UDAY SAIKUMAR on 08/05/23.
//

import Foundation

extension String {
    static let pagesIdentifier = "pages"
}

var pagesDescription = ["books, pencils, laptop, and iphone on a desk books, pencils, laptop, and iphone on a desk", "Paris", "a spoken or written account of a person, object, or event.", "a type or class of people or things.", " someone looks, sounds, etc", "books, pencils, laptop, and iphone on a desk books, pencils, laptop, and iphone on a desk books, pencils, laptop, and iphone on a desk books, pencils, laptop, and iphone on a desk"]

extension String {
    var encoded: String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
}
