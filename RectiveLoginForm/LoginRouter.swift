//
//  LoginRouter.swift
//  RectiveLoginForm
//
//  Created by Nowaczyk Axel on 28/08/2017.
//  Copyright © 2017 Nowaczyk Axel. All rights reserved.
//

import Foundation
import UIKit

class LoginRouter {

}

extension LoginRouter: Router {

    func route(to routeID: String, from context: UIViewController?) {

        guard let route = LoginViewController.Route(rawValue: routeID) else {
            return
        }
        
        switch route {
        case .showContent:
            context?.performSegue(withIdentifier: "ShowContent", sender: nil)
        }
    }
}
