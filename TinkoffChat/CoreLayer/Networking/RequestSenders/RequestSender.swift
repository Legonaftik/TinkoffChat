//
//  RequestSender.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 20/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

class RequestSender: IRequestSender {

    let session = URLSession.shared
    
    func send<Parser>(config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> ()) {
        
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(Result.fail("URL is incorrect."))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in

            if let error = error {
                completionHandler(Result.fail(error.localizedDescription))
                return
            }

            guard let data = data,
                let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                    completionHandler(Result.fail("Couldn't parse the received data."))
                    return
            }
            
            completionHandler(Result.success(parsedModel))
        }
        
        task.resume()
    }
}
