//
//  File 2.swift
//  SpaceXNetwork
//
//  Created by David Tudor on 12/05/2025.
//

import Foundation
import SwiftUI

struct ListItemView: View {
    let launch: Launch
    let rocketData: [Rocket]
    
    let cornerSize = 15
    let colGreen: UInt = 0xb3e6b3
    let colRed: UInt = 0xff8080
    
    init(_ launch: Launch, _ rocketData: [Rocket]) {
        self.launch = launch
        self.rocketData = rocketData
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
            
            LaunchInfoView(launch, rocketData)
            
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
