//
//  Loading.swift
//  CampusAccess
//
//  Created by Frida Gutiérrez Mireles on 17/05/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import UIKit

fileprivate var activityView : UIView?

extension UIViewController {
    
    func showSpinner() {

        activityView = UIView(frame: self.view.bounds)
        activityView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let activity = UIActivityIndicatorView(style: .large)
        activity.center = activityView!.center
        activity.startAnimating()
        activityView?.addSubview(activity)

        self.view.addSubview(activityView!)
        self.navigationController?.navigationBar.addSubview(activityView!)
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = false
    }
    
    func removeSpinner(){
        activityView?.removeFromSuperview()
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        self.view.isUserInteractionEnabled = true
        activityView = nil
    }
    
}
