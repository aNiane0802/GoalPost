//
//  ViewExtension.swift
//  GoalPost
//
//  Created by Aboubakrine Niane on 09/04/2018.
//  Copyright © 2018 Aboubakrine Niane. All rights reserved.
//

import UIKit

extension UIView {
    
    func bindToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleKeyboardWillShow(_ notification: NSNotification){
        guard let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval, let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as? UInt else {
            return
        }
        guard let endFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? CGRect , let beginFrame = notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? CGRect else {
            return
        }
        //Be careful to that line
        let deltaY = endFrame.origin.y - beginFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .init(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }, completion: nil)
    }
    
    @objc func handleKeyboardWillHide(_ notification: NSNotification){
        guard let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval, let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as? UInt else {
            return
        }
        guard let endFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? CGRect , let beginFrame = notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? CGRect else {
            return
        }
        let deltaY = endFrame.origin.y - beginFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .init(rawValue: curve), animations: {
            self.frame.origin.y -= -deltaY
        }, completion: nil)
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self)
    }
    
}
