//
//  IRequestSender.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 20/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

struct RequestConfig<Parser> where Parser: IParser {

    let request: IRequest
    let parser: Parser
}

enum Result<Model> {

    case success(Model)
    case fail(String)
}

protocol IRequestSender {

    func send<Parser>(config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> ())
}

