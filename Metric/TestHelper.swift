//
//  TestHelper.swift
//  Metric
//
//  Created by Max Hudson on 2/12/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import UIKit

struct TestHelper {
   
   
   static func generateRandomData(days: Int, values: Int, lowRange: Int, hiRange: Int, met: Metric) {
      met.feelings = []
      met.good = 0
      met.bad = 0
      
      var date = NSDate()
      date = date.dateByAddingTimeInterval(Double(-1*60*60*24*days))
      var val :CGFloat = 0
      var dec :CGFloat = 0
      
      for (var i = 0; i < days; i++) {
         
         if(CGFloat(i) < 0.75*CGFloat(days) ){
            val = CGFloat(random() % 6)
         }else {
            dec -= 0.4
            val = dec
         }
         
         if (Int(val) < 0){
            met.bad += abs(Int(val))
         }else{
            met.good += abs(Int(val))
         }
         
         met.feelings.append(Feeling(value: Int(val), note: "This is a comment for note " + String(i), date: date))
         
         date = date.dateByAddingTimeInterval(Double(60*60*24))
         
      }
   }
}