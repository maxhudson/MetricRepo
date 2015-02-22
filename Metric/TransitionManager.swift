//
//  TransitionManager.swift
//  Metric
//
//  Created by Chance Daniel on 2/21/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import UIkit


class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
   var animationName = String()
   var presenting = true

   
   // MARK: UIViewConrollerAnimatedTransitioning protocol methods
   
   // animate a change from one viewcontroller to another
   func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
      switch animationName {
      case "slideLeft":
      
         // get reference to fromView, toView, and the container view that we should perform the transition in
         let container = transitionContext.containerView()
         let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
         let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
         
         // Setup 2D animation transforms
         let offScreenRight = CGAffineTransformMakeTranslation(container.frame.width, 0)
         let offScreenLeft = CGAffineTransformMakeTranslation(-container.frame.width, 0)
         
         // Start the toView to the right of the screen
         if presenting == true {
            toView.transform = offScreenRight
         }
         else {
            toView.transform = offScreenLeft
         }
         
         // add both views to the current view controller
         container.addSubview(toView)
         container.addSubview(fromView)
         
         // get the duration of the animation
         let duration = self.transitionDuration(transitionContext)
         
         // peform the animation
         UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: nil, animations: { () -> Void in
            if self.presenting == true {
               fromView.transform = offScreenLeft
            }
            else {
               fromView.transform = offScreenRight
            }
            toView.transform = CGAffineTransformIdentity

         
         }, completion: { (finished) -> Void in
            if finished {
               transitionContext.completeTransition(true)
            }
         })
     
         
         break
      default:
         break
         
      }
      
      
      
   }
   
   // return how many seconds the transition animation will take
   func transitionDuration(tranistionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
      return 0.5
   }
   
   // MARK: UIViewControllerTransitionDelegate protocol methods
   
   // return the animator when presenting a viewcontroller
   // NOTE: an animator is any obejct that adheres to the UIViewControllerAnimatedTranstion protocol 
   func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      self.presenting = true
      return self
   }
   
   // return the animator used when dismissing from a viewcontroller
   func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      presenting = false
      return self
   }
   

   
   
}
