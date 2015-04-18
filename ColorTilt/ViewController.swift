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
    
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    let motionManager = CMMotionManager()
    let numberFormatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.numberFormatter.maximumFractionDigits = 3
        self.numberFormatter.minimumFractionDigits = 3
        
        self.motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue()) {
            (data: CMDeviceMotion?, error: NSError?) -> Void in
            if let unwrappedError = error {
                println(unwrappedError.localizedFailureReason)
            } else if let unwrappedData = data {
                let quaternion = self.absoluteQuaternion(unwrappedData.attitude.quaternion)
                dispatch_async(dispatch_get_main_queue()) {
                    self.colorView.backgroundColor = self.colorFromQuaternion(quaternion)
                    self.colorLabel.text = self.stringFromQuaternion(quaternion)
                }
            }
        }
    }
    
    func absoluteQuaternion(quaternion: CMQuaternion) -> CMQuaternion {
        return CMQuaternion(x: fabs(quaternion.x),
                            y: fabs(quaternion.y),
                            z: fabs(quaternion.z),
                            w: fabs(quaternion.w))
    }
    
    func colorFromQuaternion(quaternion: CMQuaternion) -> UIColor {
        return UIColor(hue: CGFloat(quaternion.x),
                       saturation: CGFloat(quaternion.y),
                       brightness: CGFloat(quaternion.z),
                       alpha: CGFloat(quaternion.w))
    }
    
    func stringFromQuaternion(quaternion: CMQuaternion) -> String? {
        if let
            h = self.numberFormatter.stringFromNumber(quaternion.x),
            s = self.numberFormatter.stringFromNumber(quaternion.y),
            b = self.numberFormatter.stringFromNumber(quaternion.z),
            a = self.numberFormatter.stringFromNumber(quaternion.w) {
            return "Hue: \(h) Saturation: \(s)\nBrightness: \(b) Alpha: \(a)"
        }
        return nil
    }

}

