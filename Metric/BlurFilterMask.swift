//
//  BlurFilterMask.swift
//  Metric
//
//  Created by Chance Daniel on 2/11/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import UIKit

class BlurFilterMask: CAShapeLayer {
   var orgin = CGPoint()
   var diameter = CGFloat()
   var gradientFloat = CGFloat()
   
   override func drawInContext(ctx: CGContext!) {
      let gradientWidth =  0.5 * self.diameter
      let clearRegionRadius = 0.25 * self.diameter
      let blurRegionRadius = clearRegionRadius + gradientWidth
      
      let baseColorSpace = CGColorSpaceCreateDeviceRGB()
      let colors: [CGFloat] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, self.gradientFloat]
      let colorLocations: [CGFloat] = [0.0, 0.4]
      let gradient = CGGradientCreateWithColorComponents(baseColorSpace, colors, colorLocations, 2)
      
      
   }
}
