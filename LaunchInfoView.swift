import Foundation
import SwiftUI

// Make two columns with launch info.

struct LaunchInfoView: View {
    
    @EnvironmentObject var dataHolder: DataHolder
    let launch: Launch
    let dateFormatter = ISO8601DateFormatter()
    
    init(_ launch: Launch) {
        self.launch = launch
    }
    
    var body: some View { 
        HStack {
            VStack(alignment: .leading) {
                Text("Mission")
                Text("Date/time")
                Text("Rocket")
                Text("Time since")
                
            }
            
            
            VStack(alignment: .leading) {
                // Mission name
                Text("\(launch.name)")
                
                // Date
                if let date = dateFormatter.date(from: launch.date_local) {
                    Text("\(date.formatted(date: .numeric, time: .omitted))".padding(toLength: 20, withPad: " ", startingAt: 0) )
                    //                        .foregroundColor(Color(colGrey))
                    //                        .font(.system(size: smallerText, weight: .regular))
                    //    .fixedSize(horizontal: false, vertical: true) // makes it wrap
                }
                
                // Rocket
                if let rocket = dataHolder.rocketData.first(where: { item in item.id == launch.rocket}) {
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
            .padding(.horizontal, 15)
            .frame(height: 80)
        }
        .padding(.horizontal, 0)
    }
    
}
