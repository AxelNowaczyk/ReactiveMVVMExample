//
//  ContentProvider.swift
//  RectiveLoginForm
//
//  Created by Nowaczyk Axel on 29/08/2017.
//  Copyright © 2017 Nowaczyk Axel. All rights reserved.
//

import ReactiveSwift
import Result

enum ContentProviderResponse {
    case success([ContentModel])
    case failure(Error)
}

struct ContentProvider {

    static private var counter = 0

    typealias CompletionHandler = (ContentProviderResponse) -> Void
    static func performContentRequest(completionHandler: CompletionHandler) {

        defer {
            counter += 1
            counter %= 4
        }

        switch counter {
        case 0: completionHandler(.success([ContentModel(title: "1"),ContentModel(title: "2"),ContentModel(title: "3")]))
        case 1: completionHandler(.success([ContentModel(title: "11"),ContentModel(title: "22"),ContentModel(title: "33")]))
        case 2: completionHandler(.success([ContentModel(title: "12"),ContentModel(title: "23"),ContentModel(title: "34")]))
        default: completionHandler(.success([ContentModel(title: "A"),ContentModel(title: "B"),ContentModel(title: "C")]))
        }
    }

}
