//
//  AddSleep.swift
//  Final_Project
//
//  Created by Ben Stone on 5/23/22.
//

import SwiftUI

struct AddSleepView: View {
    @EnvironmentObject var sleepRecordVM: SleepRecordViewModel
    @EnvironmentObject var userVM: UserViewModel
    @Environment(\.colorScheme) var colorScheme
    
//    @State var showPicker: Bool = true //TODO change to false default

    @State var sleepQuality = SleepQuality.great
    
    // 10 pm yesterday
    @State var startDate = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date.now) ?? Date.now
    
    // 10 am today
    @State var endDate = Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date()) ?? Date.now
    
    
    // will be initialized from file
    
    // 10 pm yesterday
    func getDefaultStartDate() -> Date {
        return Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date.now) ?? Date.now
    }
    // 10 am today
    func getDefaultEndDate() -> Date {
        return Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date()) ?? Date.now
    }
    // 24 hours before endDate
    func getDayBefore() -> Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: endDate) ?? endDate
    }
    
    func checkEndDate() -> Date {
        if endDate > Date() {
            return Date()
        }
        return endDate
    }
    
    var addSleep: some View {
        VStack {
            Text("Good Morning, \(userVM.user.name)")
                .font(.title)
                .padding()
            
            DatePicker("Fell asleep: ", selection: $startDate, in: getDayBefore()...endDate)

            DatePicker("Woke up: ", selection: $endDate, in: ...Date())
            
            Text("Sleep Quality:")
            
            VStack {
                ForEach(SleepQuality.allCases, id: \.hashValue) { quality in
                    VStack {
                        Button {
                            sleepQuality = quality
                        } label: {
                            HStack {
                                Text(quality.emoji)
                                Text(quality.text)
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                Spacer()
                                if sleepQuality == quality {
                                    Image(systemName: "checkmark")
                                }
                            }.frame(height:20)

                        }
                        if quality.hashValue != SleepQuality.last.hashValue {
                            Divider()
                        }
                    }

                }
            }
            .padding()
//            .background(Color.systemsBackground)
//            .background(Color("BgColor"))
            HStack {
                Button("Submit") {
                    sleepRecordVM.addRecord(SleepRecord(sleepStart: startDate, sleepEnd: checkEndDate(), sleepQuality: sleepQuality))
                    startDate = getDefaultStartDate()
                    endDate = getDefaultEndDate()
                    sleepQuality = SleepQuality.great
                }
                .disabled(
                    // out of range
                    startDate >= endDate ||
                    // or overlapping
                    sleepRecordVM.overlapping(start: startDate, end: endDate)
                )
            }
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow()
            addSleep
                .padding()
        }
        .frame(height: 400)
    }
}

struct AddSleep_Previews: PreviewProvider {
    static var userVM = UserViewModel(user: TestData.getExampleUser())
    static var previews: some View {
        AddSleepView()
            .environmentObject(SleepRecordViewModel())
            .environmentObject(userVM)
    }
}
