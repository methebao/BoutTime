//
//  HistoricalEvents.swift
//  BoutTime
//
//  Created by The Bao on 10/7/16.
//  Copyright © 2016 The Bao. All rights reserved.
//

import Foundation
import UIKit

// Protocol

protocol HistoricalEventType {

    var eventList: [EventsList] { get }
    var event : [EventsList : PeriodsListType] { get set }
    init(event: [EventsList: PeriodsListType])
    func randomEvent() throws -> PeriodsListType
    func randomIndexPeriod (period: PeriodsListType)  -> String
    func checkCorrectOrder(first: UILabel,second: UILabel,third: UILabel,four: UILabel) -> Bool

}
protocol PeriodsListType {
    var periodsList : [String] { get set }
}
enum EventError: Error {
    case InvalidResource
    case ConversionError
    case InvalidKey
}
enum RandomError: Error {
    case RandomEventError
    case RandomPeriodError
}
class plistConveter {

    class func dictionaryFromFile(resource: String, ofType type: String ) throws -> [String : AnyObject]{
        guard let path = Bundle.main.path(forResource: resource, ofType: type) else {
            throw EventError.InvalidResource
        }
        guard let dictionary = NSDictionary.init(contentsOfFile: path), let castDictionary = dictionary as? [String:AnyObject] else {
            throw EventError.ConversionError
        }
        return castDictionary
    }
}
class EventUnarchiver {

    class func gettingEventFromDictionary(dictionary: [String:AnyObject] ) throws -> [EventsList : PeriodsListType] {

        var event: [EventsList: PeriodsListType ] = [:]

        for (key,value) in dictionary {

            if let itemDict = value as? [String :[String]],
                let answer = itemDict["Periods"]
            {
                let item = Answer(periodsList: answer)

                guard let key = EventsList(rawValue: key) else {
                    throw EventError.InvalidKey
                }
                event.updateValue(item, forKey: key)
            }

        }
        //print(event)
        return event
    }
    
}


// Concrete Types

enum EventsList: String {
    case Costa
    case Batshuayi
    case Fabregas
    case Kante
    case Oscar
    case Hazzard
    case Pedro
    case Mikel
    case Moses
    case Matic
    case Willian
    case Aina
    case Cheek
    case Chalobah
    case Solanke
    case Luiz
    case Azpilicueta
    case Terry
    case Cahill
    case Zouma
    case Alonso
    case Ivanovic
    case Begovic
    case Courtois
    case Conte
}
struct Answer: PeriodsListType {
     var periodsList: [String]
}

class HistoricalEvent: HistoricalEventType {

    var eventList: [EventsList] = [.Costa,.Batshuayi,.Fabregas,.Kante,.Oscar,.Hazzard,.Pedro,.Mikel,.Moses,.Matic,.Willian,.Aina,.Cheek,.Chalobah,.Solanke,.Luiz,.Azpilicueta,.Terry,.Cahill,.Zouma,.Alonso,.Ivanovic,.Begovic,.Courtois,.Conte]

    var event: [EventsList : PeriodsListType]

    var previousPeriodNumber: [Int] = []
    var previousEventNumber: [Int] = []
    var currentPeriod: PeriodsListType?
    required init(event: [EventsList : PeriodsListType]) {
        self.event = event
    }
    func randomEvent() throws -> PeriodsListType  {
        var check = true
        // Reset previous game event number
        if previousEventNumber.count > 6 {
            previousEventNumber = []
        }
        var randomEventNumber = 0
        while check {
            randomEventNumber = Int(arc4random_uniform(UInt32(eventList.count)))
            check = false
            for i in previousEventNumber {
                if randomEventNumber == i {
                    check =  true
                }
            }
            if check == false {
                check = false
            }

            if check == false {
                break
            }
        }
        // Optimize


        previousPeriodNumber.append(randomEventNumber)
        print(randomEventNumber)
        currentPeriod = event[eventList[randomEventNumber]]
        guard let periods = event[eventList[randomEventNumber]] else {
            throw RandomError.RandomEventError
        }
        return periods

    }

    func randomIndexPeriod (period: PeriodsListType)  -> String {
        var check = true

        // Reset previous round number
        if previousPeriodNumber.count > 4 {
            previousPeriodNumber = []
        }

        var randomPeriodNumber = 0
        while check {
             randomPeriodNumber = Int(arc4random_uniform(UInt32(period.periodsList.count)))
            //check = checkAnswerDuplication(number: randomQuestionNumber,type: "Answer")
            check = false
            for i in previousPeriodNumber {
                if randomPeriodNumber == i {
                    check =  true
                }
            }
            if check == false {
                check = false
            }

            if check == false {
                break
            }
         }
        // Optimize
        previousPeriodNumber.append(randomPeriodNumber)
        return period.periodsList[randomPeriodNumber]
    }

    func checkCorrectOrder(first: UILabel,second: UILabel,third: UILabel,four: UILabel) -> Bool {

        guard currentPeriod?.periodsList[0] == first.text, currentPeriod?.periodsList[1] == second.text, currentPeriod?.periodsList[2] == third.text, currentPeriod?.periodsList[3] == four.text else  {
            return false
        }
        return true
    }
    

}









