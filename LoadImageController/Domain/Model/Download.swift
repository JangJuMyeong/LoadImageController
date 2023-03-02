//
//  Download.swift
//  LoadImageController
//
//  Created by 장주명 on 2023/03/01.
//

import Foundation

class Download {
    var isDownloading = false
    var progress: Float = 0
    var resumeData: Data?
    var task: URLSessionDownloadTask?
    var imageInfo: ImageInfo
    
    
    
    
    init(imageInfo: ImageInfo) {
      self.imageInfo = imageInfo
    }
}
