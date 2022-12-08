//
//  ImageDownloader.swift
//  LatihanMengunduhGambar
//
//  Created by Tubagus Adhitya Permana on 05/10/22.
//

import UIKit

// Kelas yang digunakan untuk mengunduh gambar dari alamat URL
class ImageDownloader: Operation {
    private let movie: Movie
    
    override func main() {
        if isCancelled {
            return
        }
        
        // kode untuk mengunduh gambar
        guard let imageData = try? Data(contentsOf: self.movie.poster) else {return}
        
        if isCancelled {
            return
        }
        
        if !imageData.isEmpty {
            self.movie.image = UIImage(data: imageData)
            self.movie.state = .downloaded
        } else {
            self.movie.image = nil
            self.movie.state = .failed
        }
    }
    
    init(movie: Movie) {
        self.movie = movie
    }
}

// Kelas ini untuk mengantrekan proses pengunduhan gambar (hanya mengizinakan antrean sebanyak 2, kalo lebih akan mengantri untuk di proses)
class PendingOperations {
    lazy var downloadInProgress: [IndexPath: Operation] = [:]
    
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "com.dicoding.imagedownload"
        queue.maxConcurrentOperationCount = 2
        return queue
    }()
}
