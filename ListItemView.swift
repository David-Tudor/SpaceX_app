import Foundation
import SwiftUI

// Gives a small amount of information about the launch.

struct ListItemView: View {
    @EnvironmentObject var dataHolder: DataHolder
    let launch: Launch
    
    let cornerSize = 15
    let colGreen: UInt = 0xb3e6b3
    let colRed: UInt = 0xff8080
    
    init(_ launch: Launch) {
        self.launch = launch
    }
    
    var body: some View {
        HStack {
            
            Group {
                // Get patch image
                if let imageLink = launch.links.patch.small {
                    AsyncImage(url: URL(string: imageLink)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {}
                    
                } else {
                    // If image doesn't exist, show a question mark.
                    Image(systemName: "questionmark.circle")
                        .symbolVariant(.circle)
                        .font(.system(size: 40))
                    
                }
            }
            .frame(width: 60, height: 60)
            
            LaunchInfoView(launch)
            
            // Show success or failure
            Image(systemName: launch.success == true ? "checkmark" : "xmark")
                .symbolVariant(.circle)
                .font(.system(size: 40))
            
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerSize: CGSize(width: cornerSize, height: cornerSize))
                .fill(Color(launch.success == true ? colGreen : colRed))
        )
    }
}
