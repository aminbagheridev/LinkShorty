//
//  LinkShortyViewController.swift
//  Netflix Clone
//
//  Created by Amin  Bagheri  on 2022-06-20.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        // we are instantiating instances of these view controllers and we are adding them to be under a navigatoin controller so that when we push to movie details, we get to have the back button and all other functionality etc
        let vc1 = UINavigationController(rootViewController: LinkShortyViewController())
        let vc2 = UINavigationController(rootViewController: LinkHistoryViewController())
        
        //creating the images for each tab in the tab bar controller
        vc1.tabBarItem.image = UIImage(systemName: "link")
        vc2.tabBarItem.image = UIImage(systemName: "clock.arrow.circlepath")

        //pretty self explanatory, but here we are setting the title of each of the tab bar tiem to be its respective tirle
        vc1.title = "Link Shorty"
        vc2.title = "History"
        
        
        
        // setting the color of each tab bar item
        tabBar.tintColor = .label
        
        // this sets the view controllers of the tab bar controller (the individual tabs) to be the viewControllers we initiated
        setViewControllers([vc1, vc2], animated: true)
        
    }


}

