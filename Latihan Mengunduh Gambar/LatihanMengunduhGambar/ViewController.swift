//
//  ViewController.swift
//  LatihanMengunduhGambar
//
//  Created by Tubagus Adhitya Permana on 05/10/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var movieTableView: UITableView!
    // digunakan sebagai wadah/kontainer dari antrean operation :
    private let pendingOperations = PendingOperations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.dataSource = self
        movieTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "movieTableViewCell")
    }
    
    // fungsi ini akan memastikan kembali bahwa state dalam movie bernilai ".new", ketika kondisi terpenuhi, kode melakukan pemanggilan function startDownload()
    fileprivate func startOperations(movie: Movie, indexPath: IndexPath) {
        if movie.state == .new {
            startDownload(movie: movie, indexPath: indexPath)
        }
    }
    
    fileprivate func startDownload(movie: Movie, indexPath: IndexPath) {
        guard pendingOperations.downloadInProgress[indexPath] == nil else {return}
        
        let downloader = ImageDownloader(movie: movie)
        
        // Completion Block bisa disebut juga dengan callback untuk menghubungkan satu thread ke thread lainnya (thread dependency).
        downloader.completionBlock = {
            if downloader.isCancelled {return}
            DispatchQueue.main.async {
                // saat operation selesai, kode menghapus operation sesuai dengan indeksnya dan memperbarui row/baris pada indeks tersebut :
                self.pendingOperations.downloadInProgress.removeValue(forKey: indexPath)
                self.movieTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        // Dengan begitu, operation downloader bisa dimasukkan dalam antrean :
        pendingOperations.downloadInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
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
                startOperations(movie: movie, indexPath: indexPath)
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

// Menghentikan proses atau suspend saat pengguna melakukan scrolling dalam TableView :
extension ViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        toggleSuspendOperations(isSuspend: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        toggleSuspendOperations(isSuspend: false)
    }
    
    // saat pengguna melakukan scroll/gulir dalam TableView, toggleSuspendOperations dijalankan
    fileprivate func toggleSuspendOperations(isSuspend: Bool) {
        pendingOperations.downloadQueue.isSuspended = isSuspend
    }
    
    // Kemudian ketika pengguna menghentikan scroll/gulir, aplikasi melanjutkan proses unduh gambar
}

