//
//  ContentTableViewController.swift
//  RectiveLoginForm
//
//  Created by Nowaczyk Axel on 28/08/2017.
//  Copyright © 2017 Nowaczyk Axel. All rights reserved.
//

import UIKit
import ReactiveSwift

class ContentTableViewController: UITableViewController {

    let vm: ContentTableViewModelType = ContentTableViewModel(cp: ContentProvider(function: { () -> ContentProviderResponse in
        struct StaticVaribales {
            static var counter = 0
        }

        defer {
            StaticVaribales.counter += 1
            StaticVaribales.counter %= 4
        }

        switch StaticVaribales.counter {
        case 0: return .success([ContentModel(title: "1"),ContentModel(title: "2"),ContentModel(title: "3")])
        case 1: return .success([ContentModel(title: "A"),ContentModel(title: "B"),ContentModel(title: "C")])
        case 2: return .success([ContentModel(title: "12"),ContentModel(title: "23"),ContentModel(title: "34"),ContentModel(title: "45")])
        default: return .failure(ContentProviderError(localizedDescription: "ContentProviderError Occured", code: 10001))
        }
    }))

    override func viewDidLoad() {
        super.viewDidLoad()

        self.vm.outputs.receivedData
            .observe(on: UIScheduler())
            .observeValues { [weak self] errorMessage in
                self?.tableView.reloadData()

                if let errorMessage = errorMessage {
                    let alert = AlertCreator.createSimpleAlert(title: nil, message: errorMessage)
                    self?.present(alert, animated: true, completion: nil)
                }
        }

        self.vm.inputs.viewDidLoad()
        self.vm.inputs.shouldReloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.outputs.contentCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)

        cell.textLabel?.text = vm.outputs.element(at: indexPath)?.title ?? "Unknown Title"

        return cell
    }
}
