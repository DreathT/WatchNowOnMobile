import Foundation

struct YouTubeSearchResponse: Codable {
    let items: [VideoItem]
}

struct VideoItem: Codable {
    let id: VideoID
    let snippet: Snippet
}

struct VideoID: Codable {
    let videoId: String?
}

struct Snippet: Codable {
    let title: String
    let description: String
    let thumbnails: ThumbnailInfo
    let channelTitle: String?
}

struct ThumbnailInfo: Codable {
    let medium: Thumbnail
}

struct Thumbnail: Codable {
    let url: String
}

