//
//  ViewController.swift
//  BoutTime
//
//  Created by The Bao on 10/7/16.
//  Copyright © 2016 The Bao. All rights reserved.
//
//Test commit contributors 
import UIKit

class ViewController: UIViewController {

    @IBOutlet var firstAnswer: UILabel!
    @IBOutlet var secondAnswer: UILabel!
    @IBOutlet var thirdAnswer: UILabel!
    @IBOutlet var fourAnswer: UILabel!
    @IBOutlet var nextRoundButton: UIButton!
    @IBOutlet var timeLabel: UILabel!
    let historicalEvents: HistoricalEventType
    var previousEventNumber:[Int] = []
    var previousAnswerNumber:[Int] = []
    var timer = Timer()
    var count = 60
    var roundsPerGame = 6
    var totalScore = 0
    required init?(coder aDecoder: NSCoder) {

        do{
            let dictionary = try plistConveter.dictionaryFromFile(resource: "historicalEvents", ofType: "plist")
            let event = try EventUnarchiver.gettingEventFromDictionary(dictionary: dictionary)

          self.historicalEvents = HistoricalEvent(event: event)
        }catch let error {
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
    }



    func setupRound() {
        nextRoundButton.isHidden = true
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ViewController.timeCountDown), userInfo: nil, repeats: true)
        do {
            let period = try historicalEvents.randomEvent()
            displayEvents(period: period)
        }catch let error {
            fatalError("\(error)")
        }
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

      firstAnswer.text =   historicalEvents.randomIndexPeriod(period: period)
      secondAnswer.text = historicalEvents.randomIndexPeriod(period: period)
      thirdAnswer.text = historicalEvents.randomIndexPeriod(period: period)
      fourAnswer.text = historicalEvents.randomIndexPeriod(period: period)
        
    }

    enum ButtonType: Int {case FirstDown = 0, FirstUp, SecondDown, SecondUp, ThirdDown, ThirdUp
    }

   @IBAction func moveEvents(_ sender: UIButton) {
        switch(ButtonType(rawValue: sender.tag)!){
            case .FirstDown,.FirstUp: swapEvents(first: firstAnswer, second: secondAnswer)
            case .SecondDown,.SecondUp: swapEvents(first: secondAnswer, second: thirdAnswer)
            case .ThirdDown,.ThirdUp: swapEvents(first: thirdAnswer, second: fourAnswer)
        }
    }

    func swapEvents(first: UILabel, second: UILabel) {
        let temp = first.text
        first.text = second.text
        second.text = temp
    }

    @IBAction func nextRound() {
        count = 60
        if roundsPerGame > 0 {
            roundsPerGame -= 1
        } else {
            print("Total:\(totalScore)")
        }
        setupRound()
    }
    func checkCorrect() {

      let check = historicalEvents.checkCorrectOrder(first: firstAnswer, second: secondAnswer, third: thirdAnswer, four: fourAnswer)
      timer.invalidate()
      if check {
        if let nextRoundSuccess : UIImage = UIImage(named: "next_round_success") {
            nextRoundButton.isHidden = false
            nextRoundButton.setImage(nextRoundSuccess, for: UIControlState.normal)
            totalScore += 1
        }
      } else {
        if let nextRoundFail : UIImage = UIImage(named: "next_round_fail") {
            nextRoundButton.isHidden = false
            nextRoundButton.setImage(nextRoundFail, for: UIControlState.normal)
        }
      }
    }
   
    func timeCountDown(){
      if count > 0 {
        count -= 1
        timeLabel.text = String(count)
      } else {
        checkCorrect()
      }
    }
  // Shake Device
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
      if event?.subtype == UIEventSubtype.motionShake {
        checkCorrect()
      }
    }
  }

