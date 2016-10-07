//
//  HistoricalEvents.swift
//  BoutTime
//
//  Created by The Bao on 10/7/16.
//  Copyright © 2016 The Bao. All rights reserved.
//

import Foundation


// Protocol

protocol HistoricalEventType {

    var selection: [PlayerList] { get }
    var question : [PlayerList : AnswersListType] { get set }

    init(question: [PlayerList: AnswersListType])
    func randomQuestion(previousNumber: Int?) -> (previousNumber: Int, event: AnswersListType)

}
protocol AnswersListType {
    var answerList : [String] {get set}
}
enum QuestionError: Error {
    case InvalidResource
    case ConversionError
    case InvalidKey
}

class plistConveter {

    class func dictionaryFromFile(resource: String, ofType type: String ) throws -> [String : AnyObject]{
        guard let path = Bundle.main.path(forResource: resource, ofType: type) else {
            throw QuestionError.InvalidResource
        }
        guard let dictionary = NSDictionary.init(contentsOfFile: path), let castDictionary = dictionary as? [String:AnyObject] else {
            throw QuestionError.ConversionError
        }
        return castDictionary
    }
}
class QuestionUnarchiver {

    class func gettingQuestionFromDictionary(dictionary: [String:AnyObject] ) throws -> [PlayerList : AnswersListType] {

        var question: [PlayerList: AnswersListType ] = [:]

        for (key,value) in dictionary {

            if let itemDict = value as? [String :[String]],
                let answer = itemDict["Answer"]
            {
                let item = Answer(answerList: answer)

                guard let key = PlayerList(rawValue: key) else {
                    throw QuestionError.InvalidKey
                }
                question.updateValue(item, forKey: key)
            }

        }
        //print(question)
        return question
    }
    
}


// Concrete Types

enum PlayerList: String {
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
struct Answer: AnswersListType {
     var answerList: [String]
}

class HistoricalEvent: HistoricalEventType {

    var selection: [PlayerList] = [.Costa,.Batshuayi,.Fabregas,.Kante,.Oscar,.Hazzard,.Pedro,.Mikel,.Moses,.Matic,.Willian,.Aina,.Cheek,.Chalobah,.Solanke,.Luiz,.Azpilicueta,.Terry,.Cahill,.Zouma,.Alonso,.Ivanovic,.Begovic,.Courtois,.Conte]

    var question: [PlayerList : AnswersListType]

    required init(question: [PlayerList : AnswersListType]) {
        self.question = question
    }

    func randomQuestion(previousNumber: Int?) -> (previousNumber: Int, event: AnswersListType) {
        var randomNumber = Int(arc4random_uniform(UInt32(selection.count)))
        while previousNumber == randomNumber {
            randomNumber = Int(arc4random_uniform(UInt32(selection.count)))
        }

        let answerList = question[selection[randomNumber]]

        return (randomNumber,answerList!)

    }

}









