//
//  CustomCellTableViewCell.swift
//  todo
//
//  Created by Akash Khatkale on 14/03/1940 Saka.
//  Copyright © 1940 Akash Khatkale. All rights reserved.
//

import UIKit

class CustomCellTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var importantImage: UILabel!
    
    @IBOutlet weak var taskName: UILabel!
    
    @IBOutlet weak var categoryImage: UIImageView!
    
    @IBOutlet weak var taskBorder: UIImageView!
    
    @IBOutlet weak var alarmImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let theme = UserDefaults.standard.string(forKey: "theme")!
        taskBorder.image = UIImage(named: "taskBorder\(theme)")
        
    }
    
    



}
