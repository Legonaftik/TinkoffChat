//
//  GetAvatarsRequest.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 21/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

class GetAvatarsRequest: IRequest {

    private let baseUrl: String =  "https://pixabay.com/api/"
    private let apiKey: String
    private let page: Int
    private let limit: Int
    private var getParameters: [String : Any]  {
        return [
            "key": apiKey,
            "response_group": "image_details",
            "image_type": "photo",
            "category": "people",
            "safesearch": true,
            "page": page,
            "per_page": limit
        ]
    }
    private var urlString: String {
        let getParams = getParameters.flatMap({ "\($0.key)=\($0.value)"}).joined(separator: "&")
        return baseUrl + "?" + getParams
    }

    var urlRequest: URLRequest? {
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        return nil
    }

    init(apiKey: String, page: Int = 1, limit: Int = 100) {
        self.apiKey = apiKey
        self.page = page
        self.limit = limit
    }    
}
