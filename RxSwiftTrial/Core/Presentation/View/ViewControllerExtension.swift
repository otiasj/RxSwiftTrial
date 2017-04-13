//
//  ViewControllerExtension.swift
//  RxSwiftTrial
//
//  This is used by all observable that needs to do some background work and post the result on the main thread
//
//  Created by Julien Saito on 4/13/17.
//  Copyright (c) 2017 otiasj. All rights reserved.
//

import UIKit
import RxSwift

enum ToastDuration {
    case short, long
}

extension UIViewController {
    
    /*
    ** show a simple dialog with a title, message and  button to dismiss it
    */
    func showDialog(title: String, message: String, button: String="OK", onDismiss: (()->())? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: button, style: .default) { (alertC) in
            onDismiss?()
        }
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /*
     ** show a toast message with a duration of short 2 seconds or long 3.5 seconds
     */
    func showToast(message : String, duration: ToastDuration=ToastDuration.short) {
        var durationInSeconds: Double?
        
        switch duration {
            case .short:
                durationInSeconds = 2
            case .long:
                durationInSeconds = 3.5
        }
        
        showToast(message: message,durationInSeconds: durationInSeconds!)
    }
    
    /*
     ** show a toast message with a customizable duration
     */
    func showToast(message : String, durationInSeconds: Double) {
        //configure the toast
        let toastLabel = UIPaddingLabel();
        toastLabel.alpha = 0.0
        toastLabel.padding = 10;
        toastLabel.translatesAutoresizingMaskIntoConstraints = false;
        toastLabel.backgroundColor = UIColor.darkGray;
        toastLabel.textColor = UIColor.white;
        toastLabel.textAlignment = .center;
        toastLabel.text = message;
        toastLabel.numberOfLines = 0;
        toastLabel.layer.cornerRadius = 20;
        toastLabel.clipsToBounds = true;
        
        if let view = self.view {
            view.addSubview(toastLabel)
            view.addConstraint(NSLayoutConstraint(item:toastLabel, attribute:.left, relatedBy:.greaterThanOrEqual, toItem:view, attribute:.left, multiplier:1, constant:20));
            view.addConstraint(NSLayoutConstraint(item:toastLabel, attribute:.right, relatedBy:.lessThanOrEqual, toItem:view, attribute:.right, multiplier:1, constant:-20));
            view.addConstraint(NSLayoutConstraint(item:toastLabel, attribute:.bottom, relatedBy:.equal, toItem:view, attribute:.bottom, multiplier:1, constant:-20));
            view.addConstraint(NSLayoutConstraint(item:toastLabel, attribute:.centerX, relatedBy:.equal, toItem:view, attribute:.centerX, multiplier:1, constant:0));
        }
        
        let showToastAnimation = Observable<Void>.create { observer in
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
                toastLabel.alpha = 0.9
                observer.onNext()
            }, completion: {_ in
                observer.onCompleted()
            })
            
            return Disposables.create()
        }
        
        let hideToastAnimation = Observable<Void>.create { observer in
            UIView.animate(withDuration: 0.5, delay: durationInSeconds, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
                observer.onNext()
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
                observer.onCompleted()
            })
            
            return Disposables.create()
        }
        
        //trigger the show toast then hide toast
        _ = showToastAnimation
            .concat(hideToastAnimation)
            .subscribe()
    }
}
