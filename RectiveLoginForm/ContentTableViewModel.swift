//
//  ContentTableViewModel.swift
//  RectiveLoginForm
//
//  Created by Nowaczyk Axel on 29/08/2017.
//  Copyright © 2017 Nowaczyk Axel. All rights reserved.
//

import ReactiveSwift
import Result

protocol ContentTableViewModelInputs {
    func shouldReloadData()
    func viewDidLoad()
}

protocol ContentTableViewModelOutputs {
    var receivedData: Signal<[String], NoError> { get }
}

protocol ContentTableViewModelType {
    var inputs: ContentTableViewModelInputs { get }
    var outputs: ContentTableViewModelOutputs { get }
}

struct ContentTableViewModel: ContentTableViewModelType, ContentTableViewModelInputs, ContentTableViewModelOutputs {

    let receivedData: Signal<[String], NoError>

    var inputs: ContentTableViewModelInputs { return self }
    var outputs: ContentTableViewModelOutputs { return self }

    let shouldReloadDataProperty = MutableProperty()
    func shouldReloadData() {
        self.shouldReloadDataProperty.value = ()
    }

    let viewDidLoadProperty = MutableProperty()
    func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }

    init() {
        self.receivedData = Signal.merge(
            self.viewDidLoadProperty.signal.map { _ in [] },
            self.shouldReloadDataProperty.signal.map { _ in
                switch arc4random() % 4 {
                case 0: return ["1","2","3"]
                case 1: return ["11","22","33"]
                case 2: return ["12","23","34"]
                default: return ["A","B","C"]
                }
            }
        )
    }
}
