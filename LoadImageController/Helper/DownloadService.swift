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
      guard let download = activeDownloads[imageInfo.downloadUrl] else {
        return
      }
      download.task?.cancel()
      activeDownloads[imageInfo.downloadUrl] = nil
    }
    
    func pauseDownload(_ imageInfo: ImageInfo) {
      guard
        let download = activeDownloads[imageInfo.downloadUrl],
        download.isDownloading
        else {
          return
      }
      
      download.task?.cancel(byProducingResumeData: { data in
        download.resumeData = data
      })

      download.isDownloading = false
    }
    
    func resumeDownload(_ imageInfo: ImageInfo) {
      guard let download = activeDownloads[imageInfo.downloadUrl] else {
        return
      }
      
      if let resumeData = download.resumeData {
        download.task = downloadsSession.downloadTask(withResumeData: resumeData)
      } else {
        download.task = downloadsSession.downloadTask(with: download.imageInfo.downloadUrl)
      }
      
      download.task?.resume()
      download.isDownloading = true
    }
    
    func startDownload(_ imageInfo: ImageInfo) {
        
        let download = Download(imageInfo: imageInfo)
        download.task = downloadsSession.downloadTask(with: imageInfo.downloadUrl)
        download.task?.resume()
        download.isDownloading = true
        
        activeDownloads[download.imageInfo.downloadUrl] = download
    }
}
