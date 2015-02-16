//
//  MetricsManager.swift
//  Metric
//
//  Created by Chance Daniel on 2/3/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import Foundation

class MetricsManager {
   var sampleDataAdded: Bool!
   var tutorialCompleted: Bool!
   var tutorialMetrics = [Metric]()
   
   var metrics = [Metric]()
   var password = [Int?](count: 4, repeatedValue: nil)
   let defaults = NSUserDefaults.standardUserDefaults()
   
   lazy private var archivePath: String = {
      let fileManager = NSFileManager.defaultManager()
      let documentsDirecotryURLs = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
      let archiveURL = documentsDirecotryURLs.first!.URLByAppendingPathComponent("MetricItems", isDirectory: false)
      return archiveURL.path!
   }()
   
   lazy private var passwordArchivePath: String = {
      let fileManager = NSFileManager.defaultManager()
      let documentsDirecotryURLs = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
      let archiveURL = documentsDirecotryURLs.first!.URLByAppendingPathComponent("PasswordItem", isDirectory: false)
      return archiveURL.path!
   }()
   
   func save() {
      NSKeyedArchiver.archiveRootObject(metrics, toFile: archivePath)
      var passwordToSave = [Int]()
      var i = 0
      for key in password {
         if key != nil {
            passwordToSave.append(key!)
         }
      }
      NSKeyedArchiver.archiveRootObject(passwordToSave, toFile: passwordArchivePath)
      defaults.setBool(tutorialCompleted, forKey: "tutorialCompleted")
      defaults.setBool(sampleDataAdded, forKey: "sampleDataAdded")

   }
   
   private func unarchiveSavedItems() {
      if NSFileManager.defaultManager().fileExistsAtPath(archivePath) {
         let savedItems: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithFile(archivePath)
         metrics = savedItems as [Metric]
      }
      
      if NSFileManager.defaultManager().fileExistsAtPath(passwordArchivePath) {
         let savedPassword: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithFile(passwordArchivePath)
         if let thePass: [Int] = savedPassword as? [Int] {
            var i = 0
            for key in thePass {
               password[i++] = key
            }
         }
      }
      
      if defaults.boolForKey("tutorialCompleted"){
         tutorialCompleted = defaults.boolForKey("tutorialCompleted")
      } else {
         tutorialCompleted = false
      }
      
      if defaults.boolForKey("sampleDataAdded"){
         sampleDataAdded = defaults.boolForKey("sampleDataAdded")
      } else {
         sampleDataAdded = false
      }
   }
   
   
   init() {
      unarchiveSavedItems()
   }
   
   
}


