//
//  ViewController.swift
//  WatchNow
//
//  Created by Trakya12 on 8.05.2025.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var videos: [VideoItem] = []

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    // Kaç satır gösterilecek
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count // Şimdilik örnek olarak 10
    }

    // Her hücrede ne gösterilecek
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as? VideoCell else {
            return UITableViewCell()
        }

        let video = videos[indexPath.row]
        
        cell.titleLabel.text = video.snippet.title
        cell.channelLabel.text = video.snippet.channelTitle ?? ""
        cell.thumbnailImageView.image = nil

        if let url = URL(string: video.snippet.thumbnails.medium.url) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.thumbnailImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }

        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedVideo = videos[indexPath.row]
        
        guard let videoId = selectedVideo.id.videoId else { return }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let playerVC = storyboard.instantiateViewController(withIdentifier: "VideoPlayerViewController") as? VideoPlayerViewController {
            playerVC.videoId = videoId
            navigationController?.pushViewController(playerVC, animated: true)
        }
    }


    
    func searchYouTube(for query: String) {
        let apiKey = "API_KEY"
        let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&maxResults=10&q=\(queryEncoded)&key=\(apiKey)"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Hata: \(error.localizedDescription)")
                return
            }

            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode(YouTubeSearchResponse.self, from: data)
                self.videos = result.items

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("❌ JSON Çözümleme Hatası: \(error)")
            }
        }.resume()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        searchYouTube(for: text)
        searchBar.resignFirstResponder()
    }


}

