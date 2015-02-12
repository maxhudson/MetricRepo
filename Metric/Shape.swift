//
//  Shape.swift
//  Metric
//
//  Created by Chance Daniel on 2/11/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import UIKit

class Shape: NSObject {
   var circleDiameter = CGFloat()
   var center = CGPoint()
   var shape: String!
   var width: CGFloat!
   var height: CGFloat!
   
   
   init(circleDiameter: CGFloat, center: CGPoint) {
      self.circleDiameter = circleDiameter
      self.center = center
      self.shape = "circle"
   }
   
   init(width: CGFloat, height: CGFloat, center: CGPoint) {
      self.width = width
      self.height = height
      self.center = center
      self.shape = "rectangle"
   }
   
   func size() -> CGSize{
      var size = CGSize()
      if shape == "circle"{
         size = CGSizeMake(circleDiameter, circleDiameter)
      }
      if shape == "rectangle" {
         size = CGSizeMake(width, height)
      }
      return size
   }

}
