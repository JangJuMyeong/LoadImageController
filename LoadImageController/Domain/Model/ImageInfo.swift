//
//  ImageInfo.swift
//  LoadImageController
//
//  Created by 장주명 on 2023/02/22.
//

import UIKit
import Foundation

class ImageInfo {
    let image: UIImage? = nil
    let downloadUrl: URL?
    var downloaded = false
    
    init(downloadUrl: URL?) {
        self.downloadUrl = downloadUrl
    }
}
