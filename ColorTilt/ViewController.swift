//
//  ViewController.swift
//  ColorTilt
//
//  Created by Harlan Haskins on 8/18/14.
//  Copyright (c) 2014 haskins. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorLabel: UILabel!
    let motionManager = CMMotionManager()
    let numberFormatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.numberFormatter.maximumFractionDigits = 3
        self.numberFormatter.minimumFractionDigits = 3
        
        let fontDescriptor = self.colorLabel.font.fontDescriptor().fontDescriptorByAddingAttributes([
            UIFontDescriptorFeatureSettingsAttribute: [[
                UIFontFeatureTypeIdentifierKey: kNumberSpacingType,
                UIFontFeatureSelectorIdentifierKey: kMonospacedNumbersSelector
                ]]
            ])
        self.colorLabel.font = UIFont(descriptor: fontDescriptor, size: fontDescriptor.pointSize)
        
        self.motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue()) {
            (data: CMDeviceMotion?, error: NSError?) -> Void in
            if let unwrappedError = error {
                print(unwrappedError.localizedFailureReason)
            } else if let unwrappedData = data {
                dispatch_async(dispatch_get_main_queue()) {
                    let color = self.colorFromAttitude(unwrappedData.attitude)
                    self.colorView.backgroundColor = color
                    self.colorLabel.text = self.stringFromColor(color)
                }
            }
        }
    }
    
    func wrappedNumber(n: Double) -> CGFloat {
        return CGFloat(sin(fabs(n) / 2))
    }
    
    func colorFromAttitude(attitude: CMAttitude) -> UIColor {
        return UIColor(hue: wrappedNumber(attitude.yaw),
                       saturation: wrappedNumber(attitude.roll),
                       brightness: 1.0 - wrappedNumber(attitude.pitch),
                       alpha: 1.0)
    }
    
    func stringFromColor(color: UIColor) -> String? {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0
        color.getHue(&h, saturation: &s, brightness: &b, alpha: nil)
        
        if let
            h = self.numberFormatter.stringFromNumber(h),
            s = self.numberFormatter.stringFromNumber(s),
            b = self.numberFormatter.stringFromNumber(b) {
                return "Hue: \(h) Saturation: \(s)\nBrightness: \(b)"
        }
        return nil
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

