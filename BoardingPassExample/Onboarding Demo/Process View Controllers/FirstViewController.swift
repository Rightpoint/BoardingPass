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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        performCoordinatedAnimations(animation)
    }

}

extension FirstViewController: BackgroundColorProvider {

    var backgroundColor: UIColor {
        return .darkGrayColor()
    }

    var currentProgress: NSProgress {
        return NSProgress(completedUnitCount: 1, totalUnitCount: 4)
    }

}

extension NSProgress {
    convenience init(completedUnitCount: Int64, totalUnitCount: Int64) {
        self.init(totalUnitCount: totalUnitCount)
        self.completedUnitCount = completedUnitCount
    }
}

extension UIButton {

    convenience init(title: String, font: UIFont) {
        self.init(type:.System)
        setTitle(title, forState: .Normal)
        titleLabel?.font = font
    }

}

extension UIBarButtonItem {
    static var backButton: UIBarButtonItem {
         return UIBarButtonItem(title: NSLocalizedString("Back", comment: "generic back button title"), style: .Plain, target: nil, action: nil)
    }

    static var skipButton: UIBarButtonItem {
        return UIBarButtonItem(title: NSLocalizedString("Skip", comment: "generic skip button title"), style: .Plain, target: nil, action: nil)
    }
}
