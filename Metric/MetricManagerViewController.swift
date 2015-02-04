//
//  MetricManagerViewController.swift
//  Metric
//
//  Created by Chance Daniel on 2/3/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import UIKit

class MetricManagerViewController: UIViewController {

   override func viewDidLoad() {
      super.viewDidLoad()
      metricTextField.becomeFirstResponder()

   }

   var newMetric: Metric!
   
   @IBOutlet weak var metricTextField: UITextField!
   
   @IBAction func trashMetric(sender: AnyObject) {
      dismissViewControllerAnimated(true, completion: nil)
   }

   override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
      self.view.endEditing(true)
   }
   
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "DoneMetric" {
         if let title = metricTextField.text {
            if !title.isEmpty{
               newMetric = Metric(title: title)
            }
         }
      }
   }
   


}
