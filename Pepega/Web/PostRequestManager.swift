//
//  PostRequestManager.swift
//  Pepega
//
//  Created by SVell on 05.03.2023.
//

import Foundation

class PostRequestManager {
    static var shared :  PostRequestManager = {
        let instance = PostRequestManager()
        return instance
    }()
    
    private init() {}
    
    var saved:Array<Post> = []
    var info:Array<Post> = []

    func updateSaved(savedNew: Array<Post>){
        saved = savedNew
    }
  
    func add (post : Post){
        info.append(post)
    }
    
    func remove(title:String){
        for element in (0..<saved.count){
            if(element >= 0 && element < saved.count){
                if saved[element].title == title{
                    saved[element].isSaved = false
                    saved.remove(at: element)
                    
                    print("remove")
                }
            }
        }
     savePosts(resp: saved)
         NotificationCenter.default.post(Notification(name: notify))
        
    }
    
func save (title:String){
    for element in (0..<info.count){
        if info[element].title == title && !saved.contains(info[element]) {
            info[element].isSaved = true
            saved.append(info[element])
        }
        
    }
     savePosts(resp: saved)

    NotificationCenter.default.post(Notification(name: notify))
}
    
    func getInfo()-> Array<Post>{
        return info
    }
    public func getSaved()->Array<Post>{
        return saved
    }
    
    
    func getDirectory() -> URL{
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                return directory!
    }
    
    func savePosts(resp: Array<Post>){
             JsonFileManager().saveToJsonFile(arr:resp)
        }
}

    
