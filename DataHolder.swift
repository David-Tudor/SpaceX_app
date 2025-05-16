//
//  File.swift
//  SpaceXNetwork
//
//  Created by David Tudor on 14/05/2025.
//

import Foundation

@MainActor class DataHolder: ObservableObject {
    @Published var launchData: [Launch] = []
    @Published var rocketData: [Rocket] = []
    @Published var companyData: Company?
    @Published var should_only_show_successes = false
    @Published var numLaunchesShown = 10.0
    
    func pullData() {
        Task {
            companyData = try await getData(from: "https://api.spacexdata.com/v4/company")
            launchData = try await getData(from: "https://api.spacexdata.com/v5/launches")
            rocketData = try await getData(from: "https://api.spacexdata.com/v4/rockets")
        }
        print("Data pulled")
    }
    // TODO next: make class an actor, then use main actor for this type of problem - research actors.
}
