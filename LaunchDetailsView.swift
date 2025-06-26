import Foundation
import SwiftUI
import YouTubeKit

// Gives full launch info. Accessed when a list item is clicked

struct LaunchDetailsView: View {
    @EnvironmentObject var dataHolder: DataHolder
    @EnvironmentObject var youTubeData: YouTubeData
    
    let launch: Launch
    
    init(_ launch: Launch) {
        self.launch = launch
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
                if let linkWiki = launch.links.wikipedia {
                    Text("Wikipedia link: \(linkWiki)")
                }
                
                Spacer()
                
                if let linkWeb = launch.links.webcast {
                    Text("Youtube link: \(linkWeb)")
                }
            
                if let imageLinkYT = youTubeData.thumbnail {
                    AsyncImage(url: URL(string: imageLinkYT)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {}
                        .frame(width: 180, height: 180)
                }
            
            }
            .onAppear {
                if let linkWeb = launch.links.webcast {
                    youTubeData.requestImage(from: linkWeb)
                }
            }
        }
    }
}
