//
//  FirestoreMessage.swift
//  tinder-clone
//
//  Created by Kevin and Kyle Tran on 24/1/22.
//

import Foundation

struct FirestoreMessage: Codable{
    let message: String
    let timestamp: Date
    let senderId: String
}
