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
    @IBOutlet var nextRoundSuccess: UIButton!

    let historicalEvents: HistoricalEventType
    var previousEventNumber:[Int] = []
    var previousAnswerNumber:[Int] = []

    
    required init?(coder aDecoder: NSCoder) {

        do{
            let dictionary = try plistConveter.dictionaryFromFile(resource: "historicalEvents", ofType: "plist")
            let event = try EventUnarchiver.gettingEventFromDictionary(dictionary: dictionary)

          self.historicalEvents = HistoricalEvent(event: event)
        } catch let error {
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
    }



    func setupRound() {
        nextRoundSuccess.isHidden = true
        let period =  historicalEvents.randomEvent()
        displayEvents(period: period)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupRound()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func displayEvents(period: PeriodsListType) {
      firstAnswer.text =  historicalEvents.randomIndexPeriod(period: period)
      secondAnswer.text = historicalEvents.randomIndexPeriod(period: period)
      thirdAnswer.text = historicalEvents.randomIndexPeriod(period: period)
      fourAnswer.text = historicalEvents.randomIndexPeriod(period: period)
    }

    enum ButtonType: Int {
    case FirstDown = 0
    case FirstUp
    case SecondDown
    case SecondUp
    case ThirdDown
    case ThirdUp
    }

   @IBAction func moveEvents(_ sender: UIButton) {

        switch(ButtonType(rawValue: sender.tag)!){
            case .FirstDown,.FirstUp: swapEvents(first: firstAnswer, second: secondAnswer)
            case .SecondDown,.SecondUp: swapEvents(first: secondAnswer, second: thirdAnswer)
            case .ThirdDown,.ThirdUp: swapEvents(first: thirdAnswer, second: fourAnswer)
        }
      let a = historicalEvents.checkCorrectOrder(first: firstAnswer, second: secondAnswer, third: thirdAnswer, four: fourAnswer)
    if a {
      nextRoundSuccess.isHidden = false
    }
    }

    func swapEvents(first: UILabel, second: UILabel) {
        let temp = first.text
        first.text = second.text
        second.text = temp
    }
  
    @IBAction func nextRound() {

      setupRound()
      
    }

   

    
}

