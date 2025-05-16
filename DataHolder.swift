import Foundation

class DataHolder: ObservableObject {
    @Published var launchData: [Launch] = []
    @Published var rocketData: [Rocket] = []
    @Published var companyData: Company?
    @Published var should_only_show_successes = false
    @Published var numLaunchesShown = 10.0
    
    func pullData() {
        
        Task { @MainActor in
            async let launchTemp: [Launch] = try getData(from: "https://api.spacexdata.com/v5/launches")
            async let rocketTemp: [Rocket] = try getData(from: "https://api.spacexdata.com/v4/rockets")
            async let companyTemp: Company? = try getData(from: "https://api.spacexdata.com/v4/company")
        
            (launchData, rocketData, companyData) = try await (launchTemp, rocketTemp, companyTemp)
        }
        
    }
}
