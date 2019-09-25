//
//  FAQViewController.swift
//  CTC
//
//  Created by Aesha Patel on 2019-05-15.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController {
    
    var faqView: FAQView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

       if #available(iOS 11.0, *) {
           
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        let items = [
            
            FAQItem(question: "What if I didn’t do anything all week?", answer: "This is not an all or nothing program. There will be times when adhering to your practices is more challenging than others. You can make those days up throughout the year. Also, plan to bank before times you know will be harder or at the beginning of the year so you don’t feel the pressure at the end of the year. And keep tracking every week so you know where you’re at. If you are able to be around 60% you should have lots of leeway.If you haven’t done your practice all week, your number of practices would stay the same but the percentage would go down."),
            
            FAQItem(question: "How do I calculate my numbers and progress every week?", answer: "A) Write down the Tracking Day which is the cumulative number of days you have done this activity so far this year.B) Write down the Day Since Start which is the number of days since you have began this practice.C) Divide your Tracking Day by the Day Since Start to get your percentage for today TD / DSS = %"),
            
            FAQItem(question: "What happens if I’m great at one of these and not so great at the other?", answer: "That’s normal, and why this program works so well. You will gain insights into where you are not as strong and need a bit more support. Tracking your achievements will help you stay on hcourse. Having an accountability partner is a bonus!"),
            
            FAQItem(question: "What if I want to quit one of my commitments?", answer: "Create a post inside the Facebook Group: The 201 Day Achievement Principle. Share how you’re feeling so that others in the group including our team, can support you in staying committed to why you chose that practice in the first place.Review your Vision, Values, What and Why to see if they all align."),
            
            FAQItem(question: "How do I decide to do my practice or not? ", answer: "It’s totally up to you! And that’s the great choice you have. You can do your practice or not (exercise). You might have a busy day today and won’t be able to fit exercise in your schedule. That is totally fine. Don’t feel bad about it. You can make up for the lost day some other time."),
            
            FAQItem(question: "How do I stick to keeping track of my practices?", answer: "The best way to keep track of your practices is to tack tracking on to some other routine you have already well established (morning coffee; reading before bed; brushing teeth at night, …) Keep the journal or phone close by and always think about tracking during these routines.")
        
        ]

        faqView = FAQView(frame: view.frame, items: items)
        faqView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(faqView)
        addFaqViewConstraints()
        

      
    }
    func addFaqViewConstraints() {
        let faqViewTrailing = NSLayoutConstraint(item: faqView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailingMargin, multiplier: 1, constant: 17)
        let faqViewLeading = NSLayoutConstraint(item: faqView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leadingMargin, multiplier: 1, constant: -17)
        let faqViewTop = NSLayoutConstraint(item: faqView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 50)
        let faqViewBottom = NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: faqView, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([faqViewTop, faqViewBottom, faqViewLeading, faqViewTrailing])
    }

}
