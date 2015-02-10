//
//  CustomSlideSegue.swift
//  Metric
//
//  Created by Chance Daniel on 2/8/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import Foundation
import UIKit

class CustomSlideSegue: UIStoryboardSegue {
   var shouldUnwind: Bool!
   var start = CGRect()
//   var end = CGPoint()
   let screenWidth = UIScreen.mainScreen().bounds.size.width
   let screenHeight = UIScreen.mainScreen().bounds.size.height
   var source: UIViewController!
   var destination: UIViewController!
   override init(identifier: String!, source: UIViewController, destination: UIViewController) {
      super.init(identifier: identifier, source: source, destination: destination)
//      self.source = source as UIViewController
//      self.destination = destination as UIViewController
   }
   init(identifier: String!, source: UIViewController, destination: UIViewController, shouldUnwind: Bool) {
      super.init(identifier: identifier, source: source, destination: destination)
//      self.source = source as UIViewController
//      self.destination = destination as UIViewController
      self.shouldUnwind = shouldUnwind
   }

   override func perform() {
      if shouldUnwind == nil {
         shouldUnwind = false
      }
      
      if !shouldUnwind {
         start = CGRectMake(screenWidth, 0.0, screenWidth, screenHeight)
//         end = CGRectOffset(firstVCView.frame, 0.0, -screenHeight)
      }
      else {
         start = CGRectMake(-screenWidth, 0.0, screenWidth, screenHeight)
//         end = CGPointMake(0.5*screenSize.width, screenSize.height/2)

      }
   
//      var sourceViewController: UIViewController = self.sourceViewController as UIViewController
//      var destinationViewController: UIViewController = self.destinationViewController as UIViewController
      var firstVCView: UIViewController = self.sourceViewController as UIViewController
      var secondVCView: UIViewController = self.destinationViewController as UIViewController
      
    
      
      
      
//      let window = UIApplication.sharedApplication().keyWindow
//      window?.insertSubview(secondVCView.view, aboveSubview: firstVCView.view)
//      secondVCView.view.frame = source.view.frame

//      secondVCView.view.bounds = firstVCView.view.bounds
      let window = UIApplication.sharedApplication().keyWindow
      window?.addSubview(secondVCView.view)
      
//      firstVCView.view.addSubview(secondVCView.view)
      secondVCView.view.frame = firstVCView.view.window!.frame

      secondVCView.view.bounds = firstVCView.view.bounds
      

      secondVCView.view.frame = start
      
      
      UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
         if !self.shouldUnwind {
            firstVCView.view.frame = CGRectOffset(firstVCView.view.frame, -self.screenWidth, 0.0)
            secondVCView.view.frame = CGRectOffset(secondVCView.view.frame, -self.screenWidth, 0.0)
         }
         else {
            firstVCView.view.frame = CGRectOffset(firstVCView.view.frame, self.screenWidth, 0.0)
            secondVCView.view.frame = CGRectOffset(secondVCView.view.frame, self.screenWidth, 0.0)
         }
         
      }) { (finished) -> Void in

         if(finished == true){
         
            if self.shouldUnwind == true {
               self.sourceViewController.dismissViewControllerAnimated(false, completion: nil)
            }
            else {
               self.sourceViewController.presentViewController(secondVCView as UIViewController!, animated: false, completion: nil)
            }
         }
      }
   }
   
}