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
   
   @IBOutlet weak var editButton: UIButton!
   
   @IBOutlet weak var analysisLabel: UILabel!
   
   @IBOutlet weak var scrollView: UIScrollView!
   @IBOutlet weak var navBar: UINavigationBar!
   @IBOutlet weak var graph: UIImageView!
   
   
   @IBAction func backButtonPress(sender: AnyObject) {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let vc = storyboard.instantiateViewControllerWithIdentifier("MainList") as MainListViewController
      self.presentViewController(vc, animated: false, completion: nil)
   }
   
   @IBAction func editButtonPress(sender: AnyObject) {
      manageMetricMode = "edit"
   }
   
   
   override func viewDidLoad() {
      //navigation bar
      navBar.topItem?.title = currentMetric.title
      Helper.styleNavButton(backButton, fontName: Helper.buttonFont, fontSize: 25)
      Helper.styleNavButton(editButton, fontName: Helper.navTitleFont, fontSize: 17)
      
      //scrollview
      //scrollView.directionalLockEnabled = true;
      
      //text
      
      analysisLabel.text = analyze(currentMetric)
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
      
      if (currentMetric.bad > 0 || currentMetric.good > 0) {
         badButtonWidthConstraint.constant = minWidth + CGFloat(currentMetric.bad)*unit
         goodButtonWidthConstraint.constant = minWidth + screenWidth - CGFloat(currentMetric.bad)*unit
      } else {
         badButtonWidthConstraint.constant = self.view.frame.size.width/2.0
         goodButtonWidthConstraint.constant = self.view.frame.size.width/2.0
      }
      
      Helper.styleColoredButton(badButton, color: Helper.badColor, title: Helper.formatStringNumber(-1*Int(currentMetric.bad)), fontSize: 20)
      Helper.styleColoredButton(goodButton, color: Helper.goodColor, title: Helper.formatStringNumber(Int(currentMetric.good)), fontSize: 20)
   }
   
   func analyze(met: Metric) -> String{
      var analysis = ""
      
      var daysOfData = 0
      
      var dailyFeelings = feelingsByDay(met)
      
      for (var i = 0; i < dailyFeelings.count; i++) {
         var day = dailyFeelings[i]
         
         if (day.count > 0){
            daysOfData++;
         }
         
      }
      
      if (daysOfData > 3) {
         var slopes = [
            slope(met, days: 3),
            slope(met, days: 7),
            slope(met, days: 14),
            slope(met, days: 28),
            slope(met, days: 1000000)
         ]
         
         var nets = [
            net(met, days: 3),
            net(met, days: 7),
            net(met, days: 14),
            net(met, days: 28),
            net(met, days: 1000000)
         ]
         
         
         var recentBenefit = 0 //gives more weight to 14 day than 3
         
         for (var i = 2; i >= 0; i--) {
            recentBenefit += slopes[i] + 2*nets[i]
            println(String(slopes[i]) + ", " + String(nets[i]))
         }
         
         var overallBenefit = 3*nets[slopes.count - 1] //gives more weight to net than slope
         
         
         var dir = 0 //how good or bad it is - based on slope and magnitude
         if (((recentBenefit < 3 && overallBenefit < 0) || recentBenefit < 0 || overallBenefit < -10) && !(recentBenefit >= -3 && overallBenefit > 0)){
            dir = 1
         }
         
         var inaccuracy = 0 //how sure we are - based on number of entries and days of data and magnitude
         var recentAbs = fabs(CGFloat(recentBenefit))
         var overallAbs = fabs(CGFloat(overallBenefit))/2.0
         if (recentAbs + overallAbs < 5){
            inaccuracy++
         }
         if (daysOfData < 7 || recentAbs + overallAbs < 10){
            inaccuracy++
         }
         if (daysOfData < 14){
            inaccuracy++
         }
         
         var dirStrings = [
            "keep " + met.title + " in",
            "eliminate " + met.title + " from"
         ]
         
         var accuracyStrings = [
            "almost certainly, that",
            "with a lot of confidence, that",
            "with a fair amount of confidence, that",
            "but not with much certainty, that"
         ]
         
         analysis += "We think, " + accuracyStrings[inaccuracy] + " you should " + dirStrings[dir] + " your life for now.\n\n"
         
         if (daysOfData < 14) {
            analysis += "You haven't been tracking how this makes you feel for very long. In another " + String(14 - daysOfData) + " days we'll have a better idea of the situation.\n\n"
         }
         
         analysis += "Recent Benefit:  " + String(recentBenefit) + " goodness\n"
         
         analysis += "Overall Benefit: " + String(overallBenefit) + " goodness"
         
      } else {
         "We need at least 3 days worth of data to make a somewhat accurate recommendation about " + met.title + ". You have " + String(3 - daysOfData) + " to go"
      }
      
      return analysis;
   }
   
   func slope(met : Metric, days: Int) -> Int {
      var dailyFeelings = feelingsByDay(met)
      var Sx = 0;
      var Sy = 0;
      var Sxx = 0;
      var Sxy = 0;
      var n = dailyFeelings.count;
      
      
      for (var i = 0; i < dailyFeelings.count && i < days; i++) {
         Sx -= i;
         Sy += Helper.netFeelings(dailyFeelings[i])
         Sxx += i*i;
         Sxy -= i*Helper.netFeelings(dailyFeelings[i]);
      }
      
      var slope = CGFloat(n*Sxy - Sx*Sy)/CGFloat(n*Sxx - Sx*Sx)
      
      var sign = 1
      if (slope < 0){
         sign = -1
      }
      
      if (fabs(slope) < 0.1){
         slope = 0
      }else if (fabs(slope) < 0.6){
         slope = 1
      }else if (fabs(slope) < 1){
         slope = 2
      }else{
         slope = 3
      }
      
      return Int(slope*CGFloat(sign))
   }
   
   func net(met : Metric, days: Int) -> Int {
      var dailyFeelings = feelingsByDay(met)
      var net = 0;
      
      
      for (var i = 0; i < dailyFeelings.count && i < days; i++) {
         net += Helper.netFeelings(dailyFeelings[i])
      }
      
      var sign = 1
      if (net < 0){
         sign = -1
      }
      
      var multipler = CGFloat(days)
      println(CGFloat(net) / CGFloat(dailyFeelings.count))
      net = Int(round(20 * CGFloat(net) / CGFloat(dailyFeelings.count))) //values per day * 2
      return net
   }
   
   func daysBetween(date1 : NSDate, date2 : NSDate) -> Int {
      let cal = NSCalendar.currentCalendar()
      
      let unit:NSCalendarUnit = .DayCalendarUnit
      
      let components = cal.components(unit, fromDate: date1, toDate: date2, options: nil)
      
      return components.day
   }
   
   func feelingsByDay(met : Metric) -> [[Feeling]] {
      var feelingsByDay : [[Feeling]] = []
      for(var i = 0; i < met.feelings.count; i++){
         var feeling = met.feelings[i]
         
         var days = abs(daysBetween(NSDate(), date2: feeling.date))
         
         while(feelingsByDay.count - 1 < days){
            feelingsByDay.append([])
         }
         
         feelingsByDay[days].append(feeling)
      }
      
      return feelingsByDay
   }
   
   func getImageForMetric(met : Metric) -> UIImage{
      
      let scale = UIScreen.mainScreen().scale
      
      var graphSize = CGSize(width: graph.frame.size.width*scale, height: graph.frame.size.height*scale)
      
      let origin = CGPoint(x: 30*scale, y: 80*scale)
      
      var maxVal : UInt = 0;
      
      UIGraphicsBeginImageContext(graphSize)
      var context = UIGraphicsGetCurrentContext();
      
      
      var backwardYValues : [Int] = []
      
      //pulled data
      var dailyFeelings = feelingsByDay(met)
      
      for (var i = 0; i < dailyFeelings.count; i++) {
         backwardYValues.append(Helper.netFeelings(dailyFeelings[i]))
      }
      
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
         
         //maxVal = UInt(5 * ceil(CGFloat(maxVal) / 5.0))
         
         
         //draw path
         var yUnit = 20*scale/CGFloat(maxVal)
         var xUnit = (graphSize.width - origin.x*1.5 - 10*scale*2) / CGFloat(max(10, yValues.count))
         
         var drawX = origin.x + 10*scale
         
         for (var i = 0; i < signs.count; i++) {
            
            var sign = signs[i]
            var valueSet = valueSets[i]
            
            var path = CGPathCreateMutable()
            var pathColor = Helper.goodColor.CGColor
            if (sign < 0){
               pathColor = Helper.badColor.CGColor
            }
            
            CGPathMoveToPoint(path, nil, drawX, origin.y - CGFloat(sign)*scale)
            drawX += xUnit/2.0
            
            for (var x = 0; x < valueSet.count; x++){
               CGPathAddLineToPoint(path, nil, drawX, origin.y - CGFloat(valueSet[x])*yUnit*scale - CGFloat(sign)*scale)
               
               if (x < valueSet.count - 1) {
                  drawX += xUnit
               }
            }
            
            drawX += xUnit/2.0
            CGPathAddLineToPoint(path, nil, drawX, origin.y - CGFloat(sign)*scale)
            
            CGPathCloseSubpath(path)
            CGContextAddPath(context, path)
            CGContextSetFillColorWithColor(context, pathColor)
            CGContextFillPath(context)
         }
      }
      
      //draw bar
      
      let barColor = UIColor(red: 77/255.0, green: 77/255.0, blue: 77/255.0, alpha: 1).CGColor
      
      CGContextSetFillColorWithColor(context, barColor);
      CGContextFillRect(context, CGRect(x: origin.x, y: origin.y - scale, width: graphSize.width - origin.x*1.5, height: 2*scale));
      
      
      //draw numbers
      
      CGContextTranslateCTM(context, 0.0, graphSize.height/scale)
      CGContextScaleCTM(context, 1.0, -1.0)
      
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
      var lastNote : UIView!
      
      var feelings : [Feeling] = []
      for (var i = 0; i < currentMetric.feelings.count; i++){
         if (currentMetric.feelings[i].note != "") {
            feelings.append(currentMetric.feelings[i])
         }
      }
      
      for (var i = feelings.count - 1; i >= 0; i--) {
         var feeling = feelings[i]
         
         var note = UIView()
         note.setTranslatesAutoresizingMaskIntoConstraints(false)
         scrollView.addSubview(note)
         
         //add uiview constraints
         var leftViewCons = NSLayoutConstraint(item: note, attribute: .Left, relatedBy: .Equal, toItem: scrollView, attribute: .Left, multiplier: 1, constant: 20)
         
         var topViewCons : NSLayoutConstraint;
         
         if (i == feelings.count - 1) {
            topViewCons = NSLayoutConstraint(item: note, attribute: .Top, relatedBy: .Equal, toItem: graph, attribute: .Bottom, multiplier: 1, constant: 0)
         } else {
            topViewCons = NSLayoutConstraint(item: note, attribute: .Top, relatedBy: .Equal, toItem: lastNote, attribute: .Bottom, multiplier: 1, constant: 10)
         }
         
         self.view.addConstraints([topViewCons, leftViewCons])
         
         if (i == 0) {
            var bottomViewCons = NSLayoutConstraint(item: note, attribute: .Bottom, relatedBy: .Equal, toItem: scrollView, attribute: .Bottom, multiplier: 1, constant: -100)
            
            self.view.addConstraint(bottomViewCons)
         }
         
         //button
         var button = UIButton()
         button.setTitle("", forState: .Normal)
         button.backgroundColor = Helper.colorForFeeling(feeling.value)
         
         button.setTranslatesAutoresizingMaskIntoConstraints(false)
         note.addSubview(button)
         
         //button constraints
         var widthButtonCons = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 5)
         var topButtonCons = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: note, attribute: .Top, multiplier: 1, constant: 0)
         var leftButtonCons = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: note, attribute: .Left, multiplier: 1, constant: 0)
         var bottomButtonCons = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: note, attribute: .Bottom, multiplier: 1, constant: 0)
         
         self.view.addConstraints([widthButtonCons, topButtonCons, leftButtonCons, bottomButtonCons])
         
         //date
         var formatter = NSDateFormatter()
         formatter.setLocalizedDateFormatFromTemplate("MMM d, yyyy - h:mm")
         
         var date = UILabel()
         date.text = formatter.stringFromDate(feeling.date)
         date.numberOfLines = 0
         date.font = UIFont(name: Helper.bodyTextFont, size: 10)
         date.textColor = UIColor(white: 0.3, alpha: 0.5)
         
         date.setTranslatesAutoresizingMaskIntoConstraints(false)
         note.addSubview(date)
         
         //date constraints
         var widthDateCons = NSLayoutConstraint(item: date, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 200)
         var topDateCons = NSLayoutConstraint(item: date, attribute: .Top, relatedBy: .Equal, toItem: note, attribute: .Top, multiplier: 1, constant: 0)
         var leftDateCons = NSLayoutConstraint(item: date, attribute: .Left, relatedBy: .Equal, toItem: button, attribute: .Right, multiplier: 1, constant: 20)
         
         self.view.addConstraints([widthDateCons, topDateCons, leftDateCons])
         
         //text
         
         var text = UILabel()
         text.text = feeling.note
         text.numberOfLines = 0
         text.font = UIFont(name: Helper.bodyTextFont, size: 15)
         
         text.setTranslatesAutoresizingMaskIntoConstraints(false)
         note.addSubview(text)
         
         //text constraints
         var widthTextCons = NSLayoutConstraint(item: text, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 200)
         var topTextCons = NSLayoutConstraint(item: text, attribute: .Top, relatedBy: .Equal, toItem: date, attribute: .Bottom, multiplier: 1, constant: 0)
         var leftTextCons = NSLayoutConstraint(item: text, attribute: .Left, relatedBy: .Equal, toItem: button, attribute: .Right, multiplier: 1, constant: 20)
         var bottomTextCons = NSLayoutConstraint(item: text, attribute: .Bottom, relatedBy: .Equal, toItem: note, attribute: .Bottom, multiplier: 1, constant: 0)
         
         self.view.addConstraints([widthTextCons, topTextCons, leftTextCons, bottomTextCons])
         
         
         lastNote = note;
      }
   }
   
}