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
    var receivedData: Signal<Bool, NoError> { get }
    var contentCount: Int { get }
    func element(at index: IndexPath) -> ContentModel?
}

protocol ContentTableViewModelType {
    var inputs: ContentTableViewModelInputs { get }
    var outputs: ContentTableViewModelOutputs { get }
}

class ContentTableViewModel: ContentTableViewModelType, ContentTableViewModelInputs, ContentTableViewModelOutputs {

    private var contents: [ContentModel] = []
    let receivedData: Signal<Bool, NoError>

    var inputs: ContentTableViewModelInputs { return self }
    var outputs: ContentTableViewModelOutputs { return self }

    var contentCount: Int {
        return contents.count
    }

    func element(at index: IndexPath) -> ContentModel? {
        guard index.row < contentCount else { return nil }
        return self.contents[index.row]
    }

    let shouldReloadDataProperty = MutableProperty()
    func shouldReloadData() {
        ContentProvider.performContentRequest(completionHandler: { response in
            switch response {
            case .success(let contents):
                self.contents = contents
            case .failure(let error):
                print(error)
            }
        })
        self.shouldReloadDataProperty.value = ()
    }

    let viewDidLoadProperty = MutableProperty()
    func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }

    init() {
        self.receivedData = Signal.merge(
            self.viewDidLoadProperty.signal.map { _ in false },
            self.shouldReloadDataProperty.signal.map { _ in true }
        )
    }
}
