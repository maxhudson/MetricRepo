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
var manageMetricMode: String!
var manageNoteMode: String!
var currentMetricRow: Int!
var currentFeeling: Feeling!
var currentMetric : Metric = Metric(title: "", good: 0, bad: 0, feelings: [])

class MainListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
   @IBOutlet weak var addButton: UIButton!
   @IBOutlet weak var helpButton: UIButton!
   
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var navigationBar: UINavigationBar!
   
   @IBAction func addButtonEnter(sender: AnyObject) {
      
   }
   
   @IBAction func addButtonExit(sender: AnyObject) {
      manageMetricMode = "add"
   }
   
   @IBAction func helpButtonEnter(sender: AnyObject) {
      
   }
   
   @IBAction func helpButtonExit(sender: AnyObject) {
      
   }
   
   @IBAction func plusButtonTouchDown(sender: UIButton) {
      metricButtonPressed(sender)
   }
   
   @IBAction func plusButtonTouchUp(sender: UIButton) {
      var met = metricsManager.metrics[rowForButton(sender).row]
      metricButtonReleased(sender, buttonId: 1)
   }
   
   @IBAction func centerButtonEnter(sender: UIButton) {
      var path = rowForButton(sender)
      
      if let cell = tableView.cellForRowAtIndexPath(path) as? MainListTableViewCell {
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
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "showSummarySegue" {
         currentMetric = metricsManager.metrics[rowForButton(sender as UIButton).row]
         currentMetricRow = rowForButton(sender as UIButton).row
         
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let vc = storyboard.instantiateViewControllerWithIdentifier("MetricSummary") as MetricSummaryViewController
         self.presentViewController(vc, animated: false, completion: nil)
      }
      if segue.identifier == "showNoteSegue"{
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let vc = storyboard.instantiateViewControllerWithIdentifier("NoteViewController") as AddNoteViewController
         self.presentViewController(vc, animated: true, completion: nil)
      }
   }
   
   @IBAction func metricButtonTouchUp(sender: UIButton) {
      //take to new screen
      performSegueWithIdentifier("showSummarySegue", sender: sender)
      
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
      
      
      
      var path = rowForButton(button)
      
      if let cell = tableView.cellForRowAtIndexPath(path) as? MainListTableViewCell {
         
         if (button.titleForState(.Normal) == "-" || button.titleForState(.Normal) == "+") {
            //indicated feeling
            
            if (buttonId == -1){
               met.lastFeeling = met.feelBad("feeling bad")
            } else if (buttonId == 1){
               met.lastFeeling = met.feelGood("feeling good")
            }
            
            met.feelings.append(met.lastFeeling!)
            
            updateMetricViewMode(cell, mode: 0)
         } else if (buttonId == -1) {
            //undo
            met.feelings.removeAtIndex(met.feelings.count - 1)
            updateMetricViewMode(cell, mode: 1)
         } else if (buttonId == 1) {
            //leave note
            //show note view controller
            manageNoteMode = "add"
            currentFeeling = met.lastFeeling
            updateMetricViewMode(cell, mode: 1)
            performSegueWithIdentifier("showNoteSegue", sender: nil)

         }
         
      }
      
      Helper.delay(0.05) {
         self.tableView.reloadData()
      }
   }
   
   func updateMetricViewMode(cell: MainListTableViewCell, mode : Int){
      if (mode == 0){
         cell.minusButton.setImage(UIImage(named: "undo"), forState: .Normal)
         cell.minusButton.setTitle("", forState: .Normal)
         
         cell.plusButton.setImage(UIImage(named: "note"), forState: .Normal)
         cell.plusButton.setTitle("", forState: .Normal)
      } else if (mode == 1){
         cell.minusButton.setImage(nil, forState: .Normal)
         cell.minusButton.setTitle("-", forState: .Normal)
         
         cell.plusButton.setImage(nil, forState: .Normal)
         cell.plusButton.setTitle("+", forState: .Normal)
      }
   }
   
   override func viewDidLoad() {
      
      self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
      self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
      
      //if (metricsManager.metrics.count == 0){
         
         metricsManager.metrics = [
            Metric(title: "Graph 1", good: 0, bad: 0, feelings: []),
            Metric(title: "Graph 2", good: 0, bad: 0, feelings: []),
            Metric(title: "Graph 3", good: 0, bad: 0, feelings: [])
         ]
      
         for (var i = 0; i < 20; i++) {
            var rand : Int = random() % 5
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let startDate:NSDate = dateFormatter.dateFromString("2015-02-0" + String(rand + 1))!
            
            metricsManager.metrics[0].feelings.append(Feeling(value: (random() % 3) - 1, note: "This is the note content for note id number " + String(i), date: startDate))
         }
      
      for (var i = 0; i < 20; i++) {
         var rand : Int = random() % 5
         
         let dateFormatter = NSDateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
         
         let startDate:NSDate = dateFormatter.dateFromString("2015-02-0" + String(rand + 1))!
         
         metricsManager.metrics[1].feelings.append(Feeling(value: (random() % 3) - 1, note: "This is the note content for note id number " + String(i), date: startDate))
      }
      for (var i = 0; i < 120; i++) {
         var rand : Int = random() % 30
         
         let dateFormatter = NSDateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
         
         let startDate:NSDate = dateFormatter.dateFromString("2015-01-0" + String(rand + 1))!
         
         metricsManager.metrics[1].feelings.append(Feeling(value: (random() % 4) - 1, note: "", date: startDate))
      }
      for (var i = 0; i < 20; i++) {
         var rand : Int = random() % 5
         
         let dateFormatter = NSDateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
         
         let startDate:NSDate = dateFormatter.dateFromString("2015-02-0" + String(rand + 1))!
         
         metricsManager.metrics[2].feelings.append(Feeling(value: (random() % 3) - 1, note: "This is the note content for note id number " + String(i), date: startDate))
      }
      for (var i = 0; i < 120; i++) {
         var rand : Int = random() % 30
         
         let dateFormatter = NSDateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
         
         let startDate:NSDate = dateFormatter.dateFromString("2015-01-0" + String(rand + 1))!
         
         metricsManager.metrics[2].feelings.append(Feeling(value: (random() % 3) - 1, note: "", date: startDate))
      }
      for (var i = 0; i < 120; i++) {
         var rand : Int = random() % 30
         
         let dateFormatter = NSDateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
         
         let startDate:NSDate = dateFormatter.dateFromString("2014-11-0" + String(rand + 1))!
         
         metricsManager.metrics[2].feelings.append(Feeling(value: (random() % 3) - 1, note: "", date: startDate))
      }
      //}
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
      let baseHeight : CGFloat = 70.0
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
   
//   @IBAction func unwindFromSum(segue: UIStoryboardSegue){
//      tableView.reloadData()
//   }
//   
   @IBAction func unwindToList(segue: UIStoryboardSegue){
      if segue.identifier == "DoneMetric" {
         tableView.reloadData()
         let metricManagerController = segue.sourceViewController as MetricManagerViewController
         if let newMetric = metricManagerController.newMetric {
            metricsManager.metrics += [newMetric]
            tableView.reloadData()
         }
      }
   }
   
}