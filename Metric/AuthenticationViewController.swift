//
//  AuthenticationViewController.swift
//  Metric
//
//  Created by Chance Daniel on 2/14/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import UIKit

var shouldAllowTouchID: Bool!
var authManager = Authentication()


class AuthenticationViewController: UIViewController {
   
   private var password = [Int?](count: 4, repeatedValue: nil)
   private var passwordValidation = [Int?](count: 4, repeatedValue: nil)
   private var passIndex = 0
   var dotNumber = 0
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
   @IBOutlet weak var touchIDButton: UIButton!
   
   override func viewWillAppear(animated: Bool) {
      passwordMode = "verify"
      if !retrievePassword() {
            passwordMode = "set"
      }
      
      setupView()
   }

   override func viewDidAppear(animated: Bool) {
      super.viewDidAppear(animated)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "touchIDFillDots", name: fillDotsNotificationKey, object: nil)
      
      if shouldAllowTouchID == true {
         authManager.authenticateUser()
      }
     
   }
   override func viewDidLoad(){
      
   }
   
   func setupView() {
      view.backgroundColor = UIColor.clearColor()
      
      
      //Create Blur
      //      var systemVersion = UIDevice.currentDevice().systemVersion
      //      var blurEffect: AnyObject
      //      if systemVersion.toInt() > 8 {
      //          blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark) as UIBlurEffect
      //      }
      //      else {
      //          blurEffect =
      //      }

      let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
      let blurView = UIVisualEffectView(effect: blurEffect)
      blurView.frame.size = self.view.frame.size
      self.view.insertSubview(blurView, atIndex: 0)

      
      //Setup Dots
      println(self.view.frame.width)
      let dotsLayer = CALayer()
      dotsLayer.frame = view.frame
      
      
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
      fillDot()
   }
   
   @IBAction func touchUpTwo(sender: AnyObject) {
      enterPassword(2)
      fillDot()
   }
   
   @IBAction func touchUpThree(sender: AnyObject) {
      enterPassword(3)
      fillDot()
   }

   @IBAction func touchUpFour(sender: AnyObject) {
      enterPassword(4)
      fillDot()
   }
   
   @IBAction func touchUpFive(sender: AnyObject) {
      enterPassword(5)
      fillDot()
   }
   
   @IBAction func touchUpSix(sender: AnyObject) {
      enterPassword(6)
      fillDot()
   }
  
   @IBAction func touchUpSeven(sender: AnyObject) {
      enterPassword(7)
      fillDot()
   }
   
   @IBAction func touchUpEight(sender: AnyObject) {
      enterPassword(8)
      fillDot()
   }
   
   @IBAction func touchUpEleven(sender: AnyObject) {
      enterPassword(9)
      fillDot()
   }
   
   @IBAction func touchUpZero(sender: AnyObject) {
      enterPassword(0)
      fillDot()
   }
   
   @IBAction func touchUpTouchID(sender: AnyObject) {
      authManager.authenticateUser()
   }
   
   
   func retrievePassword () -> Bool {
      let storedPassword = metricsManager.password
      if storedPassword.count == 4 && storedPassword[0] != nil{
         return true
      }
      return false
   }
   
   func enterPassword(input: Int?) {
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
                  label.text = "Please Confirm Passcode \n "
                  label.setNeedsDisplay()
                  Helper.delay(0.5, closure: { () -> () in
                     self.fillDot()
                  })
                  
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
                     
                     
                     let dots = [firstDot, secondDot, thirdDot, fourthDot]
                     for dot in dots {
                        animateDot(dot)
                     }
                     
                     passwordStep = 0
                     passIndex = 0
                     passwordsMatch = false
                     Helper.delay(1.5, closure: { () -> () in
                        self.label.text = "Set Passcode to \n Protect Metrik"
                        self.label.setNeedsDisplay()
                        self.fillDot()
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
               label.text = "Password Set \n "
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
                     
                     let dots = [firstDot, secondDot, thirdDot, fourthDot]
                     for dot in dots {
                        animateDot(dot)
                     }
                     
                     passwordsMatch = false
                     Helper.delay(1.5, closure: { () -> () in
                        self.label.text = "Enter Passcode to \n Unlock Metrik"
                        self.label.setNeedsDisplay()
                        self.fillDot()
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
   
   func fillDot() {
      switch dotNumber {
      case 0:
         firstDot.highlighted = true
         dotNumber = 1
         break
      case 1:
         secondDot.highlighted = true
         dotNumber = 2
         break
      case 2:
         thirdDot.highlighted = true
         dotNumber = 3
         break
      case 3:
         fourthDot.highlighted = true
         dotNumber = 4
         break
      case 4:
         firstDot.highlighted = false
         secondDot.highlighted  = false
         thirdDot.highlighted = false
         fourthDot.highlighted = false
         dotNumber = 0
         break
      default:
         break
         
      }
   }

   func animateDot(dot: UIImageView){
      let shakeAnimation = CABasicAnimation(keyPath: "position")
      shakeAnimation.duration = 0.04
      shakeAnimation.repeatCount = 2
      shakeAnimation.autoreverses = true
      shakeAnimation.fromValue = NSValue(CGPoint: CGPointMake(dot.center.x - 20, dot.center.y))
      shakeAnimation.toValue = NSValue(CGPoint: CGPointMake(dot.center.x + 20, dot.center.y))
      dot.layer.addAnimation(shakeAnimation, forKey: "position")
   }
   
   func touchIDFillDots() {
      firstDot.highlighted = true
      secondDot.highlighted  = true
      thirdDot.highlighted = true
      fourthDot.highlighted = true
      
   }
   
   
}



