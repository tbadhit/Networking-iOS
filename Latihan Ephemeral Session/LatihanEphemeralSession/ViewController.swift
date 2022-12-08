//
//  ViewController.swift
//  LatihanEphemeralSession
//
//  Created by Tubagus Adhitya Permana on 17/10/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lable: UILabel!
    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadImage()
    }

    
    private func downloadImage() {
        let path = "https://www.dicoding.com/blog/wp-content/uploads/2017/10/dicoding-logo-square.png"
        
        let url = URL(string: path)
        
        // Dengan menggunakan .ephemeral proses caching ke disk tidak terjadi dan URLSession akan selalu mengunduh gambar setiap kali kita membuka aplikasi
        
        let configuration = URLSessionConfiguration.ephemeral
        
        let session = URLSession(configuration: configuration)
        
        if let response = configuration.urlCache?.cachedResponse(for: URLRequest(url: url!)) {
            lable.text = "Use cache image"
            image.image = UIImage(data: response.data)
        } else {
            lable.text = "Call Image From Network"
            // ketika tidak ada data dalam cache, buat task untuk mengunduh gambar dengan URL yang ada.
            let downloadTask = session.dataTask(with: url!) { [weak self] data , response, error in
                guard let self = self, let data  = data else {return}
                
                // gunakan DispatchQueue untuk menampilkan gambar di thread utama
                DispatchQueue.main.async {
                    self.image.image = UIImage(data: data)
                    print("Image", UIImage(data: data))
                }
            }
            
            downloadTask.resume()
        }
    }

}

