//
//  ActionableViewController.swift
//  BoardingPass
//
//  Created by Michael Skiba on 7/27/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit
import BoardingPass

@objc protocol NavigationActionResponder: NSObjectProtocol {
    func handleNextTapped(_ sender: UIResponder)
    func handleSkipTapped(_ sender: UIResponder)
}

class ActionableViewController: UIViewController {

    override func viewDidLoad() {
        navigationItem.backBarButtonItem = UIBarButtonItem.backButton
        navigationItem.rightBarButtonItem = UIBarButtonItem.skipButton
        navigationItem.rightBarButtonItem?.target = nil
        navigationItem.rightBarButtonItem?.action = #selector(NavigationActionResponder.handleSkipTapped)
        let nextButton = UIButton(title: NSLocalizedString("Next", comment: "Next button title"), font: .onboardingFont)
        nextButton.addTarget(nil, action: #selector(NavigationActionResponder.handleNextTapped), for: .touchUpInside)
        view.addSubview(nextButton)
        let constraints: [NSLayoutConstraint] = [
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomLayoutGuide.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 10),
            ]
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }
}
