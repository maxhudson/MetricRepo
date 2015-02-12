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
//      if let parentVC = self.parentViewController as? SummaryViewController {
//         parentVC.tableView.reloadData()
//      }
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
      dismissViewControllerAnimated(true, completion: { () -> Void in
         currentFeeling.note = ""
      })
   }
   @IBAction func cancleNote(sender: AnyObject) {
      dismissViewControllerAnimated(true, completion: nil)
   }
   
   @IBAction func doneNote(sender: AnyObject) {
      if manageNoteMode == "add" {
         if noteFrom == "summary"{
            performSegueWithIdentifier("DoneNoteFromSum", sender: nil)
         }
         else {
            performSegueWithIdentifier("DoneNoteFromList", sender: nil)
         }
      }
      if manageNoteMode == "edit" {
         performSegueWithIdentifier("DoneNoteFromSum", sender: nil)
      }
   }


   func setupView(){
      doneButton.backgroundColor = Helper.darkNavyColor
      addNoteView.backgroundColor = Helper.goldColor
      cancleButton.backgroundColor = Helper.darkNavyColor
      
      if manageNoteMode == "add" {
         addNoteView.backgroundColor = Helper.goldColor
         promptLabel.text = "Keep it short if you can?"
         trashButton.removeFromSuperview()
      }
      
      if manageNoteMode == "edit" {
         addNoteView.backgroundColor = Helper.purpleColor
         noteTextView.text = currentFeeling.note
         promptLabel.text = "Made a mistake?"
      }

      
   }
   
   override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
      self.view.endEditing(true)
   }
   
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      self.view.endEditing(true)
      if segue.identifier == "DoneNoteFromSum" {
         if let note = noteTextView.text {
            if !note.isEmpty {
               currentFeeling.note = note
            }
         }
      }
      
      if segue.identifier == "DoneNoteFromList" {
         if let note = noteTextView.text {
            if !note.isEmpty {
               currentFeeling.note = note
            
            }
         }
      }
   }

   
   
   
}
