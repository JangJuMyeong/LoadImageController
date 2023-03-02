//
//  ImageInfo.swift
//  LoadImageController
//
//  Created by 장주명 on 2023/02/22.
//

import UIKit
import Foundation

class ImageInfo {
    var image: UIImage? = nil
    let downloadUrl: URL?
    let index: Int
    var downloaded = false
    
    init(downloadUrl: URL?, index: Int) {
        self.downloadUrl = downloadUrl
        self.index = index
    }
}
