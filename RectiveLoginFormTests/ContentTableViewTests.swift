//
//  ContentTableViewTests.swift
//  RectiveLoginForm
//
//  Created by Nowaczyk Axel on 04/09/2017.
//  Copyright © 2017 Nowaczyk Axel. All rights reserved.
//

import XCTest
import Result
@testable import RectiveLoginForm

class ContentTableViewOkTests: XCTestCase {

    let vm = ContentTableViewModel(cp: ContentProvider(function: { () -> ContentProviderResponse in
        return .success([ContentModel(title: "12"),ContentModel(title: "23"),ContentModel(title: "34"),ContentModel(title: "45")])
    }))

    let receivedData = TestObserver<String?, NoError>()

    override func setUp() {
        super.setUp()
        self.vm.outputs.receivedData.observe(self.receivedData.observer)
    }


    func testContent() {
        self.vm.inputs.viewDidLoad()

        self.receivedData.assertValues([nil])
    }

    func testContentShouldReloadData() {
        self.vm.inputs.viewDidLoad()

        self.vm.inputs.shouldReloadData()
        self.receivedData.assertValues([nil, nil])
    }

}

class ContentTableViewFailureTests: XCTestCase {

    let vm = ContentTableViewModel(cp: ContentProvider(function: { () -> ContentProviderResponse in
        return .failure(ContentProviderError.default)
    }))

    let receivedData = TestObserver<String?, NoError>()

    override func setUp() {
        super.setUp()
        self.vm.outputs.receivedData.observe(self.receivedData.observer)
    }


    func testContent() {
        self.vm.inputs.viewDidLoad()

        self.receivedData.assertValues([nil])
    }

    func testContentShouldReloadData() {
        self.vm.inputs.viewDidLoad()

        self.vm.inputs.shouldReloadData()
        self.receivedData.assertValues([nil, "ContentProviderError"])
    }
    
}
