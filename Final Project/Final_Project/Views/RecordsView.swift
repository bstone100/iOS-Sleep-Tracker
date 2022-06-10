//
//  Records.swift
//  Final_Project
//
//  Created by Ben Stone on 5/23/22.
//

import SwiftUI

struct RecordsView: View {
    @EnvironmentObject var sleepRecordVM: SleepRecordViewModel
    @State var sortByDate = true
    
    func getColor(record: SleepRecord) -> Color {
        // ...6, 6...8, 8...
        if record.interval.duration >= 28800 {
            return Color.green
        } else if record.interval.duration >= 21600 {
            return Color.yellow
        }
        return Color.red
    }
    
    func delete(at offsets: IndexSet) -> Void {
        sleepRecordVM.deleteRecordAtIndex(index: offsets)
    }
    
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.Neumorphic.main
                    .ignoresSafeArea()
                if sleepRecordVM.sleepRecords.count > 0 {
                    List {
                        ForEach(sleepRecordVM.sleepRecords, id:\.id) { record in
                            NavigationLink(destination: DetailedView(record: record)) {
                                
                                HStack {
                                    Text(record.timeFormatted)
                                        .fontWeight(.bold)
                                        .foregroundColor(getColor(record: record)) +
                                    Text("  ") +
                                    Text(record.endDateFormatted)
                                    Spacer()
                                    Text(record.sleepQuality.emoji)
                                }
                                
                            }
                        }
                        .onDelete(perform: delete)
                        .listRowBackground(Color.Neumorphic.main)
                    }
                    .onChange(of: sortByDate) { unusedVar in
                        sleepRecordVM.sleepRecords.sort(by: sortByDate ? {$0.sleepEnd > $1.sleepEnd} : {$0.interval.duration > $1.interval.duration})
                    }
                    .onAppear {
                        sleepRecordVM.sleepRecords.sort(by: sortByDate ? {$0.sleepEnd > $1.sleepEnd} : {$0.interval.duration > $1.interval.duration})
                    }
                    .listStyle(PlainListStyle())
                    .navigationTitle("Records")
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Picker("sort by", selection: $sortByDate) {
                                Text("Date").tag(true)
                                Text("Time").tag(false)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                    }
                    
                } else {
                    Text("No sleep recorded. Welcome!")
                        .navigationTitle("Records")
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct Records_Previews: PreviewProvider {
    @ObservedObject static var sleepRecordVM = SleepRecordViewModel()
    static var previews: some View {
        RecordsView().preferredColorScheme(.dark).environmentObject(sleepRecordVM)
    }
}
