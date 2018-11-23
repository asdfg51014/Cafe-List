//
//  CafeAnnotationView.swift
//  CafeNomad
//
//  Created by Albert on 2018/11/6.
//  Copyright © 2018 Albert.C. All rights reserved.
//

import Foundation
import MapKit



class CafeAnnotationView: MKMarkerAnnotationView {
    
    static let ReuseID = "cafeAnnotation"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "cafeShop"
        
        displayPriority = .defaultHigh
        markerTintColor = UIColor(red: 194/255, green: 147/255, blue: 88/255, alpha: 1)
        glyphImage = UIImage(named: "mapIcon20")
        selectedGlyphImage = UIImage(named: "mapIcon40")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
}
