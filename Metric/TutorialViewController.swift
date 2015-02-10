//
//  TutorialViewController.swift
//  Metric
//
//  Created by Chance Daniel on 2/8/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
   
   @IBOutlet weak var containerView: UIView!
   @IBOutlet weak var scrollView: UIScrollView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      

      
      
      let tutQVC = self.storyboard?.instantiateViewControllerWithIdentifier("tutorialQuoteViewController") as TutorialQuoteViewController
      self.addChildViewController(tutQVC)
      tutQVC.didMoveToParentViewController(self)
      
      let tutAPVC = self.storyboard?.instantiateViewControllerWithIdentifier("tutorialAddPersonViewController") as TutorialAddPersonViewController
      self.addChildViewController(tutAPVC)
      tutAPVC.didMoveToParentViewController(self)
      
      
   
   }
//   @IBAction func unwindToQuote(segue: UIStoryboardSegue){
////      if segue.identifier == "DoneMetricFromList" {
////         let metricManagerController = segue.sourceViewController as MetricManagerViewController
////         if let newMetric = metricManagerController.newMetric {
////            metricsManager.metrics += [newMetric]
////            tableView.reloadData()
////         }
////      }
//   }
//
////   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
////      if segue.identifier == "QuoteSegue" {
////        
////         let tutQVC = segue.destinationViewController as TutorialQuoteViewController
////         scrollView.addSubview(tutQVC.view)
////         tutQVC.didMoveToParentViewController(self)
////         
////         
////      }
////   }
//   
}
