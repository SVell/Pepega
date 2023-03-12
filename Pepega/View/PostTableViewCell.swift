//
//  PostTableViewCell.swift
//  Pepega
//
//  Created by SVell on 05.03.2023.
//

import UIKit
import SDWebImage

class PostTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "postCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var authorL: UILabel!
    @IBOutlet private weak var timeL: UILabel!
    @IBOutlet private weak var domainL: UILabel!
    @IBOutlet private weak var numcommentsL: UILabel!
    @IBOutlet private weak var ratingL: UILabel!
    @IBOutlet private weak var titleL: UITextView!
    @IBOutlet private weak var shareL: UIButton!
    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    var tableView :PostTableViewController?
    
    var url: String = ""

    
    // MARK: - Lifecycle methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorL.text = nil
        timeL.text = nil
        domainL.text = nil
        numcommentsL.text = nil
        ratingL.text = nil
        titleL.text = nil
        imgView.image = nil
        url = ""
        
        
        saveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
    }
    
    // MARK: - Public methods
    
    func configure(for post: Post, table: PostTableViewController) {
            let timeString = self.getTimeString(from: TimeInterval(post.created_utc))
            self.authorL.text = post.author
            self.timeL.text = timeString
            self.domainL.text = post.domain
            self.titleL.text = post.title
            self.ratingL.text = "\(post.ups - post.downs)"
            self.numcommentsL.text = "\(post.num_comments)"
            self.imgView.sd_setImage(with: URL(string: post.url), placeholderImage: UIImage())
            // self.saveButton.addTarget(self, action: #selector(self.saveButtonAction), for: .touchUpInside)
        
        url = post.url
            
            self.saveButton.isSelected = PostRequestManager.shared.getSaved().firstIndex(where: { $0.title == post.title }) != nil
        
        tableView = table
    }
    
    // MARK: - Private methods
    
    private func getTimeString(from timestamp: TimeInterval) -> String {
        let now = Date().timeIntervalSince1970
        let difference = Int(now - timestamp)
        let timeString: String
        
        switch difference {
        case ..<3600:
            timeString = "\(difference / 60)m"
        case ..<86400:
            timeString = "\(difference / 3600)h"
        case ..<2678400:
            timeString = "\(difference / 86400)d"
        case ..<31536000:
            timeString = "\(difference / 2678400)m"
        default:
            timeString = "\(difference / 31536000)y"
        }
        
        return timeString
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton){

            sender.isSelected = !sender.isSelected
            if(sender.isSelected){
                PostRequestManager.shared.save(title: self.titleL.text!)
            }
            if(!sender.isSelected){
                PostRequestManager.shared.remove(title: self.titleL.text!)
            }
        }
    
    @IBAction func openUrl(_ sender: UIButton){

        tableView?.shareLink(urlString: url)
        
    }
    
    
}


