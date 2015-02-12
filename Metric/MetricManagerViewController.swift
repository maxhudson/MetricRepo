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
      var deleteConfirmation = UIAlertController(title: "Are you sure?", message: "This cannot be undone.", preferredStyle: UIAlertControllerStyle.Alert)
      
      deleteConfirmation.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
      deleteConfirmation.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action: UIAlertAction!) in
         metricsManager.metrics.removeAtIndex(currentMetricRow)
         
         if (trackAnalytics) {
            PFAnalytics.trackEventInBackground("Deleted Metric", block: nil)
         }
         
         self.performSegueWithIdentifier("DoneMetricFromList", sender: nil)
      }))
      
      presentViewController(deleteConfirmation, animated: true, completion: nil)
   }
   
   @IBAction func doneMetric(sender: AnyObject) {
      let noteText = metricTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
      if (noteText != "") {
         if manageMetricMode == "edit" {
            metricsManager.metrics[currentMetricRow].title = noteText
            performSegueWithIdentifier("DoneMetricFromSum", sender: nil)
         }
         if manageMetricMode == "add" {
            newMetric = Metric(title: noteText)
            performSegueWithIdentifier("DoneMetricFromList", sender: nil)
         }
      } else {
         var emptyTitle = UIAlertController(title: "Empty Title", message: "A metrik can't have an empty title.", preferredStyle: UIAlertControllerStyle.Alert)
         
         emptyTitle.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
         
         presentViewController(emptyTitle, animated: true, completion: nil)
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
      Helper.styleNavButton(cancleButton, fontName: Helper.buttonFont, fontSize: 25)
      Helper.styleNavButton(trashButton, fontName: Helper.buttonFont, fontSize: 25)
      
      if manageMetricMode == "add" {
         metricManagerView.backgroundColor = Helper.goldColor
         promptLabel.text = "Enter the name of the metrik you'd like to track"
         trashButton.removeFromSuperview()
         if (trackAnalytics) {
            PFAnalytics.trackEventInBackground("Created Metric", block: nil)
         }
      }
      
      if manageMetricMode == "edit" {
         metricManagerView.backgroundColor = Helper.purpleColor
         promptLabel.text = "Edit name"
         metricTextField.text = metricsManager.metrics[currentMetricRow].title
         if (trackAnalytics) {
            PFAnalytics.trackEventInBackground("Edited Metric", block: nil)
         }
      }
      
      doneButton.titleLabel?.font = UIFont(name: Helper.buttonFont, size: 18.0)
   }

   override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
      self.view.endEditing(true)
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      self.view.endEditing(true)
   }
}
