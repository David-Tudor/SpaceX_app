import SwiftUI
import YouTubeKit

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
    @StateObject var dataHolder = DataHolder()
    @StateObject var youTubeData = YouTubeData()
    
    let dateFormatter = ISO8601DateFormatter()
    
    // colours
    let cornerSize = 15
    let biggerText: CGFloat = 18
    let smallerText: CGFloat = 16
//    let colBlack: UInt = 0x000000
//    let colGrey: UInt = 0x4A4A4D
    
    var filteredLaunchData: [Launch] {
        var temp_data = dataHolder.launchData
        if dataHolder.should_only_show_successes {
            temp_data = temp_data.filter { $0.success == true }
        }
        return temp_data.suffix(Int(dataHolder.numLaunchesShown)) // return only the x most recent (bottom of the list)
    }
    
    var body: some View {
        // Keep trying to pull data while any are unfilled.
        Group {
            if dataHolder.isLoading {
                ProgressView()
                
            } else if !dataHolder.error.isEmpty {
                Text(dataHolder.error)
                    .foregroundColor(.red)
                Button("Retry") {
                    Task(priority: .high) {
                        await dataHolder.pullData()
                    }
                }
                
            } else {
                
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
                            CompanyTextView()
                            
                            // Launch list
                            SectionTitleView(saying: "Launches")
                            
                            
                            VStack {
                                ForEach(0..<filteredLaunchData.count, id: \.self) { i in
                                    let launchFromList = filteredLaunchData.reversed()[i]
                                    NavigationLink(destination: LaunchDetailsView(launchFromList)) {
                                        ListItemView(launchFromList) // reversed so recent ones at the top
                                    }
                                    
                                
                                }
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .toolbar(content: {
                        ToolbarItem(placement: .topBarTrailing) {
                            MenuView()
                        }
                    })
                }
                .padding(10)
            }
        }
        .environmentObject(dataHolder)
        .environmentObject(youTubeData)
        .task(priority: .high) {
            await dataHolder.pullData()
        }
    }
}
