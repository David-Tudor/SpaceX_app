import Foundation

class DataHolder: ObservableObject {
    @Published private(set) var launchData: [Launch] = []
    @Published private(set) var rocketData: [Rocket] = []
    @Published private(set) var companyData: Company?
    @Published var should_only_show_successes = false
    @Published var numLaunchesShown = 10.0
    @Published var isLoading = false
    @Published var error = ""
    
    func pullData() async {
        await MainActor.run {
            isLoading = true
        }
        
        async let launchTemp: [Launch] = try getData(from: "https://api.spacexdata.com/v5/launches")
        async let rocketTemp: [Rocket] = try getData(from: "https://api.spacexdata.com/v4/rockets")
        async let companyTemp: Company? = try getData(from: "https://api.spacexdata.com/v4/company")
        
        do {
            let x = try await (launchTemp, rocketTemp, companyTemp)
            await MainActor.run {
                (launchData, rocketData, companyData) = x
                isLoading = false
            }
        } catch let err {
            print(err)
            await MainActor.run {
                isLoading = false
                error = err.localizedDescription
            }
        }
    }
    
}
