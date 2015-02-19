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
   var framesToCutOut = [CGRect]()
   var shapes = [String]()
   var shape: String?
   
   override func drawRect(rect: CGRect) {
      let context = UIGraphicsGetCurrentContext()
      CGContextSetBlendMode(context, kCGBlendModeDestinationOut)
      println(shapes)
      var i = 0
      for pathRect in self.framesToCutOut {
         shape = shapes[i++]
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
