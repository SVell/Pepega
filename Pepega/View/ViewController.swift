//
//  ViewController.swift
//  Pepega
//
//  Created by SVell on 25.02.2023.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var titleLabel: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    var urlToShare = ""
    
    private var animatedBookmark: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.bookmarkAnimation))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delaysTouchesBegan = true

        self.postImage.addGestureRecognizer(doubleTap)
        self.postImage.isUserInteractionEnabled = true
        
        self.saveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        self.saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
    }
    
    func normalize(data: Post){
        self.urlToShare = data.url
        
        DispatchQueue.main.async {
            
            let now = Date().timeIntervalSince1970
            let difference = TimeInterval(now - Double(data.created_utc))
            let time = self.timeString(for: difference)
            
            self.authorLabel?.text = data.author
            self.timeLabel?.text = time
            self.domainLabel?.text = data.domain
            self.titleLabel?.text = data.title
            self.ratingLabel?.text = String(data.ups - data.downs)
            self.commentsLabel?.text = String(data.num_comments)
            self.postImage.sd_setImage(with: URL(string: data.url), placeholderImage: UIImage())
            self.saveButton?.isSelected = PostRequestManager.shared.getSaved().firstIndex(where: { $0.title == data.title }) != nil
            
            
            self.urlToShare = data.url
        }
    }
    
    @IBAction func saveButton(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        if(sender.isSelected){
            PostRequestManager.shared.save(title: titleLabel.text!)
        }
        if(!sender.isSelected){
            PostRequestManager.shared.remove(title: titleLabel.text!)
        }
    }
    
    @IBAction func shareLink(_ sender: UIButton) {
        guard let url = URL(string: urlToShare) else {
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
    
    @objc func bookmarkAnimation() {
        
        animatedBookmark = Utils.bookmarkIconViewCell(for: self.postImage, isSaved: !saveButton.isSelected)
        self.animatedBookmark?.frame.origin.x = self.postImage.center.x - 12;
        self.animatedBookmark?.frame.origin.y = self.view.center.y - 10;
        self.view.addSubview(self.animatedBookmark!)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            UIView.transition(
                with: self.view,
                duration: 1,
                options: .transitionCrossDissolve
            ) {
                self.animatedBookmark?.isHidden = false
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    UIView.transition(
                        with: self.view,
                        duration: 1,
                        options: .transitionCrossDissolve
                    ) {
                        self.animatedBookmark?.isHidden = true
                    }
                    
                }
            }
            
        }
        
        DispatchQueue.main.async {
            
            
            self.saveButton.isSelected = !self.saveButton.isSelected
            if(self.saveButton.isSelected){
                PostRequestManager.shared.save(title: self.titleLabel.text!)
            }
            if(!self.saveButton.isSelected){
                PostRequestManager.shared.remove(title: self.titleLabel.text!)
            }
        }
        
    }
    
    private func timeString(for timeInterval: TimeInterval) -> String {
        let minute: TimeInterval = 60
        let hour = 60 * minute
        let day = 24 * hour
        let month = 30 * day
        let year = 12 * month
        
        switch timeInterval {
        case ..<minute:
            let seconds = Int(timeInterval)
            return "\(seconds)s"
        case ..<hour:
            let minutes = Int(timeInterval / minute)
            return "\(minutes)m"
        case ..<day:
            let hours = Int(timeInterval / hour)
            return "\(hours)h"
        case ..<month:
            let days = Int(timeInterval / day)
            return "\(days)d"
        case ..<year:
            let months = Int(timeInterval / month)
            return "\(months)mo"
        default:
            let years = Int(timeInterval / year)
            return "\(years)y"
        }
    }
}



