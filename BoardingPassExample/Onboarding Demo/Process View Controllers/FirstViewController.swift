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

extension Progress {
    convenience init(completedUnitCount: Int64, totalUnitCount: Int64) {
        self.init(totalUnitCount: totalUnitCount)
        self.completedUnitCount = completedUnitCount
    }
}

extension UIButton {

    convenience init(title: String, font: UIFont) {
        self.init(type:.system)
        setTitle(title, for: UIControlState())
        titleLabel?.font = font
    }

}

extension UIBarButtonItem {
    static var backButton: UIBarButtonItem {
         return UIBarButtonItem(title: NSLocalizedString("Back", comment: "generic back button title"), style: .plain, target: nil, action: nil)
    }

    static var skipButton: UIBarButtonItem {
        return UIBarButtonItem(title: NSLocalizedString("Skip", comment: "generic skip button title"), style: .plain, target: nil, action: nil)
    }
}

extension UIViewController {
    func animate(color: UIColor) {
        perform(coordinatedAnimations: { (vc, _) -> (() -> Void) in
            return {
                vc?.view.backgroundColor = color
            }
        })
    }
}
