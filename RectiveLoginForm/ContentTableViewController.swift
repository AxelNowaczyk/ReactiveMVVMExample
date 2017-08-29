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

    let vm: ContentTableViewModelType = ContentTableViewModel()
    var titles: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.vm.outputs.receivedData
            .observe(on: UIScheduler())
            .observeValues { [weak self] titles in

                self?.titles = titles 
                self?.tableView.reloadData()
        }

        self.vm.inputs.viewDidLoad()
        self.vm.inputs.shouldReloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)

        cell.textLabel?.text = titles[indexPath.row]

        return cell
    }
}
