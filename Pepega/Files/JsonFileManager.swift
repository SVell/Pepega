//
//  JsonFileManager.swift
//  Pepega
//
//  Created by SVell on 12.03.2023.
//

import Foundation

class JsonFileManager {
    func saveToJsonFile(arr: [Post]) {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let fileURL = directory.appendingPathComponent("Info.json")
        
        guard let data = try? JSONEncoder().encode(arr) else {
            return
        }
        
        do {
            try data.write(to: fileURL, options: [])
            print("Saved successfully.")
        } catch {
            print("Error saving file: \(error.localizedDescription)")
        }
    }
    
    func parse(data: Data) -> Post? {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let post = try decoder.decode(Post.self, from: data)
            return post
        } catch {
            print("Error parsing data: \(error.localizedDescription)")
            return nil
        }
    }
}
