//
//  DemoCompatibility.swift
//  BoardingPass
//
//  Created by Adam Tierney on 9/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

#if swift(>=3.0)
#else

    typealias Progress = NSProgress

    extension CGAffineTransform {
        @nonobjc static let identity: CGAffineTransform = CGAffineTransformIdentity

        init(translationX: CGFloat, y: CGFloat) {
            self = CGAffineTransformMakeTranslation(translationX, y)
        }

        func scaledBy(x xVal: CGFloat, y yVal: CGFloat) -> CGAffineTransform {
            return CGAffineTransformScale(self, xVal, yVal)
        }

        func translatedBy(x xVal: CGFloat, y yVal: CGFloat) -> CGAffineTransform {
            return CGAffineTransformTranslate(self, xVal, yVal)
        }
    }

    extension UITransitionContextViewControllerKey {
        @nonobjc static let from: String = UITransitionContextFromViewControllerKey
        @nonobjc static let to: String = UITransitionContextToViewControllerKey
    }

    extension UIViewControllerTransitionCoordinatorContext {
        func viewController(forKey key: String) -> UIViewController? {
            return viewControllerForKey(key)
        }
    }

    extension UIColor {

        @nonobjc static var white: UIColor {
            return .whiteColor()
        }

        @nonobjc static var red: UIColor {
            return .redColor()
        }

        @nonobjc static var darkGray: UIColor {
            return .darkGrayColor()
        }

        @nonobjc static var lightGray: UIColor {
            return .lightGrayColor()
        }
    }

    extension UIControlEvents {
        static let touchUpInside: UIControlEvents = UIControlEvents.TouchUpInside
    }

    extension UIButton {
        func setTitle(title: String, for state: UIControlState) {
            setTitle(title, forState: state)
        }

        func addTarget(target: AnyObject?, action sel: Selector, for event: UIControlEvents) {
            addTarget(target, action: sel, forControlEvents: event)
        }
    }

    extension UIButtonType {
        @nonobjc static let system: UIButtonType = UIButtonType.System
    }

    extension UIBarButtonItemStyle {
        @nonobjc static let plain: UIBarButtonItemStyle = UIBarButtonItemStyle.Plain
    }

    extension UIFontTextStyle {
        @nonobjc static let title1: UIFontTextStyle = UIFontTextStyleTitle1
    }

    extension NSLayoutConstraint {
        class func activate(constraints: [NSLayoutConstraint]) {
            activateConstraints(constraints)
        }
    }

    extension NSLayoutAnchor {
        func constraint(equalTo anchor: NSLayoutAnchor, constant c: CGFloat = 0.0) -> NSLayoutConstraint {
            return constraintEqualToAnchor(anchor)
        }
    }

#endif

#if swift(>=2.3)
    #if swift(>=3.0)
    #else
        extension UIFont {
            @nonobjc class func preferredFont(forTextStyle style: UIFontTextStyle) -> UIFont {
                return preferredFontForTextStyle(style as String)
            }
        }
    #endif
#else

    extension UIFont {
        @nonobjc class func preferredFont(forTextStyle style: UIFontTextStyle) -> UIFont {
            return preferredFontForTextStyle(style.rawValue)
        }
    }

    struct UIFontTextStyle: RawRepresentable {
        typealias RawValue = String
        var rawValue: RawValue
        init?(rawValue: RawValue) {
            self.rawValue = rawValue
        }

        /// NOTE: This is only used as a compatibility measure for a uniform demo app code base.
        /// This pattern is *not* recommended and could be breaking in the future.
        static let UIFontTextStyleTitle1: UIFontTextStyle = UIFontTextStyle(rawValue: "UICTFontTextStyleTitle1")!
    }

    struct UITransitionContextViewControllerKey { }

#endif
