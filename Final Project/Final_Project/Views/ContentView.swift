//
//  ContentView.swift
//  Final_Project
//
//  Created by Ben Stone on 5/23/22.
//
import SwiftUI

struct ContentView: View {
    // just for preview
    // will come from file
    @ObservedObject var sleepRecordVM = SleepRecordViewModel()

    @ObservedObject var userVM = UserViewModel(user: TestData.getExampleUser())
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            RecordsView()
                .tabItem {
                    Image(systemName: "list.number")
                    Text("Records")
                }
            ReportView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Report")
                }
        }
        .environmentObject(sleepRecordVM)
        .environmentObject(userVM)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}
