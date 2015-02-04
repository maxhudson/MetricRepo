//
//  Metric.swift
//  Metric
//
//  Created by Max Hudson on 1/31/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import UIKit
import CoreData

class Feeling: NSObject, NSCoding {
   let ValueKey = "valueKey"
   let NoteKey = "noteKey"
   let DateKey = "dateKey"
   
   var value: Int = 0
   var note: String = ""
   var date: NSDate!
   init(value: Int, note: String, date: NSDate){
      super.init()
      self.value = value
      self.note = note
      self.date = date
   }
   
   func encodeWithCoder(aCoder: NSCoder) {
      aCoder.encodeObject(value, forKey: ValueKey)
      aCoder.encodeObject(note, forKey: NoteKey)
      aCoder.encodeObject(date, forKey: DateKey)
   }
   
   required init(coder aDecoder: NSCoder) {
      value = aDecoder.decodeObjectForKey(ValueKey) as Int
      if let theNote = aDecoder.decodeObjectForKey(NoteKey) as? String {
         note = theNote
      }
      date = aDecoder.decodeObjectForKey(DateKey) as? NSDate
   }

}

class Metric: NSObject, NSCoding {
   
   let TitleKey = "titleKey"
   let GoodCountKey = "goodCountKey"
   let BadCountKey = "badCountKey"
   let FeelingsKey = "feelingsKey"
   let LastUpdatedKey = "lastUpdatedKey"
   
   var title : String = ""
   var good: UInt = 0
   var bad: UInt = 0
   var feelings: [Feeling] = []
   var lastUpdated: NSDate = NSDate()
   
   init(title: String){
      self.title = title
   }
   
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
   
   func encodeWithCoder(aCoder: NSCoder) {
      aCoder.encodeObject(title, forKey: TitleKey)
      aCoder.encodeObject(good, forKey: GoodCountKey)
      aCoder.encodeObject(bad, forKey: BadCountKey)
      let theFeelings: [Feeling] = feelings
      if theFeelings.count != 0{
         aCoder.encodeObject(feelings, forKey: FeelingsKey)
      }
      aCoder.encodeObject(lastUpdated, forKey: LastUpdatedKey)
      
   }
   
   required init(coder aDecoder: NSCoder) {
      title = aDecoder.decodeObjectForKey(TitleKey) as String
      good = aDecoder.decodeObjectForKey(GoodCountKey) as UInt
      bad = aDecoder.decodeObjectForKey(BadCountKey) as UInt
      if let theFeelings = aDecoder.decodeObjectForKey(FeelingsKey) as? [Feeling] {
         feelings = theFeelings
      }
      lastUpdated = aDecoder.decodeObjectForKey(LastUpdatedKey) as NSDate
   
   }
   
   
   
   
   
   
   
   
}
