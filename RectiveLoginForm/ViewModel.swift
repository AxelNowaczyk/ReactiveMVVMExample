//
//  ViewModel.swift
//  RectiveLoginForm
//
//  Created by Nowaczyk Axel on 09/08/2017.
//  Copyright © 2017 Nowaczyk Axel. All rights reserved.
//

import ReactiveSwift
import Result

protocol ViewModelInputs {
    func nameChanged(name: String?)
    func emailChanged(email: String?)
    func passwordChanged(password: String?)
    func submitButtonPressed()
    func viewDidLoad()
}

protocol ViewModelOutputs {
    var alertMessage: Signal<String, NoError> { get }
    var submitButtonEnabled: Signal<Bool, NoError> { get }
}

protocol ViewModelType {
    var inputs: ViewModelInputs { get }
    var outputs: ViewModelOutputs { get }
}

class ViewModel: ViewModelType, ViewModelInputs, ViewModelOutputs {

    init() {

        let formData = Signal.combineLatest(
            self.emailChangedProperty.signal,
            self.nameChangedProperty.signal,
            self.passwordChangedProperty.signal
        )

        let successfulSignupMessage = formData
            .sample(on: self.submitButtonPressedProperty.signal)
            .filter(Crudentials.isValid(email:name:password:))
            .map { _ in "Successful" }

        let submittedFormDataInvalid = formData
            .sample(on: self.submitButtonPressedProperty.signal)
            .filter { !Crudentials.isValid(email: $0, name: $1, password: $2) }

        let unsuccessfulSignupMessage = submittedFormDataInvalid
            .take(first: 2)
            .map { _ in "Unsuccessful" }

        let tooManyAttemptsMessage = submittedFormDataInvalid
            .skip(first: 2)
            .map { _ in "Too Many Attempts" }

        self.alertMessage = Signal.merge(
            successfulSignupMessage,
            unsuccessfulSignupMessage,
            tooManyAttemptsMessage
        )

        self.submitButtonEnabled = Signal.merge(
            self.viewDidLoadProperty.signal.map { _ in false },
            formData.map(Crudentials.isPresent(email:name:password:)),
            tooManyAttemptsMessage.map { _ in false }
            )
            .take(until: tooManyAttemptsMessage.map { _ in () } )
    }

    let nameChangedProperty = MutableProperty<String?>(nil)
    func nameChanged(name: String?) {
        self.nameChangedProperty.value = name
    }

    let emailChangedProperty = MutableProperty<String?>(nil)
    func emailChanged(email: String?) {
        self.emailChangedProperty.value = email
    }

    let passwordChangedProperty = MutableProperty<String?>(nil)
    func passwordChanged(password: String?) {
        self.passwordChangedProperty.value = password
    }

    let submitButtonPressedProperty = MutableProperty()
    func submitButtonPressed() {
        self.submitButtonPressedProperty.value = ()
    }

    let viewDidLoadProperty = MutableProperty()
    func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    let alertMessage: Signal<String, NoError>
    let submitButtonEnabled: Signal<Bool, NoError>
    
    var inputs: ViewModelInputs { return self }
    var outputs: ViewModelOutputs { return self }
}
