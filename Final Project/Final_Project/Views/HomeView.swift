//
//  HomeView.swift
//  Final_Project
//
//  Created by Ben Stone on 5/30/22.
//

import SwiftUI
import Neumorphic

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.Neumorphic.main
                    .ignoresSafeArea()
                AddSleepView()
                    .padding()
                    .navigationTitle("Welcome")
            }
        }
        .navigationViewStyle(.stack)
    }
}
