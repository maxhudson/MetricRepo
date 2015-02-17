//
//  TutorialAddActivityViewController.swift
//  Metric
//
//  Created by Chance Daniel on 2/9/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import Foundation
import UIKit

class TutorialAddActivityViewController: UIViewController {
   var newMetric: Metric!

   
   @IBOutlet weak var textField: UITextField!
   @IBOutlet weak var promptLabelTwo: UILabel!
   @IBOutlet weak var promptLabelOne: UILabel!
   @IBOutlet weak var backButton: UIButton!
   @IBOutlet weak var nextButton: UIButton!
   @IBOutlet weak var nextButtonConstraint: NSLayoutConstraint!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupView()
   }
   
   override func viewDidDisappear(animated: Bool) {
      super.viewDidDisappear(animated)
      self.view.endEditing(true)

   }
   
   @IBAction func backButtonPressed(sender: AnyObject) {
      self.view.clipsToBounds = true;
   }
   
   
   @IBAction func nextButtonPressed(sender: AnyObject) {
      if let title = textField.text {
         if !title.isEmpty{
            newMetric = Metric(title: title)
            metricsManager.tutorialMetrics.append(newMetric)
            performSegueWithIdentifier("DoneTutorialSegue", sender: nil)
            PFAnalytics.trackEventInBackground("Tutorial Completed", block: nil)
         }
      }
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      self.view.endEditing(true)
   }
   
   override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
      self.view.endEditing(true)
      
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
   }
   
   override func viewWillDisappear(animated: Bool) {
      super.viewWillDisappear(animated)
      NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
      NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
   }
   
   func keyboardWillShowNotification(notification: NSNotification) {
      updateNextButtonLayoutConstraintsWithNotificaiton(notification)
   }
   
   func keyboardWillHideNotification(notification: NSNotification) {
      updateNextButtonLayoutConstraintsWithNotificaiton(notification)
   }
   
   func updateNextButtonLayoutConstraintsWithNotificaiton(notification: NSNotification) {
      let userInfo = notification.userInfo!
      
      let animationDuraiton = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
      let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
      let convertedKeyboardEndFrame = view.convertRect(keyboardEndFrame, fromView: view.window)
      let rawAnimationCurve = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as NSNumber).unsignedIntValue << 16
      let animationCurve = UIViewAnimationOptions(UInt(rawAnimationCurve))
      
      nextButtonConstraint.constant = CGRectGetMaxY(view.bounds) - CGRectGetMinY(convertedKeyboardEndFrame)
      UIView.animateWithDuration(animationDuraiton, delay: 0.0, options: .BeginFromCurrentState | animationCurve, animations: {
         self.view.layoutIfNeeded()
         }, completion: nil)
   }
   
   func setupView() {
      promptLabelOne.font = UIFont(name: Helper.bodyTextFont, size: 18.0)
      promptLabelOne.text = "Name something else \nyou're not sure \nhow you feel about"
      backButton.titleLabel?.font = UIFont(name: Helper.buttonFont, size: 18.0)
      nextButton.titleLabel?.font = UIFont(name: Helper.buttonFont, size: 18.0)
      nextButton.titleLabel?.textColor = Helper.goldColor
   }
   
   override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
      self.view.endEditing(true)
   }
}
