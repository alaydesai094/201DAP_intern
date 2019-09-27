//
//  AboutUsViewController.swift
//  CTC
//
//  Created by Aesha Patel on 2019-05-15.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

  
    @IBOutlet weak var img_kim: UIImageView!
    @IBOutlet weak var img_teresa: UIImageView!
    
    
    @IBOutlet weak var btn_teresa: UIButton!
    @IBOutlet weak var btn_Kim: UIButton!
    
    @IBOutlet weak var txt_teresa_description: UITextView!
    @IBOutlet weak var txt_Kim_description: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     
        img_kim.layer.cornerRadius = img_kim.frame.size.width / 2;
        img_kim.clipsToBounds = true;
        img_kim.layer.borderColor = UIColor.white.cgColor;
        img_kim.layer.borderWidth = 3;
        
        img_teresa.layer.cornerRadius = img_teresa.frame.size.width / 2;
        img_teresa.clipsToBounds = true;
        img_teresa.layer.borderColor = UIColor.white.cgColor;
        img_kim.layer.borderWidth = 3;
        
        btn_Kim.layer.borderWidth = 2;
        btn_Kim.layer.borderColor = UIColor.gray.cgColor;

        btn_teresa.layer.borderWidth = 2;
        btn_teresa.layer.borderColor = UIColor.gray.cgColor;
        
        
        txt_teresa_description.text = "Teresa has been practicing 201 Day Achievement Principle for few years now, feeling passionate about it and keeping track of 9 practices!";
        txt_Kim_description.text = "National and international track and field athlete who found a way of running for pleasure without feeling the pressure and guilt.";
      
    }
    
    @IBAction func btn_kim(_ sender: UIButton) {
        if let url = NSURL(string: "https://kimwhitecoaching.com/"){
            UIApplication.shared.open(url as URL)
        }  
    }
    
    @IBAction func btn_teresa(_ sender: UIButton) {
        
        if let url = NSURL(string: "http://www.connecttothecore.com/"){
            UIApplication.shared.open(url as URL)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
