//
//  Helpers.swift
//  RectiveLoginForm
//
//  Created by Nowaczyk Axel on 09/08/2017.
//  Copyright © 2017 Nowaczyk Axel. All rights reserved.
//

import Foundation
import UIKit

struct Crudentials {
    static func isPresent(email: String?, name: String?, password: String?) -> Bool {
        guard let email = email, let name = name, let password = password
            else { return false }
        return email.characters.count > 0
            && name.characters.count > 0
            && password.characters.count > 0
    }

    static func isValid(email: String?, name: String?, password: String?) -> Bool {
        guard let email = email, let name = name, let password = password
            else { return false }
        return email.isValidEmail
            && name.characters.count > 0
            && password.characters.count > 0
    }
}

fileprivate extension String {

    private struct Constants {
        static let emailPattern = "[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}\\@" +
            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+"
    }

    var isValidEmail: Bool {
        let regex = try? NSRegularExpression(
            pattern: Constants.emailPattern,
            options: []
        )

        let range = NSRange.init(location: 0, length: self.characters.count)
        return regex?.firstMatch(in: self, options: [], range: range) != nil
    }
}

protocol Router {
    func route(to routeID: String, from context: UIViewController?)
}
