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
    let colLightGrey: UInt = 0x9A9A9D
    let colBlue1: UInt = 0xDBD8FF
    let colBlue2: UInt = 0xEEEBFF
    let colGreen: UInt = 0xb3e6b3
    let colRed: UInt = 0xff8080
    
    var filteredLaunchData: [Launch] {
        var temp_data = launchData
        if should_only_show_successes {
            temp_data = temp_data.filter { $0.success == true }
        }
        return temp_data.suffix(Int(numLaunchesShown)) // return only the x most recent (bottom of the list)
    }
    
    func pullData() {
        do {
            Task {
                companyData = try await getData(from: "https://api.spacexdata.com/v4/company")
                launchData = try await getDataArray(from: "https://api.spacexdata.com/v5/launches")
                rocketData = try await getDataArray(from: "https://api.spacexdata.com/v4/rockets")
            }
            
        } catch {
            print(error)
        }
    }
    
    
    func buildSectionTitle(saying text: String) -> some View {
        ZStack (alignment: .center) {
            RoundedRectangle(cornerSize: CGSize(width: cornerSize, height: cornerSize))
                .fill(Color(colLightGrey))
                .frame(height: 20)
            Text(text)
        }
    }
    
    func buildCompanyText() -> some View {
        HStack {
            if let c = companyData {
                Text("\(c.name) was founded by \(c.founder) in \(String(c.founded)). It has now \(c.employees) employees, \(c.launch_sites) launch sites, and is valued at \(c.valuation) USD.")
            } else {
                Text("companyData not found.")
            }
        }
    }
    
    func buildLaunchInfoView(for launch: Launch) -> some View {
        // XXX bad that it breaks if date goes on two lines
        HStack {
            VStack(alignment: .leading) {
                Text("Mission")
                Text("Date/time")
                Text("Rocket")
                //                    Text(true ? "Days since now" : "Days from now") // XXX all are in the past? There is an "upcoming" variable.
                Text("Time since")
                
            }
//            .frame(width: 75)
            
            VStack(alignment: .leading) {
                // Mission name
                Text("\(launch.name)")
                
                // Date
                if let date = dateFormatter.date(from: launch.date_local) {
                    Text("\(date.formatted(date: .abbreviated, time: .shortened))".padding(toLength: 20, withPad: " ", startingAt: 0) )
                        .foregroundColor(Color(colGrey))
                        .font(.system(size: smallerText, weight: .regular))
//                        .fixedSize(horizontal: false, vertical: true) // makes it wrap
                }
                
                // Rocket
                if let rocket = rocketData.first(where: { item in item.id == launch.rocket}) {
                    Text(rocket.name)
                } else {
                    Text("Unknown")
                }
                
                // Time since
                if let date = dateFormatter.date(from: launch.date_local) {
                    let currentDate = NSDate() as Date
                    let diffInDays = Calendar.current.dateComponents([.day], from: date, to: currentDate).day
                    Text("\(Int(diffInDays!)) days")
                }
                
            }
            .padding(.horizontal, 30)
            .frame(height: 80)
        }
        
        
//        VStack {
//            HStack(alignment: .leading) {
//                Text("Mission")
//                    .frame(width: colWidth)
//                Text("\(launch.name)")
//            }
//            
//            HStack {
//                Text("Date/time")
//                    .frame(width: colWidth)
//                
//                if let date = dateFormatter.date(from:launch.date_local) {
//                    Text("\(date.formatted(date: .abbreviated, time: .shortened))".padding(toLength: 20, withPad: " ", startingAt: 0) )
//                        .foregroundColor(Color(colGrey))
//                        .font(.system(size: smallerText, weight: .regular))
//                        .fixedSize(horizontal: false, vertical: true)
//                }
//            }
//            
//            HStack {
//                Text("Rocket")
//                    .frame(width: colWidth)
//                
//                if let rocket = rocketData.first(where: { item in item.id == launch.rocket}) {
//                    Text(rocket.name)
//                    //                        .frame(alignment: .leading)
//                } else {
//                    Text("Unknown")
//                }
//            }
//            
//            HStack {
//                // Text(true ? "Days since now" : "Days from now") // XXX all are in the past? There is an "upcoming" variable.
//                Text("Time since")
//                    .frame(width: colWidth)
//                //                    let currentDate = NSDate()
//                //                    let diffInDays = Calendar.current.dateComponents([.day], from: launch.date_local, to: currentDate).day
//                //                    Text("\(launch.date_local)")
//                //                    Text("\(currentDate)")
//            }
    }
    
    // XXX how many of these views rely on being in content view for the data - or could they be extracted.?
    func buildListItemView(with launch: Launch) -> some View {
        ZStack (alignment: .topLeading) {
            RoundedRectangle(cornerSize: CGSize(width: cornerSize, height: cornerSize))
                .fill(Color(launch.success == true ? colGreen : colRed))
            
            HStack {
            
                // Get patch image
                if let imageLink = launch.links.patch.small {
                    AsyncImage(url: URL(string: imageLink)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {}
                    .frame(width: 60, height: 60)
                } else {
                    // If image doesn't exist, show a question mark. XXX how to make symbols bigger.
                    ZStack(alignment: .center) {
                        Image(systemName: "questionmark.circle")
                            .symbolVariant(.circle)
                            .imageScale(.large)
                    }
                }
                
                buildLaunchInfoView(for: launch)
                
                // Show success or failure
                Image(systemName: launch.success == true ? "checkmark" : "xmark")
                    .symbolVariant(.circle)
                    .imageScale(.large)

            }
        }
        .frame(height: 100)
    }
    
    func buildMenu() -> some View {
        Menu("Filter launches") {
            Button("Refresh") {
                pullData() // XXX Can't find a way to test that this works
            }
            Divider()
            
            Toggle("Successful rockets only", isOn: $should_only_show_successes)
            Divider()
            
            Slider( // XXX Why does this look weird?
                    value: $numLaunchesShown,
                    in:    1...20,
                    step: 1,
                    )
                    Text("Number of launches shown: \(Int(numLaunchesShown))")
                    
        }
    }
    
    func launchDetailsView(for launch: Launch) -> some View {
        // When a launch is clicked, show some more information
        
        VStack(alignment: .center) {
            // Show the other information again
            if let imageLink = launch.links.patch.small {
                AsyncImage(url: URL(string: imageLink)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {}
                    .frame(width: 180, height: 180)
            }
            buildLaunchInfoView(for: launch)
                
            // Youtube and wiki links
            Text("")
            VStack(alignment: .leading) {
                if let linkWeb = launch.links.webcast {
                    Text("Youtube link: \(linkWeb)")
                }
                if let linkWiki = launch.links.wikipedia {
                    Text("Wikipedia link: \(linkWiki)")
                }
                Spacer()
            }
        }
    }
    
    
    var body: some View {
        VStack {
            // Title
            HStack {
                Text("SpaceX")
                    .bold()
                Spacer()
                
                buildMenu()
            }
            
            // Company
            buildSectionTitle(saying: "Company")
            buildCompanyText()
            
            // Launch list
            buildSectionTitle(saying: "Launches")
            NavigationView {
                ScrollView {
                    VStack {
                        ForEach(0..<filteredLaunchData.count, id: \.self) { i in
                            NavigationLink(destination: launchDetailsView(for: filteredLaunchData.reversed()[i])) {
                                buildListItemView(with: filteredLaunchData.reversed()[i]) // reversed so recent ones at the top
                            }
                        }
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(10)
        .task {
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

func getDataArray<T: Decodable>(from urlInput: String) async throws -> [T] {
    let url = URL(string: urlInput)!
    let request = URLRequest(url: url)
    let (data, _) = try await URLSession.shared.data(for: request)
    let decoder = JSONDecoder()
    
    return try decoder.decode([T].self, from: data)
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
