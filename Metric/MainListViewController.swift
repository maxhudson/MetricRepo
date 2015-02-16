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

var manageMetricMode: String! //indicate the mode in which metric note managing is happening
var manageNoteMode: String!
var noteFrom: String!
let passwordNotificationKey = "com.metric.passwordNotificationKey"
let lockBlurNotificationKey = "com.metric.lockBlurNotificationKey"

var currentMetricRow: Int! //reference to current metric row
var currentFeeling: Feeling! //current feeling for editing notes
var currentMetric : Metric = Metric(title: "", good: 0, bad: 0, feelings: []) //current metric for viewing metric
var trackAnalytics = false
var tutorialPartCompleted: Bool!
var shouldShowKeypad: Bool!
var senderAllowed = 0
var tablePlusButton: UIButton?
var tableMinusButton: UIButton?
var tableCenterButton: UIButton?

class MainListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   var tutorialCase = 0

   @IBOutlet weak var addButton: UIButton!
   @IBOutlet weak var helpButton: UIButton!
   
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var navigationBar: UINavigationBar!
   
   @IBAction func addButtonEnter(sender: AnyObject) {
      
   }
   
   @IBAction func addButtonExit(sender: AnyObject) {
      manageMetricMode = "add"
      if sender.tag == senderAllowed{
         performSegueWithIdentifier("showMetricManagerSegue", sender: nil)
      }
      removeButtonTag([sender as UIButton])
   }
   
   @IBAction func helpButtonEnter(sender: AnyObject) {
      
   }
   
   @IBAction func helpButtonExit(sender: AnyObject) {
      
   }
   
   @IBAction func plusButtonTouchDown(sender: UIButton) {
      metricButtonPressed(sender)
   }
   
   @IBAction func plusButtonTouchUp(sender: UIButton) {
      if sender.tag == senderAllowed{
         metricButtonReleased(sender, buttonId: 1, cancelled: false)
         if (tableMinusButton != nil) {
            removeButtonTag([sender, tableMinusButton!])
         }
         progressTutorial(self.view)
      }
   }
   
   @IBAction func plusButtonTouchCancelled(sender: UIButton) {
      metricButtonReleased(sender, buttonId: 1, cancelled: true)
   }
   
   @IBAction func centerButtonEnter(sender: UIButton) {
      if sender.tag == senderAllowed{
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
         } else {
            
            if (!metricsManager.sampleDataAdded) {
               Helper.delay(0.5, closure: { () -> () in
                  metricsManager.metrics.append(Metric(title: "Sample"))
                  Helper.generateTutorialData(metricsManager.metrics[0])
               })
               metricsManager.sampleDataAdded = true
            }
            
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
      if sender.tag == senderAllowed{
         performSegueWithIdentifier("showSummarySegue", sender: sender)
         metricButtonReleased(sender, buttonId: 0, cancelled: false)
         removeButtonTag([sender])
      }
   }
   
   @IBAction func metricButtonTouchCancelled(sender: UIButton) {
      metricButtonReleased(sender, buttonId: 0, cancelled: true)
   }
   
   @IBAction func minusButtonTouchDown(sender: UIButton) {
      metricButtonPressed(sender)
   }
   
   @IBAction func minusButtonTouchUp(sender: UIButton) {
      if sender.tag == senderAllowed{
         var met = metricsManager.metrics[rowForButton(sender).row]
         
         metricButtonReleased(sender, buttonId: -1, cancelled: false)
         if (tablePlusButton != nil) {
            removeButtonTag([sender, tablePlusButton!])
         }
         progressTutorial(self.view)
      }
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
      if button.tag == senderAllowed{
         let met = metricsManager.metrics[rowForButton(button).row]
         
         if (Helper.netMetric(met) >= 0){
            button.backgroundColor = Helper.darkGoodColor
         } else {
            button.backgroundColor = Helper.darkBadColor
         }
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
                  if (trackAnalytics) {
                     PFAnalytics.trackEventInBackground("ML Feeling Bad", block: nil)
                  }
               } else if (buttonId == 1){
                  met.lastFeeling = met.feelGood("")
                  if (trackAnalytics) {
                     PFAnalytics.trackEventInBackground("ML Feeling Good", block: nil)
                  }
               }
               
               met.delayReference = Helper.cancellableDelay(4.0) {
                  self.updateMetricViewMode(cell, mode: 1)
               }
               
               updateMetricViewMode(cell, mode: 0)
            } else if (buttonId == -1) {
               //undo
               if (trackAnalytics) {
                  PFAnalytics.trackEventInBackground("ML Undo", block: nil)
               }
               
               if(met.lastFeeling?.value == 1) {
                  met.good--
               } else if (met.lastFeeling?.value == -1){
                  met.bad--
               }
               
               met.feelings.removeAtIndex(met.feelings.count - 1)
               
               Helper.cancelDelay(met.delayReference)
               updateMetricViewMode(cell, mode: 1)
            } else if (buttonId == 1) {
               if (trackAnalytics) {
                  PFAnalytics.trackEventInBackground("ML New Note", block: nil)
               }
               //leave note
               manageNoteMode = "add"
               noteFrom = "list"
               currentFeeling = met.lastFeeling
               updateMetricViewMode(cell, mode: 1)
               performSegueWithIdentifier("showNoteSegue", sender: nil)

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
//      var authManager = Authentication()
//      authManager.authenticateUser(self)
      //Create Blur
//      let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
//      let blurView = UIVisualEffectView(effect: blurEffect)
      let blurView = UIView()
      blurView.backgroundColor = UIColor.grayColor()
      blurView.alpha = 0.9
      blurView.frame.size = self.view.frame.size
      blurView.tag = 4
//      self.view.addSubview(blurView)

      if (!metricsManager.tutorialCompleted) {
         setupButtonTag([addButton])
      }
      
      self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
      self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
   }
   
   
   func setupButtonTag(buttons: [UIButton]) {
      for button in buttons {
         button.tag = 3
      }
   }
   func removeButtonTag(buttons: [UIButton]) {
      for button in buttons {
         button.tag = 0
      }
   }
   
   override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)

      NSNotificationCenter.defaultCenter().addObserver(self, selector: "showPasswordKeypad", name: passwordNotificationKey, object: nil)
      
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "removeLockBlur", name: lockBlurNotificationKey, object: nil)
      

      
      Helper.styleNavButton(helpButton, fontName: Helper.buttonFont, fontSize: 22)
      Helper.styleNavButton(addButton, fontName: Helper.lightButtonFont, fontSize: 30)
      
      
      //Helper.generateRandomData(10, values: 3, lowRange: -1, hiRange: 1, met: metricsManager.metrics[0])
      
      //Tutorial
      progressTutorial(self.view)
      if metricsManager.tutorialCompleted == false{
         senderAllowed = 3
      }
      else {
         senderAllowed = 0
      }
   }
   
   override func viewDidAppear(animated: Bool) {
      super.viewDidAppear(animated)
      
      if shouldShowKeypad == nil || shouldShowKeypad == true {
         showPasswordKeypad()
         shouldShowKeypad = false
      }
   }
   
   func showPasswordKeypad() {
      performSegueWithIdentifier("AuthViewControllerSegue", sender: nil)
   }
   
   
   func removeLockBlur() {
      dismissViewControllerAnimated(true, completion: nil)
   }
   
   func progressTutorial(onView: UIView){
      var onView = onView as UIView
      //Tutorial
      if metricsManager.tutorialCompleted == false {
         
         switch tutorialCase {
         case 0:
            self.tableView.scrollEnabled = false

            let tutLabel = UILabel(frame: self.view.frame)
            tutLabel.text = "press the \'+\' \n to get started."
            tutLabel.numberOfLines = 2
            
            var circles = [Shape]()
            var circle1 = Shape(circleDiameter: 100, center: CGPointMake(view.frame.width-50, navigationBar.center.y))
            circles.append(circle1)
            
            var rectangles = [Shape]()
            
            var tutorialViewManager = TutorialView(circles: circles, rectangles: rectangles, viewToAddTo: self.view, label: tutLabel)
            tutorialViewManager.createTutorialView()
            
            tutorialCase = 1
            break
         case 1:
            for subv in view.subviews {
               var subView: UIView = subv as UIView
               if subv.tag == 1{
                  subv.removeFromSuperview()
               }
            }
            
            let tutLabel = UILabel(frame: self.view.frame)
            tutLabel.text = "tap on \'+\' or \'-\' \n when you feel \n good or bad \n about something"
            tutLabel.numberOfLines = 6
            
            var circles = [Shape]()
            
            var rectangles = [Shape]()
            var rectangle1 = Shape(width: view.frame.width, height: 113.6, center: CGPointMake(view.frame.width/2,navigationBar.frame.height + 113.6/2))
            rectangles.append(rectangle1)
            
            var tutorialViewManager = TutorialView(circles: circles, rectangles: rectangles, viewToAddTo: self.view, label: tutLabel)
            tutorialViewManager.createTutorialView()
        
            tutorialCase = 2
            break
         case 2:
            for subv in view.subviews {
               var subView: UIView = subv as UIView
               if subv.tag == 1{
                  subv.removeFromSuperview()
               }
            }
            
            let tutLabel = UILabel(frame: self.view.frame)
            tutLabel.text = "with these you can \n undo a feeling \n or add a note"
            tutLabel.numberOfLines = 3
            
            var circles = [Shape]()
            let circle1 = Shape(circleDiameter: 50, center: CGPointMake(50, 100))
            let circle2 = Shape(circleDiameter: 50, center: CGPointMake(self.view.frame.width - 50, 100))
            circles.append(circle1)
            circles.append(circle2)
            
            var rectangles = [Shape]()
         
            
            var tutorialViewManager = TutorialView(circles: circles, rectangles: rectangles, viewToAddTo: self.view, label: tutLabel)
            tutorialViewManager.createTutorialView()
            tutorialCase = 3
            
            UIView.animateWithDuration(1, delay: 4.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
               for subv in self.view.subviews {
                  var subView: UIView = subv as UIView
                  if subView.tag == 1{
                     subView.alpha = 0
                  }
               }

            }, completion: { (finished) -> Void in
               if finished == true {
                  for subv in self.view.subviews {
                     var subView: UIView = subv as UIView
                     if subv.tag == 1{
                        subv.removeFromSuperview()
                     }
                  }
                  self.progressTutorial(self.view)
               }
            })
            
            break
         case 3:
            if (tableCenterButton != nil) {
               tableCenterButton!.tag = 3
            }
            let tutLabel = UILabel(frame: self.view.frame)
            tutLabel.text = "tap here to \n see a summary \n of your metric"
            tutLabel.numberOfLines = 6
            
            var circles = [Shape]()
            
            var rectangles = [Shape]()
            var rectangle1 = Shape(width: (3/5)*view.frame.width, height: 113.6, center: CGPointMake(view.frame.width/2,navigationBar.frame.height + 113.6/2))
            rectangles.append(rectangle1)
            
            
            tutorialCase = 4

         
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
               var tutorialViewManager = TutorialView(circles: circles, rectangles: rectangles, viewToAddTo: self.view, label: tutLabel)
               tutorialViewManager.createTutorialView()
               }, completion: { (finished) -> Void in
                  if finished == true {
                     self.progressTutorial(self.view)
                  }
            })
            break
         case 4:
            let tutLabel = UILabel(frame: self.view.frame)
            tutLabel.text = "go ahead \n play around"
            tutLabel.numberOfLines = 2
            
            var circles = [Shape]()
            
            var rectangles = [Shape]()
            var rectangle1 = Shape(width: view.frame.width, height: 4*view.frame.height/10, center: CGPointMake(view.frame.width/2, 4*view.frame.height/20))
            var rectangle2 = Shape(width: view.frame.width, height: 4*view.frame.height/10, center: CGPointMake(view.frame.width/2, view.frame.height - 4*view.frame.height/20))
            
            tutorialCase = 5

            var tutorialViewManager = TutorialView(circles: circles, rectangles: rectangles, viewToAddTo: onView, label: tutLabel)
            tutorialViewManager.createTutorialView()
            
            Helper.delay(2, closure: { () -> () in
               UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
                  for subv in onView.subviews {
                     var subView: UIView = subv as UIView
                     if subv.tag == 1{
                        subView.alpha = 0
                     }
                  }
                  
                  }, completion: { (finished) -> Void in
                     if finished == true {
                        for subv in onView.subviews {
                           var subView: UIView = subv as UIView
                           if subv.tag == 1{
                              subv.removeFromSuperview()
                           }
                        }
                     }
                     
               })
            })
            break
         case 5:
            for subv in view.subviews {
               var subView: UIView = subv as UIView
               if subv.tag == 1{
                  subv.removeFromSuperview()
               }
            }
            
            let tutLabel = UILabel(frame: self.view.frame)
            tutLabel.text = "finished! \n go ahead and \n add a few more \n \n enjoy"
            tutLabel.numberOfLines = 6
            
            var circles = [Shape]()
            var rectangles = [Shape]()

            var tutorialViewManager = TutorialView(circles: circles, rectangles: rectangles, viewToAddTo: self.view, label: tutLabel)
            tutorialViewManager.createTutorialView()
            
            Helper.delay(4, closure: { () -> () in
               UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
                  for subv in self.view.subviews {
                     var subView: UIView = subv as UIView
                     if subv.tag == 1{
                        subView.alpha = 0
                     }
                  }
                  
                  }, completion: { (finished) -> Void in
                     if finished == true {
                        for subv in self.view.subviews {
                           var subView: UIView = subv as UIView
                           if subv.tag == 1{
                              subv.removeFromSuperview()
                           }
                        }
                        metricsManager.tutorialCompleted = true
                        senderAllowed = 0
                        self.tableView.scrollEnabled = true
                     }
               })

            })
            
            break
         default:
            break
         }
      }
   }
   
   
   func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 2
   }
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      var showGiveFeedback = 0
      if (metricsManager.tutorialCompleted == true) {
         showGiveFeedback = 1
      }
      
      var rows = [
         metricsManager.metrics.count,
         showGiveFeedback
      ]
      
      return rows[section]
   }
   
   func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
      if (indexPath.section == 0) {
         return Helper.heightForMetricCell(indexPath)
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

         if tutorialCase == 2 && indexPath.row == 0{
            tableCenterButton = cell.centerButton
            tableMinusButton = cell.minusButton
            tablePlusButton = cell.plusButton
            setupButtonTag([cell.plusButton, cell.minusButton])
         }
         
         return cell
      } else {
         var cell = tableView.dequeueReusableCellWithIdentifier("feedback", forIndexPath: indexPath) as FeedbackTableViewCell
         
         Helper.styleNavButton(cell.button, fontName: "Give Feedback", fontSize: 20)
         cell.button.titleLabel!.font = UIFont(name: Helper.navTitleFont, size: 15)
         
         return cell
      }
   }
   
   
   @IBAction func unwindToList(segue: UIStoryboardSegue){
      if segue.identifier == "DoneMetricFromList" {
         tableView.reloadData()
         let metricManagerController = segue.sourceViewController as MetricManagerViewController
         if let newMetric = metricManagerController.newMetric {
            metricsManager.metrics += [newMetric]
         }
      }
      if segue.identifier == "DoneTutorialSegue" {
         for tutMetric in metricsManager.tutorialMetrics {
            metricsManager.metrics += [tutMetric]
         }
         tableView.reloadData()
//         metricsManager.tutorialCompleted = true
         
      }
      tableView.reloadData()
   }
   
}