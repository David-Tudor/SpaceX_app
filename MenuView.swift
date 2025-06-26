import Foundation
import SwiftUI

// Makes the filter menu view.

struct MenuView: View {
    @EnvironmentObject var dataHolder: DataHolder
    
    var body: some View {
        Menu {
            
            Button("Refresh") {
                Task(priority: .high) {
                    await dataHolder.pullData()
                }
            }
            Divider()
            
            Toggle("Successful rockets only", isOn: $dataHolder.should_only_show_successes)
            Divider()
            
            VStack {
                Text("Number of launches shown:")
                HStack {
                    Slider( // XXX Why does this look weird?
                        value: $dataHolder.numLaunchesShown,
                        in:    1...20,
                        step: 1,
                    )
                    Text("\(Int(dataHolder.numLaunchesShown))")
                }
                
                
            }
            
        } label: {
            Image(systemName: "gear")
                .font(.system(size: 24))
        }
    }
}
