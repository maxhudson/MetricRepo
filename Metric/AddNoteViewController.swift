//
//  AddNoteViewController.swift
//  Metric
//
//  Created by Chance Daniel on 2/5/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import UIKit

class AddNoteViewController: UIViewController, UINavigationControllerDelegate {
   
   @IBOutlet var addNoteView: UIView!
   @IBOutlet weak var noteTextView: UITextView!
   @IBOutlet weak var promptLabel: UILabel!
   @IBOutlet weak var doneButton: UIButton!
   @IBOutlet weak var cancleButton: UIButton!
   @IBOutlet weak var trashButton: UIButton!
   @IBOutlet weak var doneButtonConstraint: NSLayoutConstraint!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      noteTextView.becomeFirstResponder()
      setupView()
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

   @IBAction func trashNote(sender: AnyObject) {
      if (manageNoteMode == "edit") {
         currentFeeling.note = ""
      }
      if (trackAnalytics) {
         PFAnalytics.trackEventInBackground("Deleted Note", block: nil)
      }
      
      dismissViewControllerAnimated(true, completion: nil)
   }
   @IBAction func cancleNote(sender: AnyObject) {
      dismissViewControllerAnimated(true, completion: nil)
   }
   
   @IBAction func doneNote(sender: AnyObject) {
      if (manageNoteMode == "add" || manageNoteMode == "feedback") {
         if noteFrom == "summary"{
            performSegueWithIdentifier("DoneNoteFromSum", sender: nil)
         } else {
            performSegueWithIdentifier("DoneNoteFromList", sender: nil)
         }
      }
      
      if manageNoteMode == "edit" {
         performSegueWithIdentifier("DoneNoteFromSum", sender: nil)
      }
   }

   func setupView(){
      Helper.styleNavButton(cancleButton, fontName: Helper.buttonFont, fontSize: 25)
      Helper.styleNavButton(trashButton, fontName: Helper.buttonFont, fontSize: 25)
      
      addNoteView.backgroundColor = Helper.goldColor
      doneButton.backgroundColor = Helper.darkNavyColor
      
      noteTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
      
      if manageNoteMode == "add" {
         addNoteView.backgroundColor = Helper.goldColor
         trashButton.removeFromSuperview()
         promptLabel.text = "Keep it short if you can"
         if (trackAnalytics) {
            PFAnalytics.trackEventInBackground("Added Note", block: nil)
         }
      }
      
      if manageNoteMode == "edit" {
         addNoteView.backgroundColor = Helper.purpleColor
         noteTextView.text = currentFeeling.note
         promptLabel.text = "Edit note"
         if (trackAnalytics) {
            PFAnalytics.trackEventInBackground("Edited Note", block: nil)
         }
      }

      if manageNoteMode == "feedback" {
         addNoteView.backgroundColor = UIColor(white: 0.8, alpha: 1)
         trashButton.removeFromSuperview()
         promptLabel.text = "Any helpful details?"
         promptLabel.textColor = Helper.navBarColor
         doneButton.setTitle("SUBMIT", forState: .Normal)
         if (trackAnalytics) {
            PFAnalytics.trackEventInBackground("Submitted Feedback", block: nil)
         }
      }
      
      doneButton.titleLabel?.font = UIFont(name: Helper.buttonFont, size: 18.0)
   }
   
   override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
      self.view.endEditing(true)
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      self.view.endEditing(true)
      
      if (segue.identifier == "DoneNoteFromSum" || segue.identifier == "DoneNoteFromList") {
         var noteText = noteTextView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet());
         if (manageNoteMode == "add" || manageNoteMode == "edit") {
            if (noteText == "") {
               noteText = " ";
            }
            currentFeeling.note = noteText;
         } else if (manageNoteMode == "feedback") {
            var feedbackData = PFObject(className: "Feedback")
            feedbackData.setObject(feedback?.cat1, forKey: "cat1")
            feedbackData.setObject(feedback?.cat2, forKey: "cat2")
            feedbackData.setObject(feedback?.feeling, forKey: "feeling")
            feedbackData.setObject(noteText, forKey: "notes")
            feedbackData.save()
         }
      }
      
   }

   
   
   
}
