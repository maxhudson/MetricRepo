//
//  BlackOutView.swift
//  Metric
//
//  Created by Chance Daniel on 2/11/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import UIKit

class BlackOutView: UIView {
   
   var fillColor = UIColor()
   var framesToCutOut = NSArray()
   var shapes = [String]()
   var shape: String?
   
//   init(frame: CGRect, shape: String) {
//      super.init(frame: frame)
////      self.shape = shape
//   }
   
//   required init(coder aDecoder: NSCoder) {
//      fatalError("This class does not support NSCoding")
//   }
   
   override func drawRect(rect: CGRect) {
      let context = UIGraphicsGetCurrentContext()
      CGContextSetBlendMode(context, kCGBlendModeDestinationOut)
      println(shapes)
      var i = 0
      for value in self.framesToCutOut {
         shape = shapes[i++]
         let pathRect = value.CGRectValue()
         var path = UIBezierPath()
         if shape == "rectangle" {
             path = UIBezierPath(rect: pathRect)
         }
         if shape == "circle" {
             path = UIBezierPath(ovalInRect: pathRect)
         }
         path.fill()
      }
      CGContextSetBlendMode(context, kCGBlendModeNormal)
   }

   
   
}
