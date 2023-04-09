//
//  Comments.swift
//  Pepega
//
//  Created by SVell on 09.04.2023.
//

import SwiftUI

struct RedditCommentsView: View {
    
    let redditPostURL: String
    
    @State private var comments: [RedditComment] = []
    @State private var isLoadingComments = false
    
    var body: some View {
        NavigationView {
            if isLoadingComments {
                ProgressView()
            } else if comments.isEmpty {
                Text("No comments found")
                    .foregroundColor(.secondary)
            } else {
                List(comments, id: \.id) { comment in
                    VStack(alignment: .leading) {
                        Text(comment.author)
                            .font(.headline)
                        Text(comment.body)
                            .font(.body)
                    }
                }
                .navigationTitle("Comments")
            }
        }
        .onAppear {
            loadComments()
        }
    }
    
    private func loadComments() {
        isLoadingComments = true
        
        guard let url = URL(string: "https://www.reddit.com\(redditPostURL).json") else {
            isLoadingComments = false
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            isLoadingComments = false
            
            if let error = error {
                print("Error loading comments: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data returned from server")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
                
                // Find the comment data
                let commentData = json?.last as? [String: Any]
                let commentArrayJSON = commentData?["data"] as? [String: Any]
                let commentListJSON = commentArrayJSON?["children"] as? [[String: Any]]
                
                let comments: [RedditComment] = commentListJSON?.compactMap { commentJSON in
                    guard let data = commentJSON["data"] as? [String: Any],
                          let id = data["id"] as? String,
                          let author = data["author"] as? String,
                          let body = data["body"] as? String else {
                        return nil
                    }
                    return RedditComment(id: id, author: author, body: body)
                } ?? []
                
                DispatchQueue.main.async {
                    self.comments = comments
                }
            } catch {
                print("Error parsing comment data: \(error.localizedDescription)")
            }
            
        }.resume()
    }
}

struct RedditComment: Identifiable {
    let id: String
    let author: String
    let body: String
}

struct RedditCommentsResponse: Decodable {
    let kind: String
    let data: RedditCommentsData
}

struct RedditCommentsData: Decodable {
    let children: [RedditCommentWrapper]
}

struct RedditCommentWrapper: Decodable {
    let data: RedditCommentData?
}

struct RedditCommentData: Decodable {
    let id: String
    let author: String
    let body: String
}


