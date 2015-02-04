//
//  MainListViewController.swift
//  Metric
//
//  Created by Max Hudson on 1/30/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import UIKit
import CoreData

var metricsManager = MetricsManager()

//var metrics : [Metric] = []
var metrics: Metric!
var currentMetric : Metric = Metric(title: "", good: 0, bad: 0, feelings: [])

class MainListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
   @IBOutlet weak var addButton: UIButton!
   @IBOutlet weak var helpButton: UIButton!
   
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var navigationBar: UINavigationBar!
   
   @IBAction func addButtonEnter(sender: AnyObject) {
      
   }
   
   @IBAction func addButtonExit(sender: AnyObject) {
      
   }
   
   @IBAction func helpButtonEnter(sender: AnyObject) {
      
   }
   
   @IBAction func helpButtonExit(sender: AnyObject) {
      
   }
   
   @IBAction func plusButtonTouchDown(sender: UIButton) {
      metricButtonPressed(sender)
   }
   
   @IBAction func plusButtonTouchUp(sender: UIButton) {
//      var met = metrics[rowForButton(sender).row]
      var met = metricsManager.metrics[rowForButton(sender).row]
      metricButtonReleased(sender, buttonId: 1)
   }
   
   @IBAction func centerButtonEnter(sender: UIButton) {
      var path = rowForButton(sender)
      
      if let cell = tableView.cellForRowAtIndexPath(path) as? MainListTableViewCell {
//         var met = metrics[rowForButton(sender).row]
         var met = metricsManager.metrics[rowForButton(sender).row]

         if (Helper.netMetric(met) >= 0){
            cell.centerButton.backgroundColor = Helper.darkGoodColor
            cell.plusButton.backgroundColor = Helper.darkGoodColor
            cell.minusButton.backgroundColor = Helper.darkGoodColor
         } else {
            cell.centerButton.backgroundColor = Helper.darkBadColor
            cell.plusButton.backgroundColor = Helper.darkBadColor
            cell.minusButton.backgroundColor = Helper.darkBadColor
         }
      }
   }
   
   @IBAction func metricButtonTouchUp(sender: UIButton) {
      //take to new screen
      currentMetric = metricsManager.metrics[rowForButton(sender).row]
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let vc = storyboard.instantiateViewControllerWithIdentifier("MetricSummary") as MetricSummaryViewController
      self.presentViewController(vc, animated: false, completion: nil)
      
      metricButtonReleased(sender, buttonId: 0)
   }
   
   @IBAction func minusButtonTouchDown(sender: UIButton) {
      metricButtonPressed(sender)
   }
   
   @IBAction func minusButtonTouchUp(sender: UIButton) {
      var met = metricsManager.metrics[rowForButton(sender).row]
      metricButtonReleased(sender, buttonId: -1)
   }
   
   func rowForButton(sender: AnyObject) -> NSIndexPath {
      let pointInTable: CGPoint = sender.convertPoint(sender.bounds.origin, toView: tableView)
      return tableView.indexPathForRowAtPoint(pointInTable)!
   }
   
   func metricButtonPressed(button: UIButton){
      let met = metricsManager.metrics[rowForButton(button).row]
      
      if (Helper.netMetric(met) >= 0){
         button.backgroundColor = Helper.darkGoodColor
      } else {
         button.backgroundColor = Helper.darkBadColor
      }
   }
   
   func metricButtonReleased(button: UIButton, buttonId : Int){
      let met = metricsManager.metrics[rowForButton(button).row]
      
      if (Helper.netMetric(met) >= 0){
         button.backgroundColor = Helper.darkGoodColor
      } else {
         button.backgroundColor = Helper.darkBadColor
      }
      
      if (buttonId == -1){
         met.feelBad("")
      } else if (buttonId == 1){
         met.feelGood("")
      }
      
      var path = rowForButton(button)
      
      if let cell = tableView.cellForRowAtIndexPath(path) as? MainListTableViewCell {
         
         Helper.delay(0.05) {
            self.tableView.reloadData()
         }
         
      }
   }
   
   override func viewDidLoad() {
      
      self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
      
      if (metricsManager.metrics.count == 0){
         metricsManager.metrics += [
            Metric(title: "Coffee", good: 30, bad: 80, feelings: []),
            Metric(title: "Drugs", good: 0, bad: 5, feelings: []),
            Metric(title: "Art", good: 5, bad: 0, feelings: []),
            Metric(title: "Best Friend", good: 30, bad: 10, feelings: []),
            Metric(title: "Girlfriend", good: 30, bad: 50, feelings: []),
            Metric(title: "Healthy Food", good: 10, bad: 0, feelings: []),
            Metric(title: "Unhealthy Food", good: 0, bad: 20, feelings: [])
         ]
      }
   }
   
   override func viewWillAppear(animated: Bool) {
      
      super.viewWillAppear(animated)
      
      Helper.styleNavButton(helpButton, fontName: Helper.buttonFont, fontSize: 22)
      Helper.styleNavButton(addButton, fontName: Helper.lightButtonFont, fontSize: 30)
   }
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return metricsManager.metrics.count
   }
   
   func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
      let baseHeight : CGFloat = 80.0
      let netMet = CGFloat(metricsManager.metrics[indexPath.row].good + metricsManager.metrics[indexPath.row].bad)
      let multiplier : CGFloat = 0.8
      
      return baseHeight + netMet*multiplier
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCellWithIdentifier("id1", forIndexPath: indexPath) as MainListTableViewCell
      
      var cellColor = Helper.badColor
      let met = metricsManager.metrics[indexPath.row]
      if (Helper.netMetric(met) >= 0){
         cellColor = Helper.goodColor
      }
      
      cell.plusButton.backgroundColor = cellColor
      cell.plusButton.setTitleColor(Helper.coloredButtonTextColor, forState: .Normal)
      cell.plusButton.setTitleColor(Helper.coloredButtonTextColor, forState: .Selected)
      cell.plusButton.setTitleColor(Helper.coloredButtonTextColor, forState: .Highlighted)
      cell.plusButton.titleLabel!.font = UIFont(name: "Quicksand-Bold", size: 30)
      
      cell.centerButton.backgroundColor = cellColor
      cell.centerButton.setTitleColor(Helper.coloredButtonTextColor, forState: .Normal)
      cell.centerButton.setTitleColor(Helper.coloredButtonTextColor, forState: .Selected)
      cell.centerButton.setTitleColor(Helper.coloredButtonTextColor, forState: .Highlighted)
      
      cell.centerButton.setTitle(met.title, forState: .Normal)
      cell.centerButton.titleLabel!.font = UIFont(name: "Quicksand-Bold", size: 17)
      cell.centerButton.titleEdgeInsets = UIEdgeInsets(top: -18, left: 0, bottom: 0, right: 0)
      
      cell.netMet.text = Helper.formatStringNumber(Helper.netMetric(met))
      cell.netMet.font = UIFont(name: "Quicksand-Bold", size: 13)
      cell.netMet.textColor = Helper.coloredButtonTextColor
      
      cell.minusButton.backgroundColor = cellColor
      cell.minusButton.setTitleColor(Helper.coloredButtonTextColor, forState: .Normal)
      cell.minusButton.setTitleColor(Helper.coloredButtonTextColor, forState: .Selected)
      cell.minusButton.setTitleColor(Helper.coloredButtonTextColor, forState: .Highlighted)
      cell.minusButton.titleLabel!.font = UIFont(name: "Quicksand-Bold", size: 30)
      
      return cell
   }
   
}