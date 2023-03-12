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

class PostTableViewController: UITableViewController, UITextFieldDelegate {
    
    
    
    // Array of posts to display
    var posts: [Post] = []
    var savedPosts: Array<Post> = []
    var filteredItems: Array<Post> = []
    
    // Button used for filtering posts
    var filterButton = UIButton()
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self
        
        // Set title to subreddit name
        self.titleLabel.text = "/r/\(subreddit)"
        
        // Set up filter button with images and tint color
        filterButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        filterButton.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        self.filterButton.addTarget(self, action: #selector(self.showSaved), for: .touchUpInside)
        filterButton.tintColor = UIColor.systemPurple
        
        
        // Set filter button as right bar button item
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: filterButton)
        
        // Register for notification when new posts are available
        NotificationCenter.default.addObserver(self, selector: #selector(loadPosts), name: notify, object: nil)
        
        searchTextField.delegate = self
        searchTextField.isHidden = true
        searchTextField.becomeFirstResponder()
        
        // Make initial request for posts
        Info().request()
        loadSaved()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // perform the search and update the table view with the results
            
            if let searchText = textField.text {
                filteredItems = savedPosts.filter({ $0.title.lowercased().contains(searchText.lowercased()) })
                tableView.reloadData()
            }
            
            textField.resignFirstResponder()
            return true
        }
    
    @objc
    func showSaved(){
        filteredItems.removeAll()
        searchTextField.text = ""
        searchTextField.isHidden = !searchTextField.isHidden;
        filterButton.isSelected = !filterButton.isSelected
        loadSaved()
    }
    
    func loadSaved() {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        let fileURL = documentsURL.appendingPathComponent("Info.json")

        guard let data = try? Data(contentsOf: fileURL) else {
            return
        }

        do {
            savedPosts = try JSONDecoder().decode([Post].self, from: data)
            PostRequestManager.shared.updateSaved(savedNew: savedPosts)
            print(savedPosts)
            tableView.reloadData()
        } catch {
            print(error)
        }
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
        if(filteredItems.count > 0){
            return filteredItems.count
        }
        if filterButton.isSelected {
            return savedPosts.count
        }
        else {
            return posts.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.reuseIdentifier, for: indexPath) as! PostTableViewCell
        
        if(filteredItems.count > 0){
            cell.configure(for: filteredItems[indexPath.row], table: self)
            cell.saveButton.tag = indexPath.row
            return cell
        }
        
        if filterButton.isSelected {
            cell.configure(for: savedPosts[indexPath.row], table: self)
            cell.saveButton.tag = indexPath.row
        }
        else{
            cell.configure(for: posts[indexPath.row], table: self)
            cell.saveButton.tag = indexPath.row
        }
        
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
                
                if (filterButton.isSelected) {
                    info.normalize(data: savedPosts[indexPath])
                }
                else {
                info.normalize(data: posts[indexPath])
                }
            }
        default:
            break
        }
    }
    
    func shareLink(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }

        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        // Set the excluded activity types if desired
        activityViewController.excludedActivityTypes = [.addToReadingList, .assignToContact]
        
        // Present the activity view controller
        if let presenter = UIApplication.shared.keyWindow?.rootViewController {
            presenter.present(activityViewController, animated: true, completion: nil)
        }
    }
}

