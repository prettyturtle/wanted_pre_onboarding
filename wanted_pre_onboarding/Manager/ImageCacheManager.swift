//
//  ImageCacheManager.swift
//  wanted_pre_onboarding
//
//  Created by yc on 2022/06/13.
//

import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}
