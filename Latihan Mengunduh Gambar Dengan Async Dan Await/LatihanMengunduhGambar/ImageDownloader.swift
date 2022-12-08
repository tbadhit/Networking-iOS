//
//  ImageDownloader.swift
//  LatihanMengunduhGambar
//
//  Created by Tubagus Adhitya Permana on 05/10/22.
//

import UIKit

// Kelas yang digunakan untuk mengunduh gambar dari alamat URL
class ImageDownloader {
    func downloadImage(url: URL) async throws -> UIImage {
        async let imageData: Data = try Data(contentsOf: url)
        return UIImage(data: try await imageData)!
    }
}
