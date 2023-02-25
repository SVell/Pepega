//
//  ViewController.swift
//  Pepega
//
//  Created by SVell on 25.02.2023.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var authorLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var domainLabel:UILabel!
    @IBOutlet weak var commentsLabel:UILabel!
    @IBOutlet weak var ratingLabel:UILabel!
    @IBOutlet weak var titleLabel:UITextView!
    @IBOutlet weak var shareButton:UIButton!
    @IBOutlet weak var saveButton:UIButton!
    @IBOutlet weak var postImage:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PostRequestManager.getPostsInfo(subreddit: "Pepe_Memes", limit: 1, completion: {(data) -> Void in
            DispatchQueue.main.async {

                let time = self.getTimeAgo(from: Date(timeIntervalSince1970: Double(data.data[0].created_utc)))
                
                self.authorLabel?.text = (data.data[0].author)
                self.timeLabel?.text = time
                self.domainLabel?.text = data.data[0].domain
                self.titleLabel?.text = data.data[0].title
                self.ratingLabel?.text = String((data.data[0].ups )-(data.data[0].downs ))
                self.commentsLabel?.text = String(data.data[0].num_comments )
                self.postImage?.sd_setImage(with: URL(string:data.data[0].url ), placeholderImage: UIImage())
                
            }
        })
    }
    
    func getTimeAgo(from date: Date) -> String {
        let now = Date()
        let difference = Int(now.timeIntervalSince(date))
        var time: String
        
        switch difference {
        case let diff where diff < 60:
            time = "\(diff)s"
        case let diff where diff < 3600:
            time = "\(diff/60)m"
        case let diff where diff < 86400:
            time = "\(diff/3600)h"
        case let diff where diff < 604800:
            time = "\(diff/86400)d"
        case let diff where diff < 2592000:
            time = "\(diff/604800)w"
        case let diff where diff < 31536000:
            time = "\(diff/2592000)m"
        default:
            time = "\(difference/31536000)y"
        }
        
        return "\(time) ago"
    }

    
    @IBAction func saveButtonFunc(){
        if((self.saveButton?.isSelected) != nil){
            self.saveButton?.isSelected = false
        } else{
            self.saveButton?.isSelected = true
        }
    }

}


