//
//  HTTP.swift
//  Pepega
//
//  Created by SVell on 25.02.2023.
//

import Foundation

struct Response: Decodable {
    var data: DataStruct
    
    struct DataStruct: Decodable {
        var children: [ItemStruct]
        
        struct ItemStruct: Decodable {
            var data: ItemDataStruct
            
            struct ItemDataStruct: Decodable {
                var author: String
                var domain: String
                var created_utc: Int
                var title: String
                var url: String
                var ups: Int
                var downs: Int
                var num_comments: Int
            }
        }
    }
}

struct SavedResponse {
    var data: [Post]
    
    struct Post: Decodable {
        var author: String
        var domain: String
        var created_utc: Int
        var title: String
        var url: String
        var ups: Int
        var downs: Int
        var num_comments: Int
        var isSaved: Bool
    }
}

class Repository {
    static func parse(data: Data) -> Response? {
        do {
            let result = try JSONDecoder().decode(Response.self, from: data)
            return result
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func getInfo(subreddit: String, limit: Int?, completion: @escaping (Bool) -> Void) {
        HTTPService.requestService(subreddit: subreddit, listing: "top", limit: limit, after: nil, completion: { success in
            if success {
                completion(true)
            } else {
                print("Error")
            }
        })
    }
}

struct HTTPService {
    static func buildLink(subreddit: String, listing: String, limit: Int?, after: String?) -> String {
        var link = "https://www.reddit.com/r/\(subreddit)/\(listing).json"
        if limit != nil || after != nil {
            link += "?"
            if limit != nil {
                link += "limit=\(limit!)"
            }
            if after != nil {
                link += "&after=\(after!)"
            }
        }
        return link
    }

    static func requestService(subreddit: String, listing: String, limit: Int?, after: String?, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: buildLink(subreddit: subreddit, listing: listing, limit: limit, after: after)) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                writeInfo(data: data, completion: { success in
                    if success {
                        completion(true)
                    } else {
                        print("Error")
                    }
                })
            }
        }
        task.resume()
    }
    
    static func writeInfo(data: Data, completion: (Bool) -> Void) {
        HTTPManager.shared.cache = data
        if HTTPManager.shared.cache != data {
            completion(false)
        } else {
            completion(true)
        }
    }
}

struct HTTPRequester {
    static func request(url: String, completionHandler: @escaping (Data?) -> Void) {
        guard let link = URL(string: url) else {
            return
        }
        let task = URLSession.shared.dataTask(with: link) { data, _, _ in
            if let data = data {
                completionHandler(data)
            }
        }
        task.resume()
    }
}

