//
//  LoginViewController.swift
//  RectiveLoginForm
//
//  Created by Nowaczyk Axel on 09/08/2017.
//  Copyright © 2017 Nowaczyk Axel. All rights reserved.
//

import UIKit
import ReactiveSwift

class LoginViewController: UIViewController {

    let vm: LoginViewModelType = LoginViewModel()
    let router = LoginRouter()

    enum Route: String {
        case showContent
    }

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    @IBAction func nameTextFieldChanged(_ sender: UITextField) {
        self.vm.inputs.nameChanged(name: self.nameTextField.text)
    }
    @IBAction func emailTextFieldChanged(_ sender: UITextField) {
        self.vm.inputs.emailChanged(email: self.emailTextField.text)
    }
    @IBAction func passwordTextFieldChanged(_ sender: UITextField) {
        self.vm.inputs.passwordChanged(password: self.passwordTextField.text)
    }

    @IBAction func submitButtonWasPressed(_ sender: UIButton) {
        self.vm.inputs.submitButtonPressed()
    }
}

extension LoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupOutputs()
        self.vm.inputs.viewDidLoad()
    }
}

extension LoginViewController {

    fileprivate func setupOutputs() {
        self.vm.outputs.alertResponse
            .observe(on: UIScheduler())
            .observeValues { [weak self] response in

                guard let signUpResponse = LoginViewModel.SignUpResponseType(rawValue: response) else {
                    return
                }

                switch signUpResponse {
                case .successful:
                    self?.router.route(to: Route.showContent.rawValue, from: self)
                default:
                    let alert = AlertCreator.createSimpleAlert(title: nil, message: response)
                    self?.present(alert, animated: true, completion: nil)
                }
        }

        self.vm.outputs.submitButtonEnabled
            .observe(on: UIScheduler())
            .observeValues { [weak self] enabled in self?.submitButton.isEnabled = enabled }
    }
}

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}

