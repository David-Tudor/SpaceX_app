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
    @State var should_only_show_successes = false
    
    var filteredLaunchData: [Launch] {
        var temp_data = launchData
        if should_only_show_successes {
            temp_data = temp_data.filter { $0.success == true }
        }
        return temp_data.suffix(numLaunchesShown)
    }
    
    let numLaunchesShown = 18
    let dateFormatter = ISO8601DateFormatter()
    
    let cornerSize = 15
    let biggerText: CGFloat = 18
    let smallerText: CGFloat = 16
    let colBlack: UInt = 0x000000 // Customise colours more?
    let colGrey: UInt = 0x4A4A4D
    let colBlue1: UInt = 0xDBD8FF
    let colBlue2: UInt = 0xEEEBFF
    let colGreen: UInt = 0xb3e6b3
    let colRed: UInt = 0xff8080
    

    func buildLaunchView(with launch: Launch) -> some View {
        ZStack (alignment: .topLeading) {
            RoundedRectangle(cornerSize: CGSize(width: cornerSize, height: cornerSize))
                .fill(Color(launch.success == true ? colGreen : colRed))
            
            HStack {
                VStack(alignment: .leading) {
                    if let date = dateFormatter.date(from:launch.date_local) {
                        Text("\(date.formatted(date: .abbreviated, time: .shortened))".padding(toLength: 20, withPad: " ", startingAt: 0) )
                            .foregroundColor(Color(colGrey))
                            .font(.system(size: smallerText, weight: .regular))
                    }
                }
                .padding(.horizontal, 30)
                .frame(height: 80)
//                Spacer()
                
                if let rocket = rocketData.first(where: { item in item.id == launch.rocket}) {
                    Text(rocket.name)
//                        .frame(alignment: .leading)
                } else {
                    Text("Rocket not found")
                }
                
                Text(launch.success == true ? "Success" : "Failure")
            }
        }
        .frame(height: 80)
    }
    
    var body: some View {
        VStack { // do I need this  VStack?
            Toggle("Show only successful rockets", isOn: $should_only_show_successes)
            
            ScrollView {
                VStack {
                    ForEach(0..<filteredLaunchData.count, id: \.self) { i in
                        buildLaunchView(with: filteredLaunchData.reversed()[i]) // reversed so recent ones at the top
                        
                        // blues removed, now remove i?

                    }
                }
                
            }
        }
        .padding(10)
        .task {
            do {
                launchData = try await getData(from: "https://api.spacexdata.com/v5/launches") // does this need to be v4 too?
                rocketData = try await getData(from: "https://api.spacexdata.com/v4/rockets")
                
            } catch {
                print(error)
            }
            
        }
    }
}

func getData<T: Decodable>(from urlInput: String) async throws -> [T] {
    let url = URL(string: urlInput)!
    let request = URLRequest(url: url)
    let (data, _) = try await URLSession.shared.data(for: request)
    let decoder = JSONDecoder()
    
    return try decoder.decode([T].self, from: data)
}

struct Failure: Decodable { // this doesn't need to be Decodable I think
    let time: Int
    let altitude: Int?
    let reason: String
}

struct Launch: Decodable, Identifiable {
    let rocket: String
    let success: Bool?
    let failures: [Failure]
    let details: String?
    let launchpad: String
    let name: String
    let date_local: String
    let launch_library_id: String?
    let id: String
}


struct Rocket: Decodable {
    let id: String
    let name: String
}
