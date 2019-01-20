//
//  HomeViewControllerFunctionsFile.swift
//  CafeNomad
//
//  Created by Albert on 2019/1/20.
//  Copyright © 2019 Albert.C. All rights reserved.
//

import Foundation
import UIKit

struct HomeViewControllerFunctionsFile {
    
    //MARK: Loading View
    static func showLoadingView(tabBarHeight tbh: CGFloat, navigationBarHeight nbh: CGFloat, fullScreenSize fss: CGRect, loadingView lv: UIView, superView: UIView){
        lv.frame.size = CGSize(width: fss.width, height: fss.height)
        lv.backgroundColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 0.3)
        superView.addSubview(lv)
        
    }
    
    static func hideLoadingView(loadingView lv: UIView){
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .preferredFramesPerSecond30, animations: {
            lv.alpha = 0
        }, completion: nil)
    }
    
    
    
}
