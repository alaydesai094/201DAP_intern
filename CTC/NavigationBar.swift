//
//  NavigationBar.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-01-22.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class NavigationBar: UINavigationBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialNavigationBar()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialNavigationBar()
    }
    
    func initialNavigationBar() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 1.0
        self.barTintColor = Theme.navigationBarBackgroundColor
        self.tintColor = UIColor.white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.titleTextAttributes = textAttributes
        
    }

}
