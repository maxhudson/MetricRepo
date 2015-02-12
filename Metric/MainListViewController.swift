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

var metrics: Metric! //???
var manageMetricMode: String! //indicate the mode in which metric note managing is happening
var manageNoteMode: String!
var noteFrom: String!
var currentMetricRow: Int! //reference to current metric row
var currentFeeling: Feeling! //current feeling for editing notes
var currentMetric : Metric = Metric(title: "", good: 0, bad: 0, feelings: []) //current metric for viewing metric

class MainListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
   @IBOutlet weak var addButton: UIButton!
   @IBOutlet weak var helpButton: UIButton!
   
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var navigationBar: UINavigationBar!
   
   @IBAction func addButtonEnter(sender: AnyObject) {
      
   }
   
   @IBAction func addButtonExit(sender: AnyObject) {
      manageMetricMode = "add"
      performSegueWithIdentifier("showMetricManagerSegue", sender: nil)
   }
   
   @IBAction func helpButtonEnter(sender: AnyObject) {
      
   }
   
   @IBAction func helpButtonExit(sender: AnyObject) {
      
   }
   
   @IBAction func plusButtonTouchDown(sender: UIButton) {
      metricButtonPressed(sender)
   }
   
   @IBAction func plusButtonTouchUp(sender: UIButton) {
      metricButtonReleased(sender, buttonId: 1, cancelled: false)
   }
   
   @IBAction func plusButtonTouchCancelled(sender: UIButton) {
      metricButtonReleased(sender, buttonId: 1, cancelled: true)
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
      let storyboard = UIStoryboard(name: "Main", bundle: nil)

      if segue.identifier == "showSummarySegue" {
         currentMetric = metricsManager.metrics[rowForButton(sender as UIButton).row]
         
         currentMetricRow = rowForButton(sender as UIButton).row
         
         let vc = storyboard.instantiateViewControllerWithIdentifier("MetricSummary") as SummaryViewController
         self.presentViewController(vc, animated: false, completion: nil)
      }
      if segue.identifier == "showNoteSegue"{
         let vc = storyboard.instantiateViewControllerWithIdentifier("NoteViewController") as AddNoteViewController
         self.presentViewController(vc, animated: true, completion: nil)
      }
      if segue.identifier == "showMetricManagerSegue" {
         if metricsManager.tutorialCompleted == true {
            let vc = storyboard.instantiateViewControllerWithIdentifier("MetricManagerViewController") as MetricManagerViewController
            self.presentViewController(vc, animated: true, completion: nil)
         }
         else {
            let vc = storyboard.instantiateViewControllerWithIdentifier("TutorialQuoteViewController") as TutorialQuoteViewController
            self.presentViewController(vc, animated: true, completion: nil)

         }
      }else if segue.identifier == "showFeedbackFromMain" {
         let vc = storyboard.instantiateViewControllerWithIdentifier("FeedbackViewController") as FeedbackViewController
         self.presentViewController(vc, animated: true, completion: nil)
      }
   }
   
   @IBAction func metricButtonTouchUp(sender: UIButton) {
      //take to new screen
      performSegueWithIdentifier("showSummarySegue", sender: sender)
      
      metricButtonReleased(sender, buttonId: 0, cancelled: false)
   }
   
   @IBAction func metricButtonTouchCancelled(sender: UIButton) {
      metricButtonReleased(sender, buttonId: 0, cancelled: true)
   }
   
   @IBAction func minusButtonTouchDown(sender: UIButton) {
      metricButtonPressed(sender)
   }
   
   @IBAction func minusButtonTouchUp(sender: UIButton) {
      var met = metricsManager.metrics[rowForButton(sender).row]
      
      metricButtonReleased(sender, buttonId: -1, cancelled: false)
   }
   
   @IBAction func minusButtonTouchCancelled(sender: UIButton) {
      metricButtonReleased(sender, buttonId: -1, cancelled: true)
   }
   
   @IBAction func giveFeedbackExit(sender: AnyObject) {
      noteFrom = "main"
      performSegueWithIdentifier("showFeedbackFromMain", sender: sender)
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
   
   func metricButtonReleased(button: UIButton, buttonId : Int, cancelled: Bool){
      let met = metricsManager.metrics[rowForButton(button).row]
      
      if (Helper.netMetric(met) >= 0){
         button.backgroundColor = Helper.darkGoodColor
      } else {
         button.backgroundColor = Helper.darkBadColor
      }
      
      var path = rowForButton(button)
      
      if let cell = tableView.cellForRowAtIndexPath(path) as? MainListTableViewCell {
         
         if (!cancelled) {
         
            if (button.titleForState(.Normal) == "-" || button.titleForState(.Normal) == "+") {
               //indicated feeling
               
               if (buttonId == -1){
                  met.lastFeeling = met.feelBad("")
               } else if (buttonId == 1){
                  met.lastFeeling = met.feelGood("")
               }
               
               met.delayReference = Helper.cancellableDelay(4.0) {
                  self.updateMetricViewMode(cell, mode: 1)
               }
               
               updateMetricViewMode(cell, mode: 0)
            } else if (buttonId == -1) {
               //undo
               
               if(met.lastFeeling?.value == 1) {
                  met.good--
               } else if (met.lastFeeling?.value == -1){
                  met.bad--
               }
               
               met.feelings.removeAtIndex(met.feelings.count - 1)
               
               Helper.cancelDelay(met.delayReference)
               updateMetricViewMode(cell, mode: 1)
            } else if (buttonId == 1) {
               //leave note
               //show note view controller
               manageNoteMode = "add"
               noteFrom = "list"
               currentFeeling = met.lastFeeling
               updateMetricViewMode(cell, mode: 1)
               performSegueWithIdentifier("showNoteSegue", sender: nil)

   //            currentFeeling = met.lastFeeling
   //            Helper.cancelDelay(met.delayReference)
   //            updateMetricViewMode(cell, mode: 1)
            }
            
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
      
      var feedbackData = PFObject(className: "Feedback")
      feedbackData.setObject("mklasfd", forKey: "cat1")
      feedbackData.setObject("mklasfd2", forKey: "cat2")
      feedbackData.setObject(1, forKey: "feeling")
      feedbackData.setObject("note", forKey: "notes")
      feedbackData.save()
      
   }
   
   override func viewWillAppear(animated: Bool) {
      
      super.viewWillAppear(animated)
      
      Helper.styleNavButton(helpButton, fontName: Helper.buttonFont, fontSize: 22)
      Helper.styleNavButton(addButton, fontName: Helper.lightButtonFont, fontSize: 30)
      
      
      //Helper.generateRandomData(10, values: 3, lowRange: -1, hiRange: 1, met: metricsManager.metrics[0])
   }
   
   func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 2
   }
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      var rows = [
         metricsManager.metrics.count,
         1
      ]
      
      return rows[section]
   }
   
   func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
      if (indexPath.section == 0) {
         let baseHeight : CGFloat = 70.0
         let netMet = CGFloat(metricsManager.metrics[indexPath.row].good + metricsManager.metrics[indexPath.row].bad)
         let multiplier : CGFloat = 0.8
         
         return baseHeight + netMet*multiplier
      } else {
         return 100
      }
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
      if (indexPath.section == 0) {
         var cell = tableView.dequeueReusableCellWithIdentifier("id1", forIndexPath: indexPath) as MainListTableViewCell
         
         var cellColor = Helper.badColor
         var met = metricsManager.metrics[indexPath.row]
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
         cell.centerButton.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 17)
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
      } else {
         var cell = tableView.dequeueReusableCellWithIdentifier("feedback", forIndexPath: indexPath) as FeedbackTableViewCell
         
         Helper.styleNavButton(cell.button, fontName: "Give Feedback", fontSize: 20)
         cell.button.titleLabel!.font = UIFont(name: Helper.navTitleFont, size: 15)
         
         return cell
      }
   }
   
//   @IBAction func unwindFromSum(segue: UIStoryboardSegue){
//      tableView.reloadData()
//   }
//   
   @IBAction func unwindToList(segue: UIStoryboardSegue){
      if segue.identifier == "DoneMetricFromList" {
         tableView.reloadData()
         let metricManagerController = segue.sourceViewController as MetricManagerViewController
         if let newMetric = metricManagerController.newMetric {
            metricsManager.metrics += [newMetric]
            tableView.reloadData()
         }
      }
      if segue.identifier == "DoneTutorialSegue" {
         println("Done Tutorial")
         for tutMetric in metricsManager.tutorialMetrics {
            metricsManager.metrics += [tutMetric]
         }
         metricsManager.tutorialCompleted = true
      }
   }
   
}