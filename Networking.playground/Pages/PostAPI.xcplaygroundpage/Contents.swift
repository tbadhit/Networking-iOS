//: [Previous](@previous)

import Foundation

struct Guest: Codable {
    let success: Bool
    let guestSessionId: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case guestSessionId = "guest_session_id"
    }
}

let apiKey = "19cbced6533950e6d8dfaa5c2aff6fa0"

// function URL untuk mendapatkan session id
func getGuestSessionId(completion: ((Guest) -> ())?) {
    let url = "https://api.themoviedb.org/3/authentication/guest_session/new"
    var components = URLComponents(string: url)!
    
    components.queryItems = [
        URLQueryItem(name: "api_key", value: apiKey)
    ]
    
    let request = URLRequest(url: components.url!)
    
    let task = URLSession.shared.dataTask(with: request) {data, response, error in
        guard let response = response as? HTTPURLResponse, let data = data else {return}
        
        if response.statusCode == 200 {
            let decoder = JSONDecoder()
            let response = try! decoder.decode(Guest.self, from: data)
            completion?(response)
        } else {
            print("ERROR: \(data), HTTP Status: \(response.statusCode)")
        }
    }
    
    task.resume()
}

struct ReviewRequest: Codable {
    let value: Double
}

// Memberikan rating dengan HTTP POST
getGuestSessionId { guest in
    var components = URLComponents(string: "https://api.themoviedb.org/3/movie/610150/rating")!
    
    components.queryItems = [
        URLQueryItem(name: "api_key", value: apiKey),
        URLQueryItem(name: "guest_session_id", value: guest.guestSessionId)
    ]
    
    var request = URLRequest(url: components.url!)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
//    let jsonRequest = [
//        "value": 9.0
//    ]
//      let jsonData = try! JSONSerialization.data(withJSONObject: jsonRequest, options: [])

    
    let reviewRequest = ReviewRequest(value: 9.0)
    let jsonData = try! JSONEncoder().encode(reviewRequest)
    
    
    let tast = URLSession.shared.uploadTask(with: request, from: jsonData) {data, response, error in
        guard let response = response as? HTTPURLResponse, let data = data else { return }
        
        if response.statusCode == 201 {
            print("Data: \(data)")
        }
    }
    
    tast.resume()
}
