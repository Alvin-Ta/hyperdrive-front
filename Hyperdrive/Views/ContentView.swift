//
//  ContentView.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-07-08.
//

import SwiftUI


enum Tab: String { case schedule, insights }
struct ContentView: View {
    @State private var selectedTab: Tab = .schedule  // start here
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack { InsightsView() }
                .tabItem { Label("Insights", systemImage: "chart.bar.xaxis") }
                .tag(Tab.insights)
            
            
            NavigationStack { ScheduleView(date: Date().formatted(.iso8601.year().month().day())) }
                .tabItem { Label("Schedule", systemImage: "calendar") }
                .tag(Tab.schedule)
        }
        .toolbarBackground(Color(red: 26/255, green: 26/255, blue: 29/255), for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarColorScheme(.dark, for: .tabBar)
        .tint(.white)        
    }
}

#Preview {
    ContentView()
}
