//
//  AuthenticationViewController.swift
//  Metric
//
//  Created by Chance Daniel on 2/14/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {
   
   private var password = [Int?](count: 4, repeatedValue: nil)
   private var passwordValidation = [Int?](count: 4, repeatedValue: nil)
   private var passIndex = 0
   var validPassword = false
   var passwordMode: String!
   var passwordStep = 0
   @IBOutlet var backgroundView: UIView!
   
   @IBOutlet weak var label: UILabel!
   @IBOutlet weak var firstDot: UIImageView!
   
   @IBOutlet weak var secondDot: UIImageView!
   @IBOutlet weak var thirdDot: UIImageView!
   @IBOutlet weak var fourthDot: UIImageView!
   
   
   @IBOutlet weak var oneButton: UIButton!
   @IBOutlet weak var twoButton: UIButton!
   @IBOutlet weak var threeButton: UIButton!
   @IBOutlet weak var fourButton: UIButton!
   @IBOutlet weak var fiveButton: UIButton!
   @IBOutlet weak var sixButton: UIButton!
   @IBOutlet weak var sevenButton: UIButton!
   @IBOutlet weak var eightButton: UIButton!
   @IBOutlet weak var nineButton: UIButton!
   @IBOutlet weak var zeroButton: UIButton!
   
   override func viewWillAppear(animated: Bool) {
      passwordMode = "verify"
      if !retrievePassword() {
            passwordMode = "set"
      }
      
      setupView()
   }

   override func viewDidAppear(animated: Bool) {
     
   }
   override func viewDidLoad(){
      
   }
   
   func setupView() {
      view.backgroundColor = UIColor.clearColor()
      
      //Create Blur
      let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
      let blurView = UIVisualEffectView(effect: blurEffect)
      blurView.frame.size = self.view.frame.size
      self.view.insertSubview(blurView, atIndex: 0)

      
      //Setup Dots
      println(self.view.frame.width)
      
      
      //Setup Label
      if passwordMode == "set" {
         label.text = "Set Passcode to \n Protect Metrik"
      }
      else {
         label.text = "Enter Passcode to \n Unlock Metrik"
      }
      

      
   }
   
   @IBAction func touchUpOne(sender: AnyObject) {
      enterPassword(1)
   }
   
   @IBAction func touchUpTwo(sender: AnyObject) {
      enterPassword(2)
   }
   
   @IBAction func touchUpThree(sender: AnyObject) {
      enterPassword(3)
   }

   @IBAction func touchUpFour(sender: AnyObject) {
      enterPassword(4)
   }
   
   @IBAction func touchUpFive(sender: AnyObject) {
      enterPassword(5)
   }
   
   @IBAction func touchUpSix(sender: AnyObject) {
      enterPassword(6)
   }
  
   @IBAction func touchUpSeven(sender: AnyObject) {
      enterPassword(7)
   }
   
   @IBAction func touchUpEight(sender: AnyObject) {
      enterPassword(8)
   }
   
   @IBAction func touchUpEleven(sender: AnyObject) {
      enterPassword(9)
   }
   
   @IBAction func touchUpZero(sender: AnyObject) {
      enterPassword(0)
   }
   
   func retrievePassword () -> Bool {
      let storedPassword = metricsManager.password
      if storedPassword.count == 4 && storedPassword[0] != nil{
         return true
      }
      return false
   }
   
   func enterPassword(input: Int?) {
      animateDot()
        switch passwordMode {
        case "set":
            
            switch passwordStep {
            case 0:
               if(passIndex < 4) {
                  password[passIndex++] = input
               }
               if passIndex == 4 {
                  passwordStep = 1
                  passIndex = 0
                  label.text = "Please Confirm Passcode"
                  label.setNeedsDisplay()
                  
               }
            case 1:
           
               if(passIndex < 4) {
                  passwordValidation[passIndex++] = input
               }
               if passIndex == 4 {
                  passwordStep = 2
                  passIndex = 0
                  enterPassword(nil)
               }
               break
            case 2:
               //Verify passwords match
               passwordStep = 3
               var passwordsMatch = true
               for key in password {
                  if key != passwordValidation[passIndex++] {
                     label.text = "Passwords Did Not Match \n Please Try Again"
                     label.setNeedsDisplay()
                     passwordStep = 0
                     passIndex = 0
                     passwordsMatch = false
                     Helper.delay(1.5, closure: { () -> () in
                        self.label.text = "Set Passcode to \n Protect Metrik"
                        self.label.setNeedsDisplay()
                     })
                     break
                  }
               }
               if passwordsMatch {
                  enterPassword(nil)
               }
               break
            case 3:
               println("passwords match")
               self.view.userInteractionEnabled = false
               label.text = "Password Set"
               label.setNeedsDisplay()
               
               Helper.delay(1, closure: { () -> () in
                  self.dismissViewControllerAnimated(true, completion: { () -> Void in
                     self.view.userInteractionEnabled = true
                  })
               })
               passwordStep = 0
               metricsManager.password = password
               metricsManager.save()
               break
            default:
               break
            }
            
            break
        case "verify":
         
            switch passwordStep {
            case 0:
               if(passIndex < 4){
                  password[passIndex++] = input
               }
               if passIndex == 4 {
                  passwordStep = 1
                  passIndex = 0
                  enterPassword(nil)
               }
               break
            case 1:
               var passwordsMatch = true
               for key in metricsManager.password {
                  if key != password[passIndex++] {
                     label.text = "Passwords Did Not Match \n Please Try Again"
                     label.setNeedsDisplay()
                     passwordStep = 0
                     passIndex = 0
                     passwordsMatch = false
                     Helper.delay(1.5, closure: { () -> () in
                        self.label.text = "Enter Passcode to \n Unlock Metrik"
                        self.label.setNeedsDisplay()
                     })
                     break
                  }
               }
               if passwordsMatch {
                  self.dismissViewControllerAnimated(true, completion: nil)
               }
               break
            default:
               break
               
            }

            break
        default:
         break
         }
   }
   
   func animateDot() {
      
   }

   
      
//      
//      if setPasswordMode == true {
//         if(passIndex < 4){
//            password[passIndex++] = input
//         }
//         if passIndex == 4 {
//            //Have user re-enter password to confirm
//            label.text = "Please Confirm Passcode"
//            label.setNeedsDisplay()
//         }
//         
//            var confirmPassIndex = 0
//            if(confirmPassIndex < 4){
//               passwordValidation[confirmPassIndex++] = input
//            }
//            if(confirmPassIndex == 4) {
//               //Verify passwords match
//               var passwordsMatch = true
//               var index = 0
//               for key in password {
//                  if key != passwordValidation[index++] {
//                     passwordsMatch = false
//                     break
//                  }
//               }
//               
//               if passwordsMatch == true {
//                  setPasswordMode = false
//                  metricsManager.password = password as [Int]
//                  dismissViewControllerAnimated(true, completion: nil)
//               }
//            }
//         }
//      }
//      else {
//         
//         if(passIndex < 4){
//            password[passIndex++] = input
//         }
//         else {
//            //Verify password correct
//            var passwordsMatch = true
//            var index = 0
//            for key in metricsManager.password {
//               passwordValidation[index++] = key
//            }
//            index = 0
//            for key in password {
//               if key != passwordValidation[index++] {
//                  passwordsMatch = false
//                  break
//               }
//            }
//            
//            if passwordsMatch == true {
//               dismissViewControllerAnimated(true, completion: nil)
//            }
//
//         }
//      }
//   }
//   
//   func setPassword() {
//      label.text = "Set Passcode to \n Protect Metrik"
//      var passwordSet = false
//      
//
//   }
   
   func verifyPassword() {
      
   }
   
   
}



