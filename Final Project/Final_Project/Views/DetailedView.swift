//
//  DetailedView.swift
//  Final_Project
//
//  Created by Ben Stone on 6/1/22.
//

import SwiftUI

struct DetailedView: View {
    var record: SleepRecord
    
    var detailed: some View {
        VStack {
            Text(record.sleepQuality.emoji)
                .font(.system(size: 150))
            Text("Sleep quality was \(record.sleepQuality.text).")
                .font(.system(size: 30))
            VStack {
                Text(record.startDateTimeFormatted)
                Image(systemName: "arrow.down")
                    .font(.system(size: 20))
                    .padding(5)
                Text(record.endDateTimeFormatted)
            }
            .padding()
        }
        .padding()
        .navigationTitle(record.timeFormatted)
    }
    
    var body: some View {
        ZStack {
            Color.Neumorphic.main
                .ignoresSafeArea()
            detailed
        }
    }
}
