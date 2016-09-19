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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationItem.title = NSLocalizedString("Completed", comment: "completed onboarding title")
        let resetButton = UIButton(title: NSLocalizedString("Reset", comment: "Reset button title"), font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1))
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
        perform(coordinatedAnimations: animation)
    }
}

extension CompletedViewController: BackgroundColorProvider {

    var backgroundColor: UIColor {
        return .white
    }

    var currentProgress: Progress {
//        return Progress(parent: Progress4, userInfo: 4)
        let progress = Progress(totalUnitCount: 4)
        progress.completedUnitCount = 4
        return progress
    }

}

private extension CompletedViewController {
    @objc func handleResetTapped(_ sender: UIButton) {
        guard let origin = navigationController?.viewControllers.first else {
            return
        }
        navigationController?.popToViewController(origin, animated: true)
    }
}
