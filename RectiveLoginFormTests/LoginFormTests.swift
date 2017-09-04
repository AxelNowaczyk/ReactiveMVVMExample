//
//  RectiveLoginFormTests.swift
//  RectiveLoginFormTests
//
//  Created by Nowaczyk Axel on 09/08/2017.
//  Copyright © 2017 Nowaczyk Axel. All rights reserved.
//

import XCTest
import Result
@testable import RectiveLoginForm

class LoginFormTests: XCTestCase {

    let vm: LoginViewModelType = LoginViewModel()
    let alertMessage = TestObserver<String, NoError>()
    let submitButtonEnabled = TestObserver<Bool, NoError>()

    override func setUp() {
        super.setUp()
        self.vm.outputs.alertResponse.observe(self.alertMessage.observer)
        self.vm.outputs.submitButtonEnabled.observe(self.submitButtonEnabled.observer)
    }

    func testSubmitButtonEnabled() {
        self.vm.inputs.viewDidLoad()
        self.submitButtonEnabled.assertValues([false])

        self.vm.inputs.nameChanged(name: "Namme")
        self.submitButtonEnabled.assertValues([false])

        self.vm.inputs.emailChanged(email: "corrrrect@password.com")
        self.submitButtonEnabled.assertValues([false])

        self.vm.inputs.passwordChanged(password: "Strong123Password!")
        self.submitButtonEnabled.assertValues([false, true])

        self.vm.inputs.nameChanged(name: "")
        self.submitButtonEnabled.assertValues([false, true, false])
    }

    func testSuccessfulSignup() {
        self.vm.inputs.viewDidLoad()
        self.vm.inputs.nameChanged(name: "Name")
        self.vm.inputs.emailChanged(email: "correct@email.com")
        self.vm.inputs.passwordChanged(password: "Password123!")
        self.vm.inputs.submitButtonPressed()

        self.alertMessage.assertValues(["Successful"])
    }

    func testUnsuccessfulSignup() {
        self.vm.inputs.viewDidLoad()
        self.vm.inputs.nameChanged(name: "Name")
        self.vm.inputs.emailChanged(email: "wrong@email")
        self.vm.inputs.passwordChanged(password: "Password123!")
        self.vm.inputs.submitButtonPressed()

        self.alertMessage.assertValues(["Unsuccessful"])
    }

    func testTooManyAttempts() {
        self.vm.inputs.viewDidLoad()
        self.vm.inputs.nameChanged(name: "Name")
        self.vm.inputs.emailChanged(email: "wrong@mail")
        self.vm.inputs.passwordChanged(password: "Password123!")

        self.vm.inputs.submitButtonPressed()
        self.vm.inputs.submitButtonPressed()
        self.vm.inputs.submitButtonPressed()

        self.alertMessage.assertValues(["Unsuccessful", "Unsuccessful", "Too Many Attempts"])
        self.submitButtonEnabled.assertValues([false, true, false])
        
        self.vm.inputs.emailChanged(email: "correct@mail")
        self.submitButtonEnabled.assertValues([false, true, false])
    }
    
}
