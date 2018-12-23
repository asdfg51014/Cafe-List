//
//  ClusterAnnotationView.swift
//  CafeNomad
//
//  Created by Albert on 2018/11/6.
//  Copyright © 2018 Albert.C. All rights reserved.
//

import Foundation
import MapKit

class ClusterAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
//        displayPriority = .defaultHigh
        collisionMode = .circle
        canShowCallout = false
        centerOffset = CGPoint(x: 0.0, y: -10.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        if let custer = annotation as? MKClusterAnnotation {
            let cafeShopCount = custer.memberAnnotations.count
            
            image = drawCafeShop(count: cafeShopCount)
            displayPriority = .defaultLow
            canShowCallout = false
        }
        
    }
    
    private func drawCafeShop(count: Int) -> UIImage {
        return drawRatio(0, whole: count)
    }
    
    private func drawRatio(_ fraction: Int, whole: Int) -> UIImage {
        
        let cafeShop = UIGraphicsImageRenderer(size: CGSize(width: 30.0, height: 30.0))
        
        return cafeShop.image { _ in
            UIColor(red: 194/255, green: 147/255, blue: 88/255, alpha: 1).setFill()
            UIBezierPath(ovalIn: CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0)).fill()
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)]
            let text = "\(whole)"
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(x: 15 - size.width / 2, y: 15 - size.height / 2, width: size.width, height: size.height)
            text.draw(in: rect, withAttributes: attributes)
            
        }
    }
    
    
    
}

