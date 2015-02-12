//
//  MetricManagerViewController.swift
//  Metric
//
//  Created by Chance Daniel on 2/3/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import UIKit

class MetricManagerViewController: UIViewController {

   override func viewDidLoad() {
      super.viewDidLoad()
      metricTextField.becomeFirstResponder()
      setupView()

   }

//   override func viewDidDisappear(animated: Bool) {
//      if manageMetricMode == "edit" {
//         if let parentVC = self.parentViewController as? SummaryViewController {
//            parentVC.navBar.topItem?.title = currentMetric.title
//         }
//      }
//   }
   var newMetric: Metric!
   
   @IBOutlet weak var trashButton: UIButton!
   @IBOutlet weak var cancleButton: UIButton!
   @IBOutlet weak var doneButton: UIButton!
   @IBOutlet var metricManagerView: UIView!
   @IBOutlet weak var metricTextField: UITextField!
   @IBOutlet weak var promptLabel: UILabel!
   @IBOutlet weak var doneButtonConstraint: NSLayoutConstraint!
   
   @IBAction func trashMetric(sender: AnyObject) {
      metricsManager.metrics.removeAtIndex(currentMetricRow)
      performSegueWithIdentifier("DoneMetricFromList", sender: nil)
   }
   
   @IBAction func doneMetric(sender: AnyObject) {
      let noteText = metricTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
      if (noteText != "") {
         metricsManager.metrics[currentMetricRow].title = noteText
         
         if manageMetricMode == "edit" {
            performSegueWithIdentifier("DoneMetricFromSum", sender: nil)
         }
         if manageMetricMode == "add" {
            performSegueWithIdentifier("DoneMetricFromList", sender: nil)
         }
      } else {
         //popup
      }
   }
   
   @IBAction func cancelMetric(sender: AnyObject) {
      dismissViewControllerAnimated(true, completion: nil)
   }
   override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
   }
   
   override func viewWillDisappear(animated: Bool) {
      super.viewWillDisappear(animated)
      NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
      NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
   }
   
   func keyboardWillShowNotification(notification: NSNotification) {
      updateDoneButtonLayoutConstraintsWithNotificaiton(notification)
   }
   
   func keyboardWillHideNotification(notification: NSNotification) {
      updateDoneButtonLayoutConstraintsWithNotificaiton(notification)
   }
   
   func updateDoneButtonLayoutConstraintsWithNotificaiton(notification: NSNotification) {
      let userInfo = notification.userInfo!
      
      let animationDuraiton = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
      let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
      let convertedKeyboardEndFrame = view.convertRect(keyboardEndFrame, fromView: view.window)
      let rawAnimationCurve = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as NSNumber).unsignedIntValue << 16
      let animationCurve = UIViewAnimationOptions(UInt(rawAnimationCurve))
      
      doneButtonConstraint.constant = CGRectGetMaxY(view.bounds) - CGRectGetMinY(convertedKeyboardEndFrame)
      UIView.animateWithDuration(animationDuraiton, delay: 0.0, options: .BeginFromCurrentState | animationCurve, animations: {
         self.view.layoutIfNeeded()
      }, completion: nil)
      
      
   }
   
   func setupView(){
      doneButton.backgroundColor = Helper.darkNavyColor
      
      Helper.styleNavButton(cancleButton, fontName: Helper.buttonFont, fontSize: 25)
      Helper.styleNavButton(trashButton, fontName: Helper.buttonFont, fontSize: 25)
      
      if manageMetricMode == "add" {
         metricManagerView.backgroundColor = Helper.goldColor
         promptLabel.text = "Enter the name of the metric you'd like to track"
         trashButton.removeFromSuperview()

      }
      
      if manageMetricMode == "edit" {
         metricManagerView.backgroundColor = Helper.purpleColor
         promptLabel.text = "Modify the name of the metric you're tracking"
         metricTextField.text = metricsManager.metrics[currentMetricRow].title
      }
      
      
   }

   override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
      self.view.endEditing(true)
   }

   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      self.view.endEditing(true)
      
      if (segue.identifier == "DoneMetricFromList" || segue.identifier == "DoneMetricFromSum") {
      }

   }
   


}
