//
//  AppLinks.swift
//  Tigers Quest: The Golden Cave
//
//  Created by Roman on 11/9/26.
//

import Foundation

enum AppLinks: String {
    case privacyPolicy = "https://www.termsfeed.com/live/f71636fe-c761-4340-98a0-1286004295ac"
    case termsOfUse = "https://www.termsfeed.com/live/be5bf419-73f8-4ed5-89e6-ad0e1b92e052"

    var url: URL? {
        URL(string: rawValue)
    }
}
