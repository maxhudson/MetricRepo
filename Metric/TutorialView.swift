//
//  TutorialView.swift
//  Metric
//
//  Created by Chance Daniel on 2/11/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import UIKit

class TutorialView {
   var viewToAddTo = UIView()
   var label = UILabel()
   var button: UIButton!
   var circles: [Shape]!
   var rectangles: [Shape]!
   

   
   init(circles:[Shape], rectangles:[Shape], viewToAddTo: UIView, label: UILabel) {
      self.viewToAddTo = viewToAddTo
      self.circles = circles
      self.rectangles = rectangles
      self.label = label
      
   }

   
   func createTutorialView(){
     
      //Make Button
      
      
      
      //BLUR STUFF
//      let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
//      let blurView = UIVisualEffectView(effect: blurEffect)
      
      //Label Stuff
      label.textColor = UIColor.whiteColor()
      label.font = UIFont(name: Helper.lightButtonFont, size: 30)
      label.center = viewToAddTo.center
      label.textAlignment = .Center
      label.tag = 1
      
      
//      viewToAddTo.addSubview(blurView)
   
      var frames = NSMutableArray()
      var shapes = [String]()
      for circle:Shape in circles {
//         let blurView = UIVisualEffectView(effect: blurEffect)
         let blurView = UIView()
         blurView.frame.size = circle.size()
         blurView.center = circle.center
         frames.addObject(blurView as UIView)
         shapes.append(circle.shape)
      }
      for rectangle:Shape in rectangles {
//         let blurView = UIVisualEffectView(effect: blurEffect)
         let blurView = UIView()
         blurView.frame.size = rectangle.size()
         blurView.center = rectangle.center
         frames.addObject(blurView as UIView)
         shapes.append(rectangle.shape)
      }
      
      self.addMaskInViews(frames, shapeNames:shapes)
   }



   func addMaskInViews(viewsToCutOut: NSMutableArray, shapeNames: [String]){
      let frames = NSMutableArray()
      for view in viewsToCutOut {
         (view as UIView).hidden = true
         frames.addObject(NSValue(CGRect: view.frame))
      }
      
      let overlay = BlackOutView(frame: self.viewToAddTo.frame)
      overlay.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
      if shapeNames != []{
         overlay.shapes = shapeNames
      }
      overlay.framesToCutOut = frames
      overlay.tag = 1
      overlay.userInteractionEnabled = false
      label.userInteractionEnabled = false
      viewToAddTo.addSubview(overlay)
      viewToAddTo.addSubview(label)
     

   }

}
