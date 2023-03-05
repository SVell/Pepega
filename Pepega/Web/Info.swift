//
//  Info.swift
//  Pepega
//
//  Created by SVell on 05.03.2023.
//

import Foundation
let subreddit = "gaming"
let limit = 50

class Info{

    func request() {
        HTTPService.requestService(subreddit: subreddit, listing: "top", limit: limit, after: nil)

    }
    
    func getData() -> Array<Post>{
        PostRequestManager.shared.getInfo()
    }
}

