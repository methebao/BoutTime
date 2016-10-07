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
    var previousEventNumber:Int?
    var previousAnswerNumber:Int?
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
    func randomQuestion() -> [String] {

        let answers = historicalEvents.randomQuestion(previousNumber: previousEventNumber)
        previousEventNumber = answers.previousNumber
        print(answers)
        let answersTemp = answers.event
        let events = answersTemp.answerList

        return events
    }
    func displayEvents() {

        firstAnswer.text = randomIndexAnswer()
        print(firstAnswer.text)
        secondAnswer.text = randomIndexAnswer()
        thirdAnswer.text = randomIndexAnswer()
        fourAnswer.text = randomIndexAnswer()
    }

    func randomIndexAnswer () -> String {

        let events = randomQuestion()
        print(events)

        var randomNumber = Int(arc4random_uniform(UInt32(events.count)))
        while previousAnswerNumber == randomNumber {
            randomNumber = Int(arc4random_uniform(UInt32(events.count)))
        }
        previousAnswerNumber = randomNumber
        print(events[randomNumber])
        return events[randomNumber]
    }
    func setupView() {
        randomQuestion()
        randomIndexAnswer()
        displayEvents()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    enum ButtonType: Int {
    case FirstDown
    case FirstUp
    case SecondDown
    case SecondUp
    case ThirdDown
    case ThirdUp
    }

//    @IBAction func moveEvents(_ sender: UIButton) {
//
//        switch (ButtonType(rawValue: sender.tag)){
//
//        }
//
//    }

    
}

