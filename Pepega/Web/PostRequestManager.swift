//
//  PostRequestManager.swift
//  Pepega
//
//  Created by SVell on 25.02.2023.
//

import Foundation

class PostRequestManager{

    static func getPostsInfo(subreddit: String,limit: Int?,completion:@escaping (SavedResponse)->Void){
        Repository.getInfo(subreddit:subreddit,limit:limit, completion:{(success)->Void in
            if success{
                if let res = Repository.parse(data: HTTPManager.shared.cache){
                   completion(normalizeResponse(data: res))
            }
            }
            else {
                print("Error")
            }
        })
}
    
    static func normalizeResponse(data: Response) -> SavedResponse {
        let posts = data.data.children.compactMap { post -> SavedResponse.Post? in
            guard let mirror = Mirror(reflecting: post.data) as? Mirror else {
                return nil
            }
            
            var npost = SavedResponse.Post(
                author: "",
                domain: "",
                created_utc: 0,
                title: "",
                url: "",
                ups: 0,
                downs: 0,
                num_comments: 0,
                isSaved: false
            )
            
            for info in mirror.children {
                switch info.label {
                case "author":
                    npost.author = info.value as? String ?? ""
                case "domain":
                    npost.domain = info.value as? String ?? ""
                case "created_utc":
                    npost.created_utc = info.value as? Int ?? 0
                case "title":
                    npost.title = info.value as? String ?? ""
                case "url":
                    npost.url = info.value as? String ?? ""
                case "ups":
                    npost.ups = info.value as? Int ?? 0
                case "downs":
                    npost.downs = info.value as? Int ?? 0
                case "num_comments":
                    npost.num_comments = info.value as? Int ?? 0
                default:
                    print("Undefined")
                }
            }
            return npost
        }
        return SavedResponse(data: posts)
    }
}

