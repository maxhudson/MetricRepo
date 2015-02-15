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
      let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)

      label.textColor = UIColor.whiteColor()
      label.font = UIFont(name: Helper.lightButtonFont, size: 30)
      label.center = viewToAddTo.center
      label.textAlignment = .Center
      label.tag = 1
   
      var frames : [UIView] = []
      var shapes : [String] = []

      for circle:Shape in circles {
         let blurView = UIVisualEffectView(effect: blurEffect)
         blurView.frame.size = circle.size()
         blurView.center = circle.center
         frames.append(blurView as UIView)
         shapes.append(circle.shape)
      }
      
      for rectangle:Shape in rectangles {
         let blurView = UIVisualEffectView(effect: blurEffect)
         blurView.frame.size = rectangle.size()
         blurView.center = rectangle.center
         frames.append(blurView as UIView)
         shapes.append(rectangle.shape)
      }
      
      self.addMaskInViews(frames, shapeNames:shapes)
   }

   func addMaskInViews(viewsToCutOut: [UIView], shapeNames: [String]){
      var rects : [CGRect] = []
      for view in viewsToCutOut {
         (view as UIView).hidden = true
         rects.append(view.frame)
      }
      
      let overlay = BlackOutView(frame: self.viewToAddTo.frame)
      overlay.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
      overlay.shapes = shapeNames
      overlay.framesToCutOut = rects
      overlay.tag = 1
      overlay.userInteractionEnabled = false
      label.userInteractionEnabled = false
      viewToAddTo.addSubview(overlay)
      viewToAddTo.addSubview(label)
   }
}
