//
//  IParser.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 21/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

protocol IParser {

    associatedtype Model
    func parse(data: Data) -> Model?
}
