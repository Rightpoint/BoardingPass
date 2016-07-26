//
//  FirstViewController.swift
//  BoardingPass
//
//  Created by Michael Skiba on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit
import BoardingPass

class ActionableViewController: UIViewController {

    override func viewDidLoad() {
        navigationItem.backBarButtonItem = UIBarButtonItem.backButton
        navigationItem.rightBarButtonItem = UIBarButtonItem.skipButton
        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(handleSkipTapped)
        let nextButton = UIButton(title: NSLocalizedString("Next", comment: "Next button title"), font: UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1))
        nextButton.addTarget(self, action: #selector(handleNextTapped), forControlEvents: .TouchUpInside)
        view.addSubview(nextButton)
        let constraints: [NSLayoutConstraint] = [
            nextButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
            bottomLayoutGuide.topAnchor.constraintEqualToAnchor(nextButton.bottomAnchor, constant: 10),
            ]
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints(constraints)
    }

}

private extension ActionableViewController {
    @objc func handleNextTapped(sender: UIButton) {
        guard let next = (self as? BoardingInformation)?.nextViewController else {
            return
        }
        navigationController?.pushViewController(next, animated: true)
    }

    @objc func handleSkipTapped(sender: UIButton) {
        navigationController?.pushViewController(CompletedViewController(), animated: true)
    }
}

class FirstViewController: ActionableViewController, BoardingInformation {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("First", comment: "First View controller title")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        performAlongsideCurrentCoordinator(animation, cancelation: cancellation)
    }

    var nextViewController: UIViewController? {
        return SecondViewController()
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
