//
//  PostListViewController.swift
//  Pepega
//
//  Created by SVell on 05.03.2023.
//

import UIKit

let notify = Notification.Name("123")
 let toNextScreenIdentifier = "toNextScreen"
var val = 5

class PostTableViewController: UITableViewController {
    
    // Array of posts to display
    var posts: [Post] = []
    
    // Button used for filtering posts
    var filterButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self
        
        // Set title to subreddit name
        self.title = "/r/\(subreddit)"
        
        // Set up filter button with images and tint color
        filterButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        filterButton.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        filterButton.tintColor = UIColor.systemGreen
        
        // Set filter button as right bar button item
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: filterButton)
        
        // Register for notification when new posts are available
        NotificationCenter.default.addObserver(self, selector: #selector(loadPosts), name: notify, object: nil)
        
        // Make initial request for posts
        Info().request()
    }
        
    @objc func loadPosts() {
        let post = Info().getData()
        var i = 0
        while i < val {
            posts.append(post[i])
            i += 1
        }
        
        // Reload table view on main thread
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.reuseIdentifier, for: indexPath) as! PostTableViewCell
        
        // Configure cell with data from post at index path
        cell.configure(for: posts[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row and perform segue to next screen
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: toNextScreenIdentifier, sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == posts.count - 1 {
            // Load more posts if not at limit
            let post = Info().getData()
            if posts.count < limit {
                var i = posts.count
                val += 5
                while i < val {
                    posts.append(post[i])
                    i += 1
                }
                
                // Reload table view after delay to allow for loading indicator to appear
                self.perform(#selector(loadTable), with: nil, afterDelay: 1.0)
            }
        }
    }
    
    @objc func loadTable() {
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case toNextScreenIdentifier:
            if let indexPath = (sender as? IndexPath)?.row {
                // Pass data from selected post to next view controller
                let info = segue.destination as! ViewController
                info.normalize(data: posts[indexPath])
            }
        default:
            break
        }
    }
}

