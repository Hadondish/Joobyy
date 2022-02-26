//
//  FirebaseMatch.swift
//  tinder-clone


import Foundation

struct FirestoreMatch: Codable{
    let usersMatched: [String]
    let timestamp: Date
}
