//
//  OnboardingWrapper.swift
//  BoardingPassExample
//
//  Created by Michael Skiba on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

class OnboardingWrapper: UINavigationController {

    static func sampleOnboarding() -> OnboardingWrapper {
        let onboarding = OnboardingWrapper.init(rootViewController: FirstViewController())
        return onboarding
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.whiteColor()
    }

}
