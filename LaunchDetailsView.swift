//
//  File.swift
//  SpaceXNetwork
//
//  Created by David Tudor on 12/05/2025.
//

import Foundation
import SwiftUI


struct LaunchDetailsView: View {
    // When a launch is clicked, show some more information
    @EnvironmentObject var dataHolder: DataHolder
    let launch: Launch
//    let rocketData: [Rocket]
    
    init(_ launch: Launch) { // , _ rocketData: [Rocket]
        self.launch = launch
//        self.rocketData = rocketData
    }
    
    var body: some View {
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
            LaunchInfoView(launch)
            
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
}
