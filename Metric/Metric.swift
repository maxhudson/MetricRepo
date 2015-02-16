//
//  Metric.swift
//  Metric
//
//  Created by Max Hudson on 1/31/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import UIKit
//import CoreData

class Feeling: NSObject, NSCoding {
   let valueKey = "valueKey"
   let noteKey = "noteKey"
   let dateKey = "dateKey"
   
   var value: Int!
   var note: String!
   var date: NSDate!
   
   init(value: Int, note: String, date: NSDate){
      super.init()
      self.value = value
      self.note = note
      self.date = date
   }
   
   func encodeWithCoder(aCoder: NSCoder) {
      aCoder.encodeObject(value, forKey: valueKey)
      aCoder.encodeObject(note, forKey: noteKey)
      aCoder.encodeObject(date, forKey: dateKey)
   }
   
   required init(coder aDecoder: NSCoder) {
      value = aDecoder.decodeObjectForKey(valueKey) as Int
      if let theNote = aDecoder.decodeObjectForKey(noteKey) as? String {
         note = theNote
      }
      date = aDecoder.decodeObjectForKey(dateKey) as? NSDate
   }

}

class Metric: NSObject, NSCoding {
   
   let titleKey = "titleKey"
   let goodCountKey = "goodCountKey"
   let badCountKey = "badCountKey"
   let feelingsKey = "feelingsKey"
   let lastUpdatedKey = "lastUpdatedKey"
   let lastFeelingKey = "lastFeelingKey"
   
   var title : String = ""
   var good: UInt = 0
   var bad: UInt = 0
   var feelings: [Feeling] = []
   var lastUpdated: NSDate = NSDate()
   var lastFeeling: Feeling?
   var delayReference: dispatch_cancelable_closure?
   
   init(title: String){
      self.title = title
   }
   
   init(title: String, good: UInt, bad: UInt, feelings: [Feeling]) {
      self.title = title
      self.good = good
      self.bad = bad
      self.feelings = feelings
   }
   
   func feelGood(note: String) -> Feeling{
      good++;
      var feeling = Feeling(value: 1, note: note, date: NSDate())
      feelings.append(feeling)
      return feeling
   }
   
   func feelBad(note: String) -> Feeling{
      bad++;
      var feeling = Feeling(value: -1, note: note, date: NSDate())
      feelings.append(feeling)
      return feeling
   }
   
   func encodeWithCoder(aCoder: NSCoder) {
      aCoder.encodeObject(title, forKey: titleKey)
      aCoder.encodeObject(good, forKey: goodCountKey)
      aCoder.encodeObject(bad, forKey: badCountKey)
      let theFeelings: [Feeling] = feelings
      if theFeelings.count != 0{
         aCoder.encodeObject(feelings, forKey: feelingsKey)
      }
      aCoder.encodeObject(lastUpdated, forKey: lastUpdatedKey)
      aCoder.encodeObject(lastFeeling, forKey: lastFeelingKey)
      
   }
   
   required init(coder aDecoder: NSCoder) {
      title = aDecoder.decodeObjectForKey(titleKey) as String
      good = aDecoder.decodeObjectForKey(goodCountKey) as UInt
      bad = aDecoder.decodeObjectForKey(badCountKey) as UInt
      if let theFeelings = aDecoder.decodeObjectForKey(feelingsKey) as? [Feeling] {
         feelings = theFeelings
      }
      lastUpdated = aDecoder.decodeObjectForKey(lastUpdatedKey) as NSDate
      lastFeeling = aDecoder.decodeObjectForKey(lastFeelingKey) as? Feeling
   
   }
}
