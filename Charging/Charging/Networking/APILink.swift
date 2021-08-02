//
//  APILink.swift
//  Dayshee
//
//  Created by haiphan on 10/31/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit

enum APILink: String {
    case listAnimation = "/client/showAllCategoriesWithVideos?page_category=0&"
    case listSound = "/client/showAllSounds"
    
    var value: String {
        return "\(self)"
    }
}
