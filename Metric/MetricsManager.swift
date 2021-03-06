//
//  MetricsManager.swift
//  Metric
//
//  Created by Chance Daniel on 2/3/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import Foundation

class MetricsManager {
   var tutorialCompleted: Bool!
   var tutorialMetrics = [Metric]()
   
   var metrics = [Metric]()
   
   let defaults = NSUserDefaults.standardUserDefaults()
   
   lazy private var archivePath: String = {
      let fileManager = NSFileManager.defaultManager()
      let documentsDirecotryURLs = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
      let archiveURL = documentsDirecotryURLs.first!.URLByAppendingPathComponent("MetricItems", isDirectory: false)
      return archiveURL.path!
   }()
   
   func save() {
      NSKeyedArchiver.archiveRootObject(metrics, toFile: archivePath)
      defaults.setBool(tutorialCompleted, forKey: "tutorialCompleted")

   }
   
   private func unarchiveSavedItems() {
      if NSFileManager.defaultManager().fileExistsAtPath(archivePath) {
         let savedItems: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithFile(archivePath)
         metrics = savedItems as [Metric]
      }
      if defaults.boolForKey("tutorialCompleted"){
         tutorialCompleted = defaults.boolForKey("tutorialCompleted")
         println("Tutorial Key Set Already")
      }
      else {
         tutorialCompleted = false
      }
      
   }
   
   
   init() {
      unarchiveSavedItems()
   }
   
   
}


