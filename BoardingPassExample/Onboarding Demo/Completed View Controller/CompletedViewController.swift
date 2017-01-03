//
//  CompletedViewController.swift
//  BoardingPass
//
//  Created by Michael Skiba on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit
import BoardingPass

class CompletedViewController: UIViewController {

    weak var onboardingDelegate: OnboardingViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationItem.title = NSLocalizedString("Completed", comment: "completed onboarding title")
        let resetButton = UIButton(title: NSLocalizedString("Reset", comment: "Reset button title"), font: .onboardingFont)
        resetButton.addTarget(self, action: #selector(handleResetTapped), for: .touchUpInside)
        view.addSubview(resetButton)
        let constraints: [NSLayoutConstraint] = [
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomLayoutGuide.topAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 10),
            ]
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let factory: AnimationFactory = { [unowned self]  (_, _) in
            return self.animation
        }
        perform(coordinatedAnimations: factory)
    }
}

extension CompletedViewController: BackgroundColorProvider {

    var backgroundColor: UIColor {
        return .white
    }

    var currentProgress: Progress {
        return Progress(completedUnitCount: 4, totalUnitCount: 4)
   }

}

private extension CompletedViewController {
    @objc func handleResetTapped(_ sender: UIButton) {
        guard let origin = navigationController?.viewControllers.first else {
            return
        }
        _ = navigationController?.popToViewController(origin, animated: true)
    }
}
