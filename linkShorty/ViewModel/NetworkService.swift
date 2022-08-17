//
//  NetworkService.swift
//  linkShorty
//
//  Created by Amin  Bagheri  on 2022-08-14.
//

import Foundation
import Combine

// {"status": 201, "message": "Added!", "short": "xpvdm", "long": "https://tilburguniversity.edu"}

//https://api.1pt.co/addURL?long=[ADD URL HERE]

enum CustomError: Error {
    case invalidURL
}

class WebService {
    
    // MARK: API key: 4c4c8deb28d77d3bd328f0b9ec543be1
    
    private init() {}
    static let shared = WebService()
    
    var urls: [URLResponse] = []
    
    func getURL(userUrl: String) async throws -> URLResponse? {
        guard URL(string: userUrl) != nil else {
            print("Url isnt formatted properly")
            return nil
        }
        guard let apiUrl = URL(string: "https://cutt.ly/api/api.php?key=4c4c8deb28d77d3bd328f0b9ec543be1&short="+userUrl) else {
            print("Url count be formed with 1pt")
            return nil
        }
        let urlRequest = URLRequest(url: apiUrl)
        //the acutal url request. much more simple and beautiful
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        print("Response is not successful. Status code is not 200")
            print((response as? HTTPURLResponse)?.statusCode)
            return nil
        }
        
        let returnedUrlModel = try JSONDecoder().decode(URLResponse.self, from: data)
        
        self.urls.append(returnedUrlModel)
        return returnedUrlModel
    }
    
}
