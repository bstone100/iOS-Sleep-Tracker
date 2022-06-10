//
//  UserData.swift
//  Final_Project
//
//  Created by Sebastian Boyd on 5/30/22.
//

import Foundation

class TestData {
    static func getTime(i: Int) -> TimeInterval {
        if i % 3 == 0 {
            return 32400
        } else if i % 3 == 1 {
            return 25200
        }
        return 18000
    }
    
    static func getQuality(i: Int) -> SleepQuality {
        if i % 3 == 0 {
            return .great
        } else if i % 3 == 1 {
            return .good
        }
        return .ok
    }
    
    static func generateRecords() -> [SleepRecord] {
        var records: [SleepRecord] = []
        var dateComponents = DateComponents()
        var start = Date()
        
        for i in 1...3 {
            dateComponents.year = 2022
            dateComponents.month = 5
            dateComponents.day = i
            dateComponents.hour = 22
            dateComponents.minute = 0
            start = Calendar.current.date(from: dateComponents) ?? Date()
            records.insert(SleepRecord(sleepStart: start, sleepEnd: start.advanced(by: getTime(i: i)), sleepQuality: getQuality(i: i)), at: 0)
        }
        return records
    }
    
    static func getExampleUser() -> User {
        return User(name: "Ben")
    }
}
