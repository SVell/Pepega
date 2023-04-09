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
    @State private var selectedComment: RedditComment? = nil
    
    var body: some View {
        NavigationView {
            if isLoadingComments {
                ProgressView()
            } else if comments.isEmpty {
                Text("No comments found")
                    .foregroundColor(.secondary)
            } else {
                List(comments, id: \.id) { comment in
                    NavigationLink(destination: CommentDetailView(comment: comment), tag: comment, selection: $selectedComment) {
                        VStack(alignment: .leading) {
                            Text(comment.author)
                                .font(.headline)
                            Text(comment.body)
                                .font(.body)
                        }
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
                print("Error loading comments")
                return
            }
            
            guard let data = data else {
                print("No data")
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
                          let body = data["body"] as? String,
                          let ups = data["ups"] as? Int,
                          let downs = data["downs"] as? Int else {
                        return nil
                    }
                    return RedditComment(id: id, author: author, body: body, ups: ups, downs: downs)
                } ?? []
                
                DispatchQueue.main.async {
                    self.comments = comments
                }
            } catch {
                print("Error parsing comment data")
            }
            
        }.resume()
    }
}

struct RedditComment: Identifiable, Hashable {
    let id: String
    let author: String
    let body: String
    let ups: Int
    let downs: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct CommentDetailView: View {
    
    let comment: RedditComment
    
    var body: some View {
        VStack {
            Text(comment.author)
                .font(.headline)
            Text(comment.body)
                .font(.body)
            Text("Upvotes: \(comment.ups)")
            Text("Downvotes: \(comment.downs)")
            Spacer()
            Button("Share") {
                let url = URL(string: "https://www.reddit.com\(comment.id)")!
                let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
            }
        }
        .padding()
        .navigationTitle("Comment")
    }
}


