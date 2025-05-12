import SwiftUI

extension Color {
    init(_ hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

struct ContentView: View {
    @State var launchData: [Launch] = []
    @State var rocketData: [Rocket] = []
    @State var companyData: Company?
    @State var should_only_show_successes = false
    @State var numLaunchesShown = 10.0 // XXX strange I needed to make this a double.
    
    let dateFormatter = ISO8601DateFormatter()
    
    // colours
    let cornerSize = 15
    let biggerText: CGFloat = 18
    let smallerText: CGFloat = 16
    let colBlack: UInt = 0x000000
    let colGrey: UInt = 0x4A4A4D
    let colBlue1: UInt = 0xDBD8FF
    let colBlue2: UInt = 0xEEEBFF
    
    var filteredLaunchData: [Launch] {
        var temp_data = launchData
        if should_only_show_successes {
            temp_data = temp_data.filter { $0.success == true }
        }
        return temp_data.suffix(Int(numLaunchesShown)) // return only the x most recent (bottom of the list)
    }
    
    func pullData() {
        Task {
            companyData = try await getData(from: "https://api.spacexdata.com/v4/company")
            launchData = try await getData(from: "https://api.spacexdata.com/v5/launches")
            rocketData = try await getData(from: "https://api.spacexdata.com/v4/rockets")
        }
        print("Data pulled")

    }
    
    func buildMenu() -> some View {
        
        Menu {
            
            Button("Refresh") {
                pullData()
            }
            Divider()
            
            Toggle("Successful rockets only", isOn: $should_only_show_successes)
            Divider()
            
            VStack {
                Text("Number of launches shown:")
                HStack {
                    Slider( // XXX Why does this look weird?
                        value: $numLaunchesShown,
                        in:    1...20,
                        step: 1,
                    )
                    Text("\(Int(numLaunchesShown))")
                }
                
                
            }
            
        } label: {
            Image(systemName: "gear")
                .font(.system(size: 24))
        }
    }
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // Title
                    HStack {
                        Text("SpaceX")
                            .bold()
                            .font(.system(size: 24))
                        Spacer()
                    }
                    
                    // Company
                    SectionTitleView(saying: "Company")
                    CompanyTextView(companyData)
                    
                    // Launch list
                    SectionTitleView(saying: "Launches")
                    
                    
                    VStack {
                        ForEach(0..<filteredLaunchData.count, id: \.self) { i in
                            let launchFromList = filteredLaunchData.reversed()[i]
                            NavigationLink(destination: LaunchDetailsView(launchFromList, rocketData)) {
                                ListItemView(launchFromList, rocketData) // reversed so recent ones at the top
                            }
                        }
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    buildMenu()
                }
            })
        }
        .padding(10)
        .onAppear {
            pullData()
        }
        
    }
}


func getData<T: Decodable>(from urlInput: String) async throws -> T {
    let url = URL(string: urlInput)!
    let request = URLRequest(url: url)
    let (data, _) = try await URLSession.shared.data(for: request)
    let decoder = JSONDecoder()
    
    return try decoder.decode(T.self, from: data)
}

struct Patch: Decodable {
    let small: String?
}

struct Link: Decodable { // XXX Any better way than making lots of structs??
    let patch: Patch
    let webcast: String?
    let wikipedia: String?
}

struct Failure: Decodable {
    let time: Int
    let altitude: Int?
    let reason: String
}

struct Launch: Decodable, Identifiable {
    let links: Link
    let rocket: String
    let success: Bool?
    let failures: [Failure]
    let details: String?
    let launchpad: String
    let name: String
    let date_local: String
    let launch_library_id: String?
    let id: String
    //    let upcoming: Bool // all are in the past
}


struct Rocket: Decodable {
    let id: String
    let name: String
}

struct Company: Decodable {
    let name: String
    let founder: String
    let founded: Int
    let employees: Int
    let launch_sites: Int
    let valuation: Int
}
