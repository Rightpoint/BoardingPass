//
//  FirstViewController.swift
//  BoardingPass
//
//  Created by Michael Skiba on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit
import BoardingPass

class FirstViewController: ActionableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("First", comment: "First View controller title")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animate(color: .darkGray)
    }
}
