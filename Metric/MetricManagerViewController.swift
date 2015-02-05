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
      setupView()
   }

   var newMetric: Metric!
   
   @IBOutlet weak var trashButton: UIButton!
   @IBOutlet weak var doneButton: UIButton!
   @IBOutlet var metricManagerView: UIView!
   @IBOutlet weak var metricTextField: UITextField!
   
   @IBAction func trashMetric(sender: AnyObject) {
      dismissViewControllerAnimated(true, completion: nil)
   }
   
   func setupView(){
      doneButton.backgroundColor = Helper.darkNayColor
      metricManagerView.backgroundColor = Helper.goldColor
      
   }

   override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//      self.view.endEditing(true)
   }

   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      self.view.endEditing(true)

      if segue.identifier == "DoneMetric" {
         if let title = metricTextField.text {
            if !title.isEmpty{
               newMetric = Metric(title: title)
            }
         }
      }
   }
   


}
