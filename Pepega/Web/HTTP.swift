//
//  HTTP.swift
//  Pepega
//
//  Created by SVell on 25.02.2023.
//

import Foundation

struct Response : Codable{
 var data : DataStruct
    struct DataStruct : Codable {
        var children : [ItemStruct]
        struct ItemStruct: Codable {
            var data : ItemDataStruct
            struct ItemDataStruct:Codable{
                var author:String
                var domain:String
                var created_utc:Double
                var title:String
                var url:String
                var ups:Int
                var downs:Int
                var num_comments:Int
              
            }
        }
    }
}

struct Post:Codable{
           var author:String
           var domain:String
           var created_utc:Double
           var title:String
           var url:String
           var ups:Int
           var downs:Int
           var num_comments:Int
           var isSaved:Bool
    init(_ post: Response.DataStruct.ItemStruct.ItemDataStruct) {
            self.author = post.author
            self.domain = post.domain
            self.created_utc = (post.created_utc)
            self.title = post.title
            self.url = post.url
            self.ups = post.ups
            self.downs = post.downs
            self.num_comments = (post.num_comments)
            self.isSaved = false
        }
        
}

class Repository{
    static func parse(data:Data) -> Post?{
        do{
            let result = try JSONDecoder().decode(Post.self, from: data)
            return result
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
    }
    
}

class HTTPService {
    private class HTTPRequester {
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
    
    static func requestService(subreddit: String,listing: String, limit: Int?, after: String?){
        HTTPRequester.request(url: buildLink(subreddit: subreddit, listing: listing, limit: limit, after: after), completionHandler:{ data in
            if let data = data{
                if let info = try? JSONDecoder().decode(Response.self, from: data){
                    for element in info.data.children{
                        PostRequestManager.shared.add(post: Post(element.data))
                    }
                    
                    NotificationCenter.default.post(Notification(name: notify))
                }
                else{
                    print("Error")
                }
            }
        })
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

