//
//  Helper.swift
//  Levare Associate
//
//  Created by Arun Prasad.S, ANGLER - EIT on 12/05/17.
//  Copyright © 2017 AngMac137. All rights reserved.
//

import Foundation

class SwiftHelper: NSObject {
    
    
    class var sharedObject: SwiftHelper {
        let sharedInstance: SwiftHelper = { SwiftHelper() }()
        return sharedInstance
    }
    
    //MARK - View

    func roundCorner(for view: UIView, radius: Float, borderColor color: UIColor) {
        view.layer.cornerRadius = CGFloat(radius)
        view.layer.borderWidth = 1
        view.layer.borderColor = color.cgColor
        view.clipsToBounds = true
    }
    func roundCorner(for view: UIView, withRadius radius: Float) {
        roundCorner(for: view, radius: radius, borderColor: UIColor.clear)
    }
    
 
    func roundCornerView(aView: UIView) {
        roundCorner(for: aView, radius: Float(aView.frame.size.width/2), borderColor: UIColor.clear)
    }
    
    func fadeAnimationfor(view aView: UIView, alpha aAlphaValue: Float, duration aDurationFloat: Float, delay aDelay:Float) {
   
    UIView.animate(withDuration: TimeInterval(aDurationFloat), delay:TimeInterval(aDelay), options: .curveEaseIn, animations: {() -> Void in
      
        aView.alpha = CGFloat(aAlphaValue)
        
    }, completion: {(_ finished: Bool) -> Void in
    
    })
        
        
}
    
    func showAlertView(_ aViewController: UIViewController, title aTitle: String, message aMessage: String, okButtonBlock okAction: @escaping (_ action: UIAlertAction) -> Void) {
        
        let alert = UIAlertController(title: aTitle, message: aMessage, preferredStyle: .alert)
        let Ok = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            okAction(action)
        })
        
        alert.addAction(Ok)
        aViewController.present(alert, animated: true, completion: { _ in })
    }
    
    
    func showAlertViewWithButtonTitle(_ aViewController: UIViewController, title aTitle: String, message aMessage: String, okButtonBlock okAction: @escaping (_ action: UIAlertAction) -> Void, cancelButtonBlock cancelAction: @escaping (_ action: UIAlertAction) -> Void) {
        
        let alert = UIAlertController(title: aTitle, message: aMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let Ok = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            okAction(action)
        })
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            
            cancelAction(action)
        })
        
        alert.addAction(Ok)
        alert.addAction(cancel)
        
        aViewController.present(alert, animated: true, completion: nil)
    }
    
    func showAlertViewWithButtonTitle(_ aViewController: UIViewController, title aTitle: String, message aMessage: String, okButtonBlock okAction: @escaping (_ action: UIAlertAction) -> Void, cancelButtonBlock cancelAction: @escaping (_ action: UIAlertAction) -> Void, isLeftAlign: Bool!) {
        let alert = UIAlertController(title: aTitle, message: aMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let Ok = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            okAction(action)
        })
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            
            cancelAction(action)
        })
        
        alert.addAction(Ok)
        alert.addAction(cancel)
        
        if (isLeftAlign == true) {
            
            let viewArray: [Any]? = alert.view.subviews.first?.subviews.first?.subviews.first?.subviews.first?.subviews.first?.subviews
            let alertMessage: UILabel? = viewArray?[1] as! UILabel!
            alertMessage?.textAlignment = .left
        }
        
        aViewController.present(alert, animated: true, completion: nil)

    }

}
