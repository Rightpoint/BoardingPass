# BoardingPass
> Navigate Your View Stack with Interactive Swipe Gestures

[![Build Status](https://travis-ci.org/Raizlabs/BoardingPass.svg?branch=develop)](https://travis-ci.org/Raizlabs/BoardingPass)
[![Version](https://img.shields.io/cocoapods/v/BoardingPass.svg?style=flat)](http://cocoapods.org/pods/BoardingPass)
[![License](https://img.shields.io/cocoapods/l/BoardingPass.svg?style=flat)](http://cocoapods.org/pods/BoardingPass)
[![Platform](https://img.shields.io/cocoapods/p/BoardingPass.svg?style=flat)](http://cocoapods.org/pods/BoardingPass)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

BoardingPass is a subclass of `UINavigationController` with interactive push and pop gestures. It offers behaviors similar to `UIPageViewController`, but with all of the familiar behaviors of navigation controllers, and the ability to easily animate property changes alongside the transitions.

![BoardingPass](Resources/boardingPass.gif)

## Features

- [x] Interactive swipe and pan transitions
- [x] Navigation Controller push and pop use slide animation as well
- [x] Supports animating other properties alongside the transition
- [x] Fine grained control over when the push and pop gestures should be active.

## Requirements

- iOS 9.0+
- Xcode 8.0+

## Installation with CocoaPods

BoardingPass is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BoardingPass'
```

## Installation with Carthage
Create a `Cartfile` that lists the framework and run `carthage update`. Follow the [instructions](https://github.com/Carthage/Carthage#if-youre-building-for-ios) to add `$(SRCROOT)/Carthage/Build/iOS/BoardingPass.framework` to an iOS project.

```ogdl
github "Raizlabs/BoardingPass"
```

#### Manually
1. Download all of the `.swift` files in `BoardingPass/` and drop them into your project.  
2. Congratulations!  

## Usage example

To see a complete example of using the gallery, take a look at the [sample project](https://github.com/Raizlabs/BoardingPass/blob/develop/BoardingPassExample/Onboarding%20Demo/OnboardingWrapperViewController.swift).

### Simple Boarding

At it's simplest, a `BoardingNavigationController` can be initialized with an array of view controllers, and that will allow the user to swipe forward and backward through the navigation stack.

```swift
func beginOnboarding() {
    let viewControllers = [
        FirstViewController(),
        SecondViewController(),
        ThirdViewController(),
        ]
    let onboarding = BoardingNavigationController(viewControllersToPresent: viewControllers)
    present(onboarding, animated: true, completion: nil)
}
```

### Controlling Navigation

For finer grained control over navigation, for instance to now allow the user to page backward after viewing the complete boarding stack, a view controller can conform to the `BoardingInformation` protocol and set a value for `nextViewController` or `previousViewController`.

```swift
extension ThirdViewController: BoardingInformation {

    var nextViewController: UIViewController? {
        let completed = CompletedViewController()
        return completed
    }

}
```

By returning a view controller outside of the series of view controllers to present, the `BoardingNavigationController` will disable the swipe gestures once the user advances to the `CompletedViewController`.

### Going Above and Beyond

To give the boarding stack a more custom look and feel, `BoadingPass` is designed to make it easy to add animations that run alongside the push and pop presentations. To add a progress slider and a background color alongside navigation animations.

The first step is defining a protocol that each of the presented view controllers is going to conform to, and a delegate protocol that the BoardingInformation subclass is going to conform to to allow the view controllers to communicate back up to the container.

```swift
protocol BackgroundColorProvider: class {

    weak var onboardingDelegate: OnboardingViewControllerDelegate? { get set }
    var backgroundColor: UIColor { get }
    var currentProgress: Progress { get }

}
```

```swift
protocol OnboardingViewControllerDelegate: class {

    var backgroundColor: UIColor? { get set }
    var progress: Progress { get set }

}
```

Next the `BackgroundColorProvider` can be extended to create a shared function the generate closure to animate the background color and progress indicator.

```
extension BackgroundColorProvider {

    var animation: (() -> Void) {
        return { [unowned self] in
            self.onboardingDelegate?.backgroundColor = self.backgroundColor
            self.onboardingDelegate?.progress = self.currentProgress
        }
    }

}
```

Then each class implementing `BackgroundColorProvider` needs to add a method to `viewWillAppear` to perform the coordinated animation alongside the current context, with a fallback of executing the animation if there is no context.

```swift
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let factory: AnimationFactory = { [unowned self]  (_, _) in
            return self.animation
        }
        perform(coordinatedAnimations: factory)
    }
```

## Contributing

Issues and pull requests are welcome! Please ensure that you have the latest [SwiftLint](https://github.com/realm/SwiftLint) installed before committing and that there are no style warnings generated when building.

Contributors are expected to abide by the [Contributor Covenant Code of Conduct](https://github.com/Raizlabs/BoardingPass/blob/develop/CONTRIBUTING.md).

## License

BoardingPass is available under the MIT license. See the LICENSE file for more info.

## Author

Michael Skiba, <mailto:mike.skiba@raizlabs.com> [@atelierclkwrk](https://twitter.com/atelierclkwrk)
