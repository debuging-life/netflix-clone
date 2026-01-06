//
//  YouTubeView.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 05/01/26.
//

import SwiftUI
import YouTubePlayerKit

struct YouTubeView: View {
    var youtubePlayer: YouTubePlayer = ""
   
    init (youtubeID: String) {
        self.youtubePlayer = YouTubePlayer(
            source: .video(id: youtubeID),
            parameters: .init(
                autoPlay: true,
                loopEnabled: true,
                showControls: true,
                showFullscreenButton: true
            )
        )
    }
    
    var body: some View {
        YouTubePlayerView(self.youtubePlayer) { state in
            switch state {
            case .idle:
                ProgressView()
            case .ready:
                EmptyView()
            case .error(let error):
                ContentUnavailableView(
                    "Error",
                    systemImage: "exclamationmark.triangle.fill",
                    description: Text("Youtube vidoe cannot play \(error.localizedDescription)")
                )
            }
            
        }
    }
}

#Preview {
    YouTubeView(youtubeID: "")
}
