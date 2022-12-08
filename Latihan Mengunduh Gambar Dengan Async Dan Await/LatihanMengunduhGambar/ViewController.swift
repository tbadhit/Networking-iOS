//
//  ViewController.swift
//  LatihanMengunduhGambar
//
//  Created by Tubagus Adhitya Permana on 05/10/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var movieTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.dataSource = self
        movieTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "movieTableViewCell")
    }
    
    fileprivate func startDownload(movie: Movie, indexPath: IndexPath) {
        let imageDownloader = ImageDownloader()
        
        if movie.state == .new {
            // Task digunakan untuk menjalankan proses asynchronous dalam function synchronous
            Task {
                do {
                    let image = try await imageDownloader.downloadImage(url: movie.poster)
                    movie.state = .downloaded
                    movie.image = image
                    self.movieTableView.reloadRows(at: [indexPath], with: .automatic)
                } catch {
                    movie.state = .failed
                    movie.image = nil
                }
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "movieTableViewCell", for: indexPath) as? MovieTableViewCell {
            let movie = movies[indexPath.row]
            cell.movieTitle.text = movie.title
            
            cell.movieImage.image = movie.image
            
            if movie.state == .new {
                cell.indicatorLoading.isHidden = false
                cell.indicatorLoading.startAnimating()
                // fungsi yang menjalankan proses pengunduhan
                startDownload(movie: movie, indexPath: indexPath)
            } else {
                cell.indicatorLoading.stopAnimating()
                cell.indicatorLoading.isHidden = true
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
}

