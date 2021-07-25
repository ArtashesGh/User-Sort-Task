//
//  Constants.swift
//  Task
//
//  Created by Artashes Nok Nok on 3/20/21.
//

import Foundation
import UIKit

struct Constants
{
    
    struct Colors {
        public static let voloGreenColor = UIColor(red: 176.0/255.0, green: 245.0/255.0, blue:225.0/255.0, alpha: 1.0)
        public static let voloBlueColor = UIColor(red: 190.0/255.0, green: 217.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        public static let voloGrayColor =  UIColor(red: 209.0/255.0, green: 219.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        public static let voloAcuaColor =  UIColor(red: 178.0/255.0, green: 237.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        public static let voloPinkColor =  UIColor(red: 225.0/255.0, green: 219.0/255.0, blue: 248.0/255.0, alpha: 1)
        public static let voloYellowColor =  UIColor(red: 225.0/255.0, green: 244.0/255.0, blue: 188.0/255.0, alpha: 1)
        public static let voloPurpleColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 249.0/255.0, alpha: 1)
    }
    struct ColorsArray {
        public static let myCollorsArray = [Colors.voloGreenColor,
                                            Colors.voloBlueColor,
                                            Colors.voloGrayColor,
                                            Colors.voloAcuaColor,
                                            Colors.voloPinkColor,
                                            Colors.voloYellowColor,
                                            Colors.voloPurpleColor]
    }
    
    struct Network {
        public static let BaseURL = URL(string: "https://randomuser.me/api/") 
    }
    
}
