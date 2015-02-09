//
//  FeedbackViewController.swift
//  Metric
//
//  Created by Max Hudson on 2/8/15.
//  Copyright (c) 2015 Max Hudson. All rights reserved.
//

import UIKit

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
   
   
   var mode = 0
   var buttonTitleSets : [[String]]!
   var options : [UIButton]!
   
   override func viewDidLoad() {
      
      Helper.styleNavButton(backButton, fontName: Helper.buttonFont, fontSize: 25)
      
      buttonTitleSets = [
         [
            "Graph",
            "Analysis",
            "Notes",
            "Interface",
            "Other",
            ""
         ],
         [
            "",
            "",
            "",
            "",
            "",
            ""
         ],
         [
            "Overall\nBenefit",
            "Recent\nBenefit",
            "Confi-\ndence",
            "Message",
            "Other",
            ""
         ],
         [
            "",
            "",
            "",
            "",
            "",
            ""
         ],
         [
            "",
            "",
            "",
            "",
            "",
            ""
         ],
         [
            "",
            "",
            "",
            "",
            "",
            ""
         ],
         [
            "",
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
      
      showView(1, item: 2)
   }
   
   func showView(mode: Int, item: Int) {
      var buttonTitles : [String]!
      if (mode == 0) {
          buttonTitles = buttonTitleSets[0]
         
         bottomMessage.text = ""
         
         topMessage.text = "Thank you for providing feedback.\n\nIt's beneficial for everyone.\n\nWhat did you want to give feedback on?"

      } else if (mode == 1) {
         buttonTitles = buttonTitleSets[item]
         
         topMessage.text = "How did it make you feel?"
         
         Helper.styleColoredButton(feelingBad, color: Helper.badColor, title: "-", fontSize: 25)
         Helper.styleColoredButton(feelingGood, color: Helper.goodColor, title: "+", fontSize: 25)
         
         bottomMessage.text = "What about it?"
      }
      
      for (var i=0; i < options.count; i++) {
         if (buttonTitles[i] != "") {
            Helper.styleColoredButton(options[i], color: Helper.darkNayColor, title: buttonTitles[i], fontSize: 15)
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