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

struct ContentProviderError: Error {
    var localizedDescription: String
    var code: Int
}

typealias ContentProviderFunction = () -> ContentProviderResponse
protocol ContentProvidable {
    var function: ContentProviderFunction { get }
}

struct ContentProvider: ContentProvidable {

    var function: ContentProviderFunction

    init(function: @escaping ContentProviderFunction) {
        self.function = function
    }

    typealias CompletionHandler = (ContentProviderResponse) -> Void
    func performContentRequest(completionHandler: CompletionHandler) {
        completionHandler(self.function())
    }

}
