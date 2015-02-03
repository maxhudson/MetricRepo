//
//  MetricSummaryViewController.swift
//  Metric
//
//  Created by Max Hudson on 2/1/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import UIKit

class MetricSummaryViewController: UIViewController {
   
   @IBOutlet weak var badButton: UIButton!
   @IBOutlet weak var badButtonWidthConstraint: NSLayoutConstraint!
   @IBOutlet weak var goodButton: UIButton!
   @IBOutlet weak var goodButtonWidthConstraint: NSLayoutConstraint!
   
   @IBOutlet weak var backButton: UIButton!
   
   @IBOutlet weak var analysisLabel: UILabel!
   
   @IBOutlet weak var scrollView: UIScrollView!
   @IBOutlet weak var navBar: UINavigationBar!
   
   override func viewDidLoad() {
      //navigation bar
      navBar.topItem?.title = currentMetric.title
      Helper.styleNavButton(backButton, fontName: Helper.buttonFont, fontSize: 25)
      
      
      
      //scrollview
      scrollView.directionalLockEnabled = true;
      
      //text
      analysisLabel.text = "It looks like " + currentMetric.title + " has been making a fairly positive impact on your life recently. We can say with a fair bit of confidence that you should keep " + currentMetric.title + " in your life, at least for now."
      analysisLabel.font = UIFont(name: Helper.bodyTextFont, size: 15)
      
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
   
   
}