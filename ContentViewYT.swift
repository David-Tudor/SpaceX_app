import SwiftUI
import YouTubeKit

struct ContentViewYT: View {
    var YTData = YouTubeData()
    var myUrl = "https://youtu.be/wcq7xiTOPRg"
    
    var body: some View {
        Text("Hello")
        Button {
            YTData.requestImage(from: myUrl)
        } label: {
            Text("Search")
        }

        
    }
}
