//
//  ActionableViewController.swift
//  BoardingPass
//
//  Created by Michael Skiba on 7/27/16.
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
        (navigationController as? BoardingNavigationController)?.pushToNextViewController(animated: true)
    }

    @objc func handleSkipTapped(sender: UIButton) {
        navigationController?.pushViewController(CompletedViewController(), animated: true)
    }
}
