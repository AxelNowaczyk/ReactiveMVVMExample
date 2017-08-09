//
//  ViewController.swift
//  RectiveLoginForm
//
//  Created by Nowaczyk Axel on 09/08/2017.
//  Copyright © 2017 Nowaczyk Axel. All rights reserved.
//

import UIKit
import ReactiveSwift

class ViewController: UIViewController {

    let vm: ViewModelType = ViewModel()

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

extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vm.outputs.alertMessage
            .observe(on: UIScheduler())
            .observeValues { [weak self] message in
                let alert = UIAlertController(title: nil,
                                              message: message,
                                              preferredStyle: .alert)
                alert.addAction(.init(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
        }

        self.vm.outputs.submitButtonEnabled
            .observe(on: UIScheduler())
            .observeValues { [weak self] enabled in self?.submitButton.isEnabled = enabled }
        
        self.vm.inputs.viewDidLoad()
    }
}
