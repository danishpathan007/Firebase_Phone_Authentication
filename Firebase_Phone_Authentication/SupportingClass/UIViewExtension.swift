//
//  UIViewControllerExtension.swift
//  Hooty
//
//  Created by Sandeep Singh on 07/12/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get{
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set{
            self.layer.borderColor = newValue.cgColor
        }
        
    }
    @IBInspectable var borderWidth: CGFloat {
        get{
            return layer.borderWidth
        }
        set{
            self.layer.borderWidth = newValue
            
        }
    }
    @IBInspectable var shadowColor: UIColor? {
        get{
            return UIColor(cgColor: layer.shadowColor!)
        }
        set{
            self.layer.shadowColor = newValue?.cgColor
            
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get{
            return layer.shadowOffset
        }
        set{
            self.layer.shadowOffset = newValue
            
        }
    }
    @IBInspectable var shadowRadius: CGFloat {
        get{
            return layer.shadowRadius
        }
        set{
            self.clipsToBounds = false
            self.layer.shadowRadius = newValue
            
        }
    }
    @IBInspectable var shadowOpacity: Float {
        get{
            return layer.shadowOpacity
        }
        set{
            self.layer.shadowOpacity = newValue
            
        }
    }
	
  func setRoundCorners(_ corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
  }
    
    /**
     set view corner rounded
     */
   func set(cornerMask: CACornerMask, radious: CGFloat) {
        layer.cornerRadius = radious
        clipsToBounds = true
        layer.maskedCorners = cornerMask
    }
    
    
}


extension UIView {
    func applyBottomShadow(size:CGFloat) {
        let shadowSize = size
        let shadowHeight: CGFloat = frame.size.height + shadowSize
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y:shadowSize,
                                                   width: frame.size.width + shadowSize,
                                                   height: shadowHeight))
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowOpacity = 0.1
        layer.shadowPath = shadowPath.cgPath
    }
}

extension UIView {
    func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 0.4, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 1.0, delay: TimeInterval = 3.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}

extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
  }
}
