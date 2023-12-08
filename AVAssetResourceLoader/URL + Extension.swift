//
//  URL + Extension.swift
//  AVAssetResourceLoader
//
//  Created by Pankaj Kulkarni on 07/12/23.
//

import Foundation

extension URL {
    func withScheme(_ scheme: String) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.scheme = scheme
        return components?.url
    }
}
