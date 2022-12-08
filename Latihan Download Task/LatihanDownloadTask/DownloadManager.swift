//
//  DownloadManager.swift
//  LatihanDownloadTask
//
//  Created by Tubagus Adhitya Permana on 17/10/22.
//

import UIKit

// kenapa harus dibuat singleton? Umumnya, kode yang digunakan untuk mengunduh file dengan tipe .background dibuat singleton karena kita tidak bisa mengubah delegasi yang sudah dibuat ketika objek URLSession selesai di-inisialisasi. Delegasi diperlukan untuk melakukan tracking selama proses mengunduh. Dengan dibuat secara singleton, kita bisa tetap melakukan tracking ke object URLSession dan juga delegasinya karena kode tersebut bisa diakses dari mana saja.

// mengapa harus menggunakan delegasi dan tidak menggunakan completion handler? Satu hal penting yang harus diingat, alasan kita menggunakan delegasi untuk mengamati proses unduh adalah karena completion handler tidak didukung di mode background.
class DownloadManager: NSObject {
    static var shared = DownloadManager()
    
    var progress: ((Int64, Int64) -> ())?
    var completed: ((URL) -> ())?
    var downloadError: ((URLSessionTask, Error?) -> ())?
    
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "com.dicoding.downloadTask")
        config.isDiscretionary = false
        return URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
    }()
}

extension DownloadManager: URLSessionDelegate, URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if totalBytesExpectedToWrite > 0 {
            progress?(totalBytesWritten, totalBytesExpectedToWrite)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        completed?(location)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        downloadError?(task, error)
    }
    
}


