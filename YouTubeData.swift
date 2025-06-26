//
//  File.swift
//  SpaceXNetwork
//
//  Created by David Tudor on 25/06/2025.
//

import Foundation
import YouTubeKit


class YouTubeData: ObservableObject {
    @Published var thumbnail: String?
    let YTM = YouTubeModel()
    
    func requestImage(from text: String)  {
        Task {
            await MainActor.run {
                self.thumbnail = nil
            }
            let (result, _) = await SearchResponse.sendRequest(youtubeModel: YTM, data: [.query : text])
            
            if let searchResults = result?.results {
                if let video = searchResults.first as? YTVideo {
                    if let thumbnail = video.thumbnails.first {
                        await MainActor.run {
                            self.thumbnail = thumbnail.url.absoluteString
                        }
                    }
                }
            }
        }
    }
}
