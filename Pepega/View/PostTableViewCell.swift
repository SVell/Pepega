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
    }
    
    // MARK: - Public methods
    
    func configure(for post: Post) {
        let timeString = getTimeString(from: TimeInterval(post.created_utc))
        authorL.text = post.author
        timeL.text = timeString
        domainL.text = post.domain
        titleL.text = post.title
        ratingL.text = "\(post.ups - post.downs)"
        numcommentsL.text = "\(post.num_comments)"
        imgView.sd_setImage(with: URL(string: post.url), placeholderImage: UIImage())
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
}


