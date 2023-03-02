//
//  LoadImageCell.swift
//  LoadImageController
//
//  Created by 장주명 on 2023/02/22.
//

import UIKit

protocol LoadImageCellDelegate {
  func cancelTapped(_ cell: LoadImageCell)
  func downloadTapped(_ cell: LoadImageCell)
}

class LoadImageCell: UICollectionViewCell {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var downloadControllerView: UIStackView!
    
    var delegate: LoadImageCellDelegate?

    func setUpCell(_ info: ImageInfo, isDownloaded: Bool, download: Download?) {
        print(isDownloaded)
        if let image = info.image {
            imageView.image = image
        }
        

        
        if download != nil {
            downloadControllerView.isHidden = false
            statusLabel.isHidden = false
            downloadButton.isHidden = true
            statusLabel.text = "다운로드중..."
        } else {
            downloadControllerView.isHidden = true
            statusLabel.isHidden = true
            downloadButton.isHidden = false
        }
        
        if isDownloaded {
            statusLabel.isHidden = false
            statusLabel.text = "다운로드 완료"
            downloadButton.isHidden = false
            downloadButton.setTitle("완료", for: .normal)
            progressView.progress = 1
        } else {
            imageView.image = UIImage(systemName: "photo.artframe")
            progressView.progress = 0
        
        }
    }
    
    func updateDisplay(progress: Float) {
      progressView.progress = progress
    }
    
    @IBAction func downloadButtonTapped(_ sender: UIButton) {
        downloadButton.isHidden = true
        downloadControllerView.isHidden = false
        imageView.image = UIImage(systemName: "photo.artframe")
        progressView.progress = 0
        delegate?.downloadTapped(self)
    }
    
    @IBAction func cancleButtonTapped(_ sender: UIButton) {
        delegate?.cancelTapped(self)
    }
}
