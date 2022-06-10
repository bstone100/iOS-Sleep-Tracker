//
//  ReportView.swift
//  Final_Project
//
//  Created by Ben Stone on 5/30/22.
//

import SwiftUI

struct ReportView: View {
    @EnvironmentObject var sleepRecordVM: SleepRecordViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.Neumorphic.main
                    .ignoresSafeArea()
                if sleepRecordVM.sleepRecords.count > 0 {
                    ScrollView {
                        VStack {
                            GraphView()
                                .frame(height: 400)
                            Spacer()
                                .frame(height: 25)
                            PieView()
                                .frame(height: 400)
                        }
                        .padding()
                        .navigationTitle("Report")
                    }
                } else {
                    Text("No sleep recorded. Welcome!")
                        .navigationTitle("Report")
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct ReportView_Preview: PreviewProvider {
    @ObservedObject static var sleepRecordVM = SleepRecordViewModel()
    static var previews: some View {
        ReportView().environmentObject(sleepRecordVM)
    }
}
