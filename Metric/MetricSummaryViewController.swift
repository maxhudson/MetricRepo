//
//  MetricSummaryViewController.swift
//  Metric
//
//  Created by Max Hudson on 2/1/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import UIKit

class MetricSummaryViewController: UIViewController{
   
   @IBOutlet weak var badButton: UIButton!
   @IBOutlet weak var badButtonWidthConstraint: NSLayoutConstraint!
   @IBOutlet weak var goodButton: UIButton!
   @IBOutlet weak var goodButtonWidthConstraint: NSLayoutConstraint!
   
   @IBOutlet weak var backButton: UIButton!
   
   @IBOutlet weak var analysisLabel: UILabel!
   
   @IBOutlet weak var scrollView: UIScrollView!
   @IBOutlet weak var navBar: UINavigationBar!
   @IBOutlet weak var graph: UIImageView!
   
   override func viewDidLoad() {
      //navigation bar
      navBar.topItem?.title = currentMetric.title
      Helper.styleNavButton(backButton, fontName: Helper.buttonFont, fontSize: 25)
      
      //scrollview
      //scrollView.directionalLockEnabled = true;
      
      //text
      analysisLabel.text = "It looks like " + currentMetric.title + " has been making a fairly positive impact on your life recently. We can say with a fair bit of confidence that you should keep " + currentMetric.title + " in your life, at least for now."
      analysisLabel.font = UIFont(name: Helper.bodyTextFont, size: 15)
      
      //graph
      graph.image = getImageForMetric(currentMetric)
      
      //notes
      buildNotes()
      
      //bottom bars
      var minWidth : CGFloat = 40
      var screenWidth = self.view.frame.size.width - minWidth*2
      var totalMet = currentMetric.bad + currentMetric.good
      var unit = screenWidth/CGFloat(totalMet)
      
      badButtonWidthConstraint.constant = minWidth + CGFloat(currentMetric.bad)*unit - 1
      
      Helper.styleColoredButton(badButton, color: Helper.badColor, title: Helper.formatStringNumber(-1*Int(currentMetric.bad)), fontSize: 20)
      
      goodButtonWidthConstraint.constant = minWidth + screenWidth - CGFloat(currentMetric.bad)*unit - 1
      
      Helper.styleColoredButton(goodButton, color: Helper.goodColor, title: Helper.formatStringNumber(Int(currentMetric.good)), fontSize: 20)
      
   }
   
   func getImageForMetric(met : Metric) -> UIImage{
      
      let scale = UIScreen.mainScreen().scale
      
      var graphSize = CGSize(width: graph.frame.size.width*scale, height: graph.frame.size.height*scale)
      
      let origin = CGPoint(x: 30*scale, y: 80*scale)
      
      var maxVal : UInt = 0;
      
      UIGraphicsBeginImageContext(graphSize)
      var context = UIGraphicsGetCurrentContext();
      
      //pulled data
      var backwardYValues : [Int] = [
         3, 4, 4, 5, 4, 2, 1, -1, -2, -1, -3, -1, 1, 3, 4, 3, 2, 4, 5, 5, 4, 1, -1, -3, -2
      ]
      
      if (backwardYValues.count > 0) {
         var yValues : [Int] = []
         
         //correct data
         
         for (var i=0; i<backwardYValues.count; i++) {
            yValues.append(backwardYValues[backwardYValues.count - 1 - i])
         }
         
         //break array up into sections
         var yValueIndex = 0
         var sign = 1
         if (yValues[0] < 0){
            sign = -1
         } else if (yValues[0] == 0){
            sign = 0
         }
         
         var signs : [Int] = []
         var valueSets : [[Int]] = []
         
         while (yValueIndex < yValues.count) {
            
            var valueSet : [Int] = []
            var i = 0;
            var done = false;
            
            signs.append(sign)
            
            while (yValueIndex < yValues.count && !done){
               var value = yValues[yValueIndex]
               
               if (sign == 1 && value < 0 || sign == -1 && value > 0 || sign == 0 && value != 0){
                  done = true
               }else {
                  yValueIndex++
                  valueSet.append(value)
               }
               
               if (value < 0){
                  sign = -1
               } else if (value > 0) {
                  sign = 1
               } else {
                  sign = 0
               }
            }
            
            valueSets.append(valueSet)
            
         }
         
         
         
         //graph calculations
         
         for (var i=0; i<yValues.count; i++){
            if (UInt(abs(yValues[i])) > maxVal){
               maxVal = UInt(abs(yValues[i]))
            }
         }
         
         maxVal = (maxVal + 4) / 5 * 5;
         
         
         
         //draw path
         var yUnit = 20*scale/CGFloat(maxVal)
         var xUnit = 5.1
         
         var drawX = origin.x + 10*scale
         
         for (var i = 0; i < signs.count; i++) {
            
            var sign = signs[i]
            var valueSet = valueSets[i]
            
            var path = CGPathCreateMutable()
            var pathColor = Helper.goodColor.CGColor
            if (sign < 0){
               pathColor = Helper.badColor.CGColor
            }
            
            CGPathMoveToPoint(path, nil, drawX, origin.y)
            drawX += 10*scale
            
            for (var x = 0; x < valueSet.count; x++){
               CGPathAddLineToPoint(path, nil, drawX, origin.y - CGFloat(valueSet[x])*yUnit*scale)
               
               if (x < valueSet.count - 1) {
                  drawX += CGFloat(xUnit)*scale
               }
            }
            
            drawX += 10*scale
            CGPathAddLineToPoint(path, nil, drawX, origin.y)
            
            CGPathCloseSubpath(path)
            CGContextAddPath(context, path)
            CGContextSetFillColorWithColor(context, pathColor)
            CGContextFillPath(context)
         }
      }
      
      //draw bar
      
      let barColor = UIColor(red: 77/255.0, green: 77/255.0, blue: 77/255.0, alpha: 1).CGColor
      
      CGContextSetFillColorWithColor(context, barColor);
      CGContextFillRect(context, CGRect(x: origin.x, y: origin.y, width: graphSize.width - origin.x*1.5, height: 2*scale));
      
      
      //draw numbers
      
      CGContextTranslateCTM(context, 0.0, graphSize.height/scale)
      CGContextScaleCTM(context, 1.0, -1.0)
      
      println(origin)
      drawText(
         "+" + String(maxVal),
         position: CGPoint(x: origin.x - 20*scale, y: graphSize.height/scale - origin.y + 35*scale),
         context: context, scale: scale)
      
      drawText(
         "-" + String(maxVal),
         position: CGPoint(x: origin.x - 20*scale, y: graphSize.height/scale - origin.y - 45*scale),
         context: context, scale: scale)
      
      drawText(
         "0",
         position: CGPoint(x: origin.x - 20*scale, y: graphSize.height/scale - origin.y - 5*scale),
         context: context, scale: scale)
      
      //test
      
      var image =  UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
      
      return image
   }
   
   func drawText(text: String, position: CGPoint, context: CGContextRef, scale: CGFloat){
      let path = CGPathCreateMutable()
      
      let aFont = UIFont(name: "Quicksand-Bold", size: 12*scale)
      let attr:CFDictionaryRef = [NSFontAttributeName:aFont!,NSForegroundColorAttributeName:UIColor(white: 0.5, alpha: 1)]
      let text = CFAttributedStringCreate(nil, text, attr)
      let line = CTLineCreateWithAttributedString(text)
      let bounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.UseOpticalBounds)
      CGContextSetLineWidth(context, 1.5)
      CGContextSetTextDrawingMode(context, kCGTextFill)
      CGContextSetTextPosition(context, position.x, position.y)
      CTLineDraw(line, context)
   }
   
   func buildNotes() {
      /*let notes = ["note1", "note2", "note3"]
      
      var noteBodyLabel = UILabel(frame: CGRect(x: 10, y: 200, width: 100, height: 100))
      noteBodyLabel.text = "test asdf  asd fasdf a sdf asdf as dfa sdf  safd"
      noteBodyLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
      
     /* var widthCons = NSLayoutConstraint(
         item: noteBodyLabel,
         attribute: .Width,
         relatedBy: .Equal,
         toItem: nil,
         attribute: .NotAnAttribute,
         multiplier: 1, constant: 100)
      
      noteBodyLabel.addConstraint(widthCons)*/
      
      
      
     /* let topCons = NSLayoutConstraint(
         item: noteBodyLabel,
         attribute: .Top,
         relatedBy: .Equal,
         toItem: graph,
         attribute: .Bottom,
         multiplier: 1, constant: 0);
      
      noteBodyLabel.addConstraint(topCons);*/
      
      scrollView.addSubview(noteBodyLabel)
      
      var label = UILabel(frame: CGRectMake(0, 0, 200, 21))
      label.center = CGPointMake(160, 384)
      label.textAlignment = NSTextAlignment.Center
      label.text = "I'am a test label"
      scrollView.addSubview(label)*/
   }
}