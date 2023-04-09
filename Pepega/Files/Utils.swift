//
//  Utils.swift
//  Pepega
//
//  Created by SVell on 17.03.2023.
//

import Foundation
import UIKit

class Utils{
    static let shared = Utils()
    
    static func bookmarkIconViewCell(for imageView: UIImageView, isSaved: Bool) -> UIView{

        let bookmarkLayer = CALayer()
        bookmarkLayer.bounds = CGRect(x: imageView.center.x, y: imageView.center.y, width: 50, height: 40)

        let view = UIView()

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 5, y: 0))
        path.addLine(to: CGPoint(x: 25, y: 0))
        path.addLine(to: CGPoint(x: 30, y: 5))
        path.addLine(to: CGPoint(x: 30, y: 35))
        path.addLine(to: CGPoint(x: 15, y: 25))
        path.addLine(to: CGPoint(x: 0, y: 35))
        path.addLine(to: CGPoint(x: 0, y: 5))
        path.close()


        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
                
        shapeLayer.fillColor = isSaved ? UIColor.green.cgColor : UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.lineWidth = 2
         
        shapeLayer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
                
        view.layer.addSublayer(shapeLayer)
        view.isHidden = true
           
        return view
        }
}
