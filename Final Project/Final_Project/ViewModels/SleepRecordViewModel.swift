//
//  SleepRecordViewModel.swift
//  Final_Project
//
//  Created by Sebastian Boyd on 5/25/22.
//

import Foundation
import RealmSwift

class SleepRecordViewModel: ObservableObject {
    private let realm = try! Realm()
    
    init() {
        self.sleepRecords = Array(realm.objects(SleepRecord.self))

//        if self.sleepRecords.isEmpty {
//            let records = TestData.generateRecords()
//            for record in records {
//                addRecord(record)
//            }
//        }
    }
    
    @Published var sleepRecords: [SleepRecord] = []
    
    func addRecord(_ record: SleepRecord) {
        sleepRecords.insert(record, at: 0)
        do {
            try realm.write({
                realm.add(record)
            })
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func deleteRecord(record: SleepRecord) {
        do {
            try realm.write({
                realm.delete(record)
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteRecordAtIndex(index: IndexSet) {
        for i in index {
            deleteRecord(record: sleepRecords[i])
            sleepRecords.remove(at: i)
        }
    }
    
    
    func overlapping(start: Date, end: Date) -> Bool {
        let interval = DateInterval(start: start, end: end)
        for r in sleepRecords {
            if DateInterval(start: r.sleepStart, end: r.sleepEnd).intersects(interval) {
                return true
            }
        }
        return false
    }
}
