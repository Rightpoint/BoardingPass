//
//  OnboardingNavigationViewController.swift
//  BoardingPassExample
//
//  Created by Michael Skiba on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import BoardingPass

extension UIFont {
    static let onboardingFont: UIFont = UIFont.systemFont(ofSize: 26.0)
}

class OnboardingNavigationViewController: UINavigationController {

    // We're creating a non-standard progress slider because the UIProgressView
    // has a visual glitch when the animation is cancelled, probably due to
    // CALayer animations
    let progressSlider = UIView()
    var progress = Progress() {
        didSet {
            let progressAmount = CGFloat(progress.fractionCompleted)
            var newTransform = CGAffineTransform.identity
            newTransform = newTransform.translatedBy(x: (-view.frame.width + (view.frame.width * progressAmount)), y: 0)
            progressSlider.transform = newTransform
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.addSubview(progressSlider)
        progressSlider.frame.size.height = 4
        progressSlider.frame.size.width = navigationBar.frame.width
        progressSlider.frame.origin.x = navigationBar.frame.origin.x
        progressSlider.frame.origin.y = navigationBar.frame.maxY - progressSlider.frame.height
        progressSlider.backgroundColor = .red
        view.backgroundColor = UIColor.white
    }

}
