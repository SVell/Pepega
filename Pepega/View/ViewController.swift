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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func normalize(data: Post){
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



