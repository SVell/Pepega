//
//  PostRequestManager.swift
//  Pepega
//
//  Created by SVell on 05.03.2023.
//

import Foundation

class PostRequestManager {
    static let shared = PostRequestManager()
    private init() {}
    
    private(set) var info = [Post]()
  
    func add(post: Post) {
        info.append(post)
    }
    
    func getInfo() -> [Post] {
        return info
    }
}

    
