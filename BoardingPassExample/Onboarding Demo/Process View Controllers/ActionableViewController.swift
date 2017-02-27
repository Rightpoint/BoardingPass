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

    weak var onboardingDelegate: OnboardingViewControllerDelegate?

    override func viewDidLoad() {
        navigationItem.backBarButtonItem = UIBarButtonItem.backButton
        navigationItem.rightBarButtonItem = UIBarButtonItem.skipButton
        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(handleSkipTapped)
        let nextButton = UIButton(title: NSLocalizedString("Next", comment: "Next button title"), font: .onboardingFont)
        nextButton.addTarget(self, action: #selector(handleNextTapped), for: .touchUpInside)
        view.addSubview(nextButton)
        let constraints: [NSLayoutConstraint] = [
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomLayoutGuide.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 10),
            ]
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let factory: AnimationFactory?
        if let backgroundColorProvider = self as? BackgroundColorProvider {
            factory = { [unowned backgroundColorProvider] (_, _) in
                return backgroundColorProvider.animation
            }
        }
        else {
           factory = nil
        }
        perform(coordinatedAnimations: factory)
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
