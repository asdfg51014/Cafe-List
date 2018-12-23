//
//  WalkthroughPageViewController.swift
//  CafeNomad
//
//  Created by Albert on 2018/11/27.
//  Copyright © 2018 Albert.C. All rights reserved.
//

import UIKit

protocol WalkthroughPageViewControllerDelegate: class {
    func didUpdatePageIndex(currentIndex: Int)
}


class WalkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    weak var walkthroughDelegate: WalkthroughPageViewControllerDelegate?
    
    var pageImages = ["page0", "page1", "page2", "page3"]
    
    var pageHeading = ["重設按鈕 及 條件篩選按鈕", "地點標示圖示", "儲存按鈕 及 取消儲存按鈕", "歡迎使用 Cafe List"]
    
    var pageSubHeading = ["重設按鈕可將 Cafe List 回復為尚未篩選的樣式\n篩選按鈕可以依條件篩選對 Cafe List 進行篩選", "在 Cafe Map 中點擊地點標示\n將會得到該咖啡店的簡易資訊", "在 Cafe List App 中\n將咖啡店做儲存或刪除", "現在點擊 START\n開始使用 Cafe List App 吧！"]
    
    var currentIndex = 0
    
    func contentViewController(at index: Int) -> WalkthroughContentViewController? {
        if index < 0 || index >= pageHeading.count {
            return nil
        }
        
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let pageContentViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.heading = pageHeading[index]
            pageContentViewController.subHeading = pageSubHeading[index]
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        return nil
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! WalkthroughContentViewController).index
        
        index -= 1
        
        return contentViewController(at: index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! WalkthroughContentViewController).index
        
        index += 1
        
        return contentViewController(at: index)
        
    }
    
    func forwardPage() {
        currentIndex += 1
        if let nextViewController = contentViewController(at: currentIndex) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            if let contentViewController = pageViewController.viewControllers?.first as? WalkthroughContentViewController {
                currentIndex = contentViewController.index
                walkthroughDelegate?.didUpdatePageIndex(currentIndex: contentViewController.index)
            }
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }

        // Do any additional setup after loading the view.
    }
    
}
