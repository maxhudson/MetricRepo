//
//  Helper.swift
//  Metric
//
//  Created by Max Hudson on 2/1/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import UIKit

typealias dispatch_cancelable_closure = (cancel : Bool) -> ()

struct Helper {
   
   static var goodColor = UIColor(red: 65/255.0, green: 195/255.0, blue: 222/255.0, alpha: 1)
   static var darkGoodColor = UIColor(red: 58/255.0, green: 174/255.0, blue: 199/255.0, alpha: 1)
   static var badColor = UIColor(red: 234/255.0, green: 136/255.0, blue: 137/255.0, alpha: 1)
   static var darkBadColor = UIColor(red: 209/255.0, green: 117/255.0, blue: 118/255.0, alpha: 1)
   static var darkNavyColor = UIColor(red: 53/255.0, green: 73/255.0, blue: 93/255.0, alpha: 1)
   static var goldColor = UIColor(red: 241/255.0, green: 199/255.0, blue: 83/255.0, alpha: 1)
   static var purpleColor = UIColor(red: 188/255.0, green: 141/255.0, blue: 190/255.0, alpha: 1)
   
   static var coloredButtonTextColor = UIColor.whiteColor()
   static var navBarColor = UIColor(white: 0.3, alpha: 1)
   
   static var navTitleFont = "AvenirNext-Medium"
   static var bodyTextFont = "AvenirNext-Medium"
   static var lightButtonFont = "Quicksand-Regular"
   static var buttonFont = "Quicksand-Bold"
   
   static var graphFont = UIFont(name: "Quicksand-Bold", size: 10)
   
   static func netMetric(met: Metric) -> Int {
      return met.good - met.bad
   }
   
   static func netFeelings(feelings: [Feeling]) -> Int {
      var net = 0
      
      for feeling in feelings {
         net += feeling.value
      }
      
      return net
   }
   
   static func delay(delay:Double, closure:()->()) {
      dispatch_after(
         dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
         ),
         dispatch_get_main_queue(), closure)
   }
   
   static func cancellableDelay(time:NSTimeInterval, closure:()->()) ->  dispatch_cancelable_closure? {
      
      func dispatch_later(clsr:()->()) {
         dispatch_after(
            dispatch_time(
               DISPATCH_TIME_NOW,
               Int64(time * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), clsr)
      }
      
      var closure:dispatch_block_t? = closure
      var cancelableClosure:dispatch_cancelable_closure?
      
      let delayedClosure:dispatch_cancelable_closure = { cancel in
         if let clsr = closure {
            if (cancel == false) {
               dispatch_async(dispatch_get_main_queue(), clsr);
            }
         }
         closure = nil
         cancelableClosure = nil
      }
      
      cancelableClosure = delayedClosure
      
      dispatch_later {
         if let delayedClosure = cancelableClosure {
            delayedClosure(cancel: false)
         }
      }
      
      return cancelableClosure;
   }
   
   static func cancelDelay(closure:dispatch_cancelable_closure?) {
      if closure != nil {
         closure!(cancel: true)
      }
   }
   
   static func formatStringNumber(number : Int) -> String{
      var output = String(number)
      if (number > 0){
         output = "+" + output
      }
      return output
   }
   
   static func styleNavButton(button: UIButton, fontName: String, fontSize: CGFloat){
      button.titleLabel!.font = UIFont(name: fontName, size: fontSize)
      button.setTitleColor(Helper.navBarColor, forState: .Normal)
   }
   
   static func styleColoredButton(button: UIButton, color: UIColor, title: String, fontSize: CGFloat){
      button.backgroundColor = color
      button.setTitleColor(Helper.coloredButtonTextColor, forState: .Normal)
      button.setTitle(title, forState: .Normal)
      button.titleLabel!.font = UIFont(name: Helper.buttonFont, size: fontSize)
   }
   
   static func colorForFeeling(feeling : Int) -> UIColor {
      if (feeling == 1) {
         return goodColor
      } else if (feeling == 0) {
         return UIColor(white: 0.9, alpha: 1)
      }
      
      return badColor
   }
   
   static func generateRandomData(days: Int, values: Int, lowRange: Int, hiRange: Int, met: Metric) {
      var date = NSDate()
      date = date.dateByAddingTimeInterval(Double(-1*60*60*24*days))
      var val :CGFloat = 0
      for (var i = 0; i < days; i++) {
         
         val = CGFloat(i % 2)
         
         met.feelings.append(Feeling(value: Int(val), note: "", date: date))
         
            date = date.dateByAddingTimeInterval(Double(60*60*24))
         
      }
   }
}