//
//  TutorialQuoteViewController.swift
//  Metric
//
//  Created by Chance Daniel on 2/8/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import UIKit

class TutorialQuoteViewController: UIViewController {
   
   @IBOutlet weak var quoteLabel: UILabel!
   
   @IBOutlet var quoteByLabel: UILabel!
   
   @IBOutlet weak var gotItButton: UIButton!
   
   @IBAction func gotItPressed(sender: AnyObject) {
      let vc = self.storyboard?.instantiateViewControllerWithIdentifier("tutorialAddPersonViewController") as TutorialAddPersonViewController
      let customSegue = CustomSlideSegue(identifier: "anyid", source: self, destination: vc, shouldUnwind: false)
      customSegue.perform()
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setupView()
         
      
   }
   
   func setupView(){
      quoteLabel.font = UIFont(name: Helper.bodyTextFont, size: 18.0)
      quoteByLabel.font = UIFont(name: Helper.bodyTextFont, size: 18.0)
      
      quoteLabel.text = "\"Do what makes you happy, \n be with who makes you smile, \n laugh as much as breathe, \n and love as long as you live.\""
      
      gotItButton.titleLabel?.font = UIFont(name: Helper.buttonFont, size: 18.0)
      view.backgroundColor = Helper.darkNavyColor
      gotItButton.titleLabel?.textColor = Helper.darkNavyColor
   
   }
   
   
   override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
      return CustomSlideSegue(identifier: identifier, source: fromViewController, destination: toViewController, shouldUnwind: true)
   }
   
   
   @IBAction func unwindToQuote(segue: UIStoryboardSegue){
      gotItButton.clipsToBounds = true
      view.clipsToBounds = true
      
   }
   
}
