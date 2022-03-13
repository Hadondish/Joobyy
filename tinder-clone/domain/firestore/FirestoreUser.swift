//
//  FirestoreUser.swift
//  tinder-clone
//
//  Created by Kevin and Kyle Tran on 3/1/22.
//

import Foundation


public struct FirestoreUser: Codable {
    let name: String
    let birthDate: Date
    let bio: String
    let isMale: Bool
    let orientation: Orientation
    let liked: [String]
    let passed: [String]
    let matched: [String]
    let mb: String
    let hobbies: String
    let job: String
    
    let firstAnswer: String
    let secondAnswer: String
    let thirdAnswer: String
    
    //MB, hobbies, job,
    var age: Int{
        return Date().years(from: birthDate)
    }

    enum CodingKeys: String, CodingKey {
        case name
        case birthDate
        case bio
        case isMale = "male"
        case orientation
        case liked
        case passed
        case matched
        case mb
        case hobbies
        case job
        case firstAnswer
        case secondAnswer
        case thirdAnswer
        
    }
}

public enum Orientation: String, Codable, CaseIterable{
    case men, women, both
}
