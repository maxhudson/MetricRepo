//
//  FeedbackViewController.swift
//  Metric
//
//  Created by Max Hudson on 2/8/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import UIKit

struct Feedback {
   var cat1: String!
   var cat2: String!
   var feeling: Int!
   var notes: String!
}

var feedback : Feedback?

class FeedbackViewController: UIViewController {
   
   @IBOutlet weak var backButton: UIButton!
   @IBOutlet weak var topMessage: UILabel!
   @IBOutlet weak var bottomMessage: UILabel!
   
   @IBOutlet weak var option1: UIButton!
   @IBOutlet weak var option2: UIButton!
   @IBOutlet weak var option3: UIButton!
   @IBOutlet weak var option4: UIButton!
   @IBOutlet weak var option5: UIButton!
   @IBOutlet weak var option6: UIButton!
   
   @IBOutlet weak var feelingBad: UIButton!
   @IBOutlet weak var feelingGood: UIButton!
   
   @IBAction func backExit(sender: AnyObject) {
      if (viewMode == 1) {
         showView(0, item: 0)
      } else {
         dismissViewControllerAnimated(true, completion: nil)
      }
   }
   
   @IBAction func feelingExit(sender: AnyObject) {
      if (viewMode == 1) {
         feeling = sender.tag
         
         topMessage.text = ""
         
         feelingBad.backgroundColor = UIColor.clearColor()
         feelingGood.backgroundColor = UIColor.clearColor()
         
         feelingBad.setTitle("", forState: .Normal)
         feelingGood.setTitle("", forState: .Normal)
         
         mightMoveToNotes()
      }
   }
   
   @IBAction func optionExit(sender: AnyObject) {
      var tag = sender.tag
      
      if (viewMode == 0) {
         firstOption = buttonTitleSets[0][tag - 1].stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
         
         if (firstOption != "") {
            showView(1, item: tag)
         }
      } else {
         secondOption = buttonTitleSets[viewItem][tag - 1].stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
         
         for option in options {
            Helper.styleColoredButton(option, color: UIColor.clearColor(), title: "", fontSize: 15)
         }
         
         bottomMessage.text = ""
         
         mightMoveToNotes()
      }
   }
   
   func mightMoveToNotes() {
      if (feeling != 0 && secondOption != "") {
         feedback = Feedback(cat1: firstOption, cat2: secondOption, feeling: feeling, notes: "")
         manageNoteMode = "feedback"
         
         performSegueWithIdentifier("showFeedbackNote", sender: nil)
         
         Helper.delay(0.5, closure: { () -> () in
            self.feeling = 0
            self.secondOption = ""
            self.showView(1, item: self.viewItem);
         })
      }
   }
   
   var viewMode = 0
   var viewItem = 0
   var feeling = 0
   var firstOption = ""
   var secondOption = ""
   var buttonTitleSets : [[String]]!
   var options : [UIButton]!
   
   override func viewDidLoad() {
      Helper.styleNavButton(backButton, fontName: Helper.buttonFont, fontSize: 25)
      
      if (trackAnalytics) {
         PFAnalytics.trackEventInBackground("Viewed Feedback", block: nil)
      }
      
      buttonTitleSets = [
         [
            "General",
            "Summary",
            "Report\nBug",
            "Settings",
            "Other",
            ""
         ],
         [ //general
            "Tutorial",
            "Usabil-\nity",
            "Purpose",
            "Feature\nRequest",
            "Complaint",
            "Other"
         ],
         [ //analysis
            "Overall\nBenefit",
            "Recent\nBenefit",
            "Confi-\ndence",
            "Message",
            "Graph",
            "Other"
         ],
         [ //bugs
            "Crash",
            "Data\nLoss",
            "Security",
            "Other",
            "",
            ""
         ],
         [ //settings
            "Password",
            "Reminder",
            "Purchase\nUnlock",
            "Restore\nUnlock",
            "Other",
            ""
         ],
         [ //other
            "Colors",
            "Design",
            "Other",
            "",
            "",
            ""
         ],
         [
            "Other",
            "",
            "",
            "",
            "",
            ""
         ]
      ]
      
      options = [
         option1,
         option2,
         option3,
         option4,
         option5,
         option6
      ]
      
      topMessage.font = UIFont(name: Helper.navTitleFont, size: 17)
      topMessage.textColor = UIColor(white: 0.2, alpha: 1)
      
      bottomMessage.font = UIFont(name: Helper.navTitleFont, size: 17)
      bottomMessage.textColor = UIColor(white: 0.2, alpha: 1)
      
      showView(0, item: 0)
   }
   
   func showView(mode: Int, item: Int) {
      var buttonTitles : [String]!
      viewMode = mode
      viewItem = item
      
      if (mode == 0) {
         
         feeling = 0
         firstOption = ""
         secondOption = ""
         
         buttonTitles = buttonTitleSets[0]
         
         bottomMessage.text = ""
         
         feelingBad.backgroundColor = UIColor.clearColor()
         feelingGood.backgroundColor = UIColor.clearColor()
         
         feelingBad.setTitle("", forState: .Normal)
         feelingGood.setTitle("", forState: .Normal)
         
         
         topMessage.text = "\n\n\n\n\n\nThank you for providing feedback.\n\nIt's beneficial for everyone.\n\nWhat did you want to give feedback on?"

      } else if (mode == 1) {
         buttonTitles = buttonTitleSets[item]
         
         topMessage.text = "How did it make you feel?"
         
         Helper.styleColoredButton(feelingBad, color: Helper.badColor, title: "-", fontSize: 25)
         Helper.styleColoredButton(feelingGood, color: Helper.goodColor, title: "+", fontSize: 25)
         
         bottomMessage.text = "What about it?"
      }
      
      for (var i=0; i < options.count; i++) {
         if (buttonTitles[i] != "") {
            Helper.styleColoredButton(options[i], color: Helper.darkNavyColor, title: buttonTitles[i], fontSize: 15)
         }else {
            Helper.styleColoredButton(options[i], color: UIColor.clearColor(), title: "", fontSize: 15)
         }
      }
      
      for option in options {
         option.titleLabel!.numberOfLines = 0
         option.titleLabel!.font = UIFont(name: Helper.navTitleFont, size: 15)
      }
      
   }
}