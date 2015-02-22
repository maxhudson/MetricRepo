//
//  TutorialAddPersonViewController.swift
//  Metric
//
//  Created by Chance Daniel on 2/8/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import UIKit

class TutorialAddPersonViewController: UIViewController {
   var newMetric: Metric!
   let transitionManager = TransitionManager()


   
   @IBOutlet weak var nextButtonConstraint: NSLayoutConstraint!
   @IBOutlet weak var promptLabelOne: UILabel!
   @IBOutlet weak var promptLabelTwo: UILabel!
   
   @IBOutlet weak var textField: UITextField!
   
   @IBOutlet weak var backButton: UIButton!
   
   @IBOutlet weak var nextButton: UIButton!
   
   @IBAction func backButtonPressed(sender: AnyObject) {
      self.view.clipsToBounds = true;

//      dismissViewControllerAnimated(false, completion: nil)

   }
   
//   override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
//      return CustomSlideSegue()
//   }
   
   
   @IBAction func nextButtonPressed(sender: AnyObject) {
      if let title = textField.text {
         if !title.isEmpty{
            newMetric = Metric(title: title)
            metricsManager.tutorialMetrics.append(newMetric)
            
//            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("tutorialAddActivityViewController") as TutorialAddActivityViewController
//            let customSegue = CustomSlideSegue(identifier: "anyid", source: self, destination: vc, shouldUnwind: false)
//            customSegue.perform()
            
            performSegueWithIdentifier("GoToAddActivitySegue", sender: nil)

         }
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      //textField.becomeFirstResponder()
      setupView()
   }
   
   override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
      self.view.endEditing(true)

      NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
      
//      textField.becomeFirstResponder()
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
      promptLabelOne.text = "Enter the name of \n a significant person \n in your life"
      backButton.titleLabel?.font = UIFont(name: Helper.buttonFont, size: 18.0)
      nextButton.titleLabel?.font = UIFont(name: Helper.buttonFont, size: 18.0)
      nextButton.titleLabel?.textColor = Helper.purpleColor
      //textField.becomeFirstResponder()
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      // Create reference to the view that we are about to transition to
      let toViewController = segue.destinationViewController as UIViewController
      
      // Set TransitionManager to manage the transtion animation
      transitionManager.animationName = "slideLeft"
      toViewController.transitioningDelegate = self.transitionManager
   }
   
   override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
      self.view.endEditing(true)
   }
   
//     override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
//      return CustomSlideSegue(identifier: identifier, source: fromViewController, destination: toViewController, shouldUnwind: true)
//   }
   
   
   @IBAction func unwindToPerson(segue: UIStoryboardSegue){
      
   }
   
   
}
