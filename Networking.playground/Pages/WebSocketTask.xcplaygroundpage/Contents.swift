//: [Previous](@previous)

import UIKit
import Foundation

class WebSocketDelegate: NSObject, URLSessionWebSocketDelegate {
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
      ) {
        print("WebSocket open.")
      }
    
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
      ) {
        guard let theReason = String(data: reason!, encoding: .utf8) else { return }
        print("WebSocket closed with reason: \(theReason).")
      }
}

let delegate = WebSocketDelegate()
let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: OperationQueue())

let task  = session.webSocketTask(with: URL(string: "wss://movies-feed.dicoding.dev")!)

task.resume()

let hello = "Hello from dicoding"
let message = URLSessionWebSocketTask.Message.string(hello)

// kirim pesan
task.send(message) {error in
    if let error = error {
        print("WebSocket sending error: \(error)")
    }
    print("Sending message: \(hello)")
}

// Kirim ping buat ngasih tau server bahwa masih aktif
task.sendPing { error in
    if let error = error {
        print("Ping failed: \(error)")
    }
    print("Send ping")
}

// handler untuk menerima pesan balik dari server
task.receive { result in
    switch result {
      case let .failure(error):
        print("Failed to receive message: \(error)")
      case let .success(message):
        switch message {
        case let .string(text):
          print("Receive text message: \(text)")
        case let .data(data):
          print("Receive binary message: \(data)")
        default:
          print("Message unformatted")
        }
      }
    
    // tutup koneksi ke server dengan "reason: I'm going away".
    task.cancel(with: .goingAway, reason: "Im going away".data(using: .utf8))
}


