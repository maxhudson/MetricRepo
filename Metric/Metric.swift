//
//  Metric.swift
//  Metric
//
//  Created by Max Hudson on 1/31/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import UIKit
import CoreData

struct Feeling {
   var value: Int
   var note: String
   var date: NSDate
}

class Metric {
   
   var title : String = ""
   var good: UInt = 0
   var bad: UInt = 0
   var feelings: [Feeling] = []
   var lastUpdated: NSDate = NSDate()
   
   init(title: String, good: UInt, bad: UInt, feelings: [Feeling]) {
      self.title = title
      self.good = good
      self.bad = bad
      self.feelings = feelings
   }
   
   func feelGood(note: String){
      good++;
      feelings.append(Feeling(value: 1, note: note, date: NSDate()))
   }
   
   func feelBad(note: String){
      bad++;
      feelings.append(Feeling(value: -1, note: note, date: NSDate()))
   }
}
