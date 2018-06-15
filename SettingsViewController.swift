//
//  SettingsViewController.swift
//  todo
//
//  Created by Akash Khatkale on 20/03/1940 Saka.
//  Copyright © 1940 Akash Khatkale. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var noAdsButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       let theme = UserDefaults.standard.string(forKey: "theme")!
        
        languageButton.setImage(UIImage(named: "lang\(theme)"), for: .normal)
        languageButton.setImage(UIImage(named: "langClicked\(theme)"), for: .highlighted)
        
        noAdsButton.setImage(UIImage(named: "noAds\(theme)"), for: .normal)
        noAdsButton.setImage(UIImage(named: "noAds\(theme)"), for: .highlighted)
        
        reviewButton.setImage(UIImage(named: "review\(theme)"), for: .normal)
        reviewButton.setImage(UIImage(named: "reviewClicked\(theme)"), for: .highlighted)
        
        helpButton.setImage(UIImage(named: "help\(theme)"), for: .normal)
        helpButton.setImage(UIImage(named: "helpClicked\(theme)"), for: .highlighted)
        
        shareButton.setImage(UIImage(named: "share\(theme)"), for: .normal)
        shareButton.setImage(UIImage(named: "shareClicked\(theme)"), for: .highlighted)
        
        
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
