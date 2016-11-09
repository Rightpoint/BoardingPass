//
//  SecondViewController.swift
//  BoardingPass
//
//  Created by Michael Skiba on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit
import BoardingPass

class SecondViewController: ActionableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("Second", comment: "Second View controller title")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        perform(coordinatedAnimations: animation)
    }
}

extension SecondViewController: BackgroundColorProvider {

    var backgroundColor: UIColor {
        return UIColor(white: 0.5, alpha: 1)
    }

    var currentProgress: Progress {
        return Progress(completedUnitCount: 2, totalUnitCount: 4)
    }

}
