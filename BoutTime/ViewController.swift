//
//  ViewController.swift
//  BoutTime
//
//  Created by The Bao on 10/7/16.
//  Copyright © 2016 The Bao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var firstAnswer: UILabel!
    @IBOutlet var secondAnswer: UILabel!
    @IBOutlet var thirdAnswer: UILabel!
    @IBOutlet var fourAnswer: UILabel!

    let historicalEvents: HistoricalEventType
    var previousNumber:Int?
    required init?(coder aDecoder: NSCoder) {

        do{
            let dictionary = try plistConveter.dictionaryFromFile(resource: "historicalEvents", ofType: "plist")
            let question = try QuestionUnarchiver.gettingQuestionFromDictionary(dictionary: dictionary)
            self.historicalEvents = HistoricalEvent(question: question)
        } catch let error {
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
    }




    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
    }





    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

