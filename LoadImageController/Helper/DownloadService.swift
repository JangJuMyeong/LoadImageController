//
//  DownloadService.swift
//  LoadImageController
//
//  Created by 장주명 on 2023/03/01.
//

import Foundation

class DownloadService {
    
    var activeDownloads: [URL: Download] = [:]
    var downloadsSession: URLSession!
    
    func cancelDownload(_ imageInfo: ImageInfo) {
        guard let url = imageInfo.downloadUrl, let download = activeDownloads[url] else {
        return
      }
      download.task?.cancel()
      activeDownloads[url] = nil
    }
    
    func startDownload(_ imageInfo: ImageInfo) {
        guard let url = imageInfo.downloadUrl else {
          return
        }

        let download = Download(imageInfo: imageInfo)
        if let activeDownlad = activeDownloads[download.imageInfo.downloadUrl!] {
            activeDownlad.task?.cancel()
            activeDownloads[download.imageInfo.downloadUrl!] = nil
        }
        download.task = downloadsSession.downloadTask(with: url)
        download.task?.resume()
        download.isDownloading = true
        
        activeDownloads[download.imageInfo.downloadUrl!] = download
    }
}
