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
        let nextButton = UIButton(title: NSLocalizedString("Next", comment: "Next button title"), font: OnboardingFont)
        nextButton.addTarget(self, action: #selector(handleNextTapped), for: .touchUpInside)
        view.addSubview(nextButton)
        let constraints: [NSLayoutConstraint] = [
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomLayoutGuide.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 10),
            ]
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }

}

private extension ActionableViewController {
    @objc func handleNextTapped(_ sender: UIButton) {
        (navigationController as? BoardingNavigationController)?.pushToNextViewController(animated: true)
    }

    @objc func handleSkipTapped(_ sender: UIButton) {
        navigationController?.pushViewController(CompletedViewController(), animated: true)
    }
}
