//
//  MetricManagerViewController.swift
//  Metric
//
//  Created by Chance Daniel on 2/3/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import UIKit

var addMode: Bool!
var editMode: Bool!
var row: Int!

class MetricManagerViewController: UIViewController {

   override func viewDidLoad() {
      super.viewDidLoad()
      metricTextField.becomeFirstResponder()
      addMode = false
      editMode = true
      row = 0
      setupView()

   }

   var newMetric: Metric!
   
   @IBOutlet weak var trashButton: UIButton!
   @IBOutlet weak var doneButton: UIButton!
   @IBOutlet var metricManagerView: UIView!
   @IBOutlet weak var metricTextField: UITextField!
   @IBOutlet weak var promptLabel: UILabel!
   
   @IBAction func trashMetric(sender: AnyObject) {
      dismissViewControllerAnimated(true, completion: nil)
   }
   
   func setupView(){
      doneButton.backgroundColor = Helper.darkNayColor
      
      if addMode == true {
         metricManagerView.backgroundColor = Helper.goldColor
         promptLabel.text = "Enter the name of the metric you'd like to track"
      }
      if editMode == true {
         metricManagerView.backgroundColor = Helper.purpleColor
         promptLabel.text = "Modify the name of the metric you're tracking"
         metricTextField.text = metricsManager.metrics[row].title
      }
      
      
   }

   override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//      self.view.endEditing(true)
   }

   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      self.view.endEditing(true)
   
      if segue.identifier == "DoneMetric" {
         if addMode == true {
            if let title = metricTextField.text {
               if !title.isEmpty{
                  newMetric = Metric(title: title)
               }
            }
         }
         if editMode == true {
            if let title = metricTextField.text {
               if !title.isEmpty{
                  metricsManager.metrics[row].title = title
               }
            }
         }
      }
   }
   


}
