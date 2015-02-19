//
//  Authentication.swift
//  Metric
//
//  Created by Chance Daniel on 2/13/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import UIKit
import LocalAuthentication

let fillDotsNotificationKey = "com.metric.fillDotsNotificationKey"

class Authentication {
   
   init(){
      
   }

   func authenticateUser() {
      //Get the local authentication context.
      let context = LAContext()
      
      //Declare a NSError variable.
      var error: NSError?
      
      //Set the reason string that will appear on the authentication alert.
      var reasonString = "Authentication is needed to access your Metriks"
      context.localizedFallbackTitle = ""
      
      //Check if the device an evalutate the policy.
      if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error){
         [context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
            
            if success {
                  NSNotificationCenter.defaultCenter().postNotificationName(lockBlurNotificationKey, object: nil)

          
            }
            else {
               //Iff authentication failed then show a message to the console with a short discription.
               //In case that the error is a user fallback, then show the password alert view.
               
               switch evalPolicyError!.code {
               case LAError.SystemCancel.rawValue:
                  println("Authentication was cancelled by the system")
                  break
               case LAError.UserCancel.rawValue:
                  println("Authentication was cancelled by the user")
                  break
               case LAError.UserFallback.rawValue:
                  println("User selected to enter custom password")
                  NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                     self.showPasswordAlert()
                  })
                  break
               default:
                  println("Authentication failed")
                  NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                     self.showPasswordAlert()
                  })
                  break
               }
         
            }
         })]
      }
      else {
         //If the security policy cannot be evaluated then show a short message depending on the error.
         switch error!.code {
         case LAError.TouchIDNotAvailable.rawValue:
            println("TouchID is not enrolled")
            break
         case LAError.PasscodeNotSet.rawValue:
            println("A Passcode has not been set")
            break
         default:
            //The LAError.TouchIDNotAvalable Case.
            println("TouchID not available")
            break
         }
         
         //Opptionally the error description can be displayed on the console.
         println(error?.localizedDescription)
         
         //Show the custom alert view to allow users to enter the password.
         self.showPasswordAlert()
      }
   }
   
   func showPasswordAlert() {


   }
   
//   func getTopViewController() -> UIViewController {
//      var topVC = UIApplication.sharedApplication().keyWindow?.rootViewController
//      while (topVC?.presentedViewController != nil) {
//         topVC = topVC?.presentedViewController
//      }
//      return topVC!
//   }
   
   
}
