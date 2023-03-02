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
  func pauseTapped(_ cell: LoadImageCell)
  func resumeTapped(_ cell: LoadImageCell)
}

class LoadImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    var delegate: LoadImageCellDelegate?

    func setUpCell(_ info: ImageInfo, isDownloaded: Bool) {
        print(isDownloaded)
        if let image = info.image {
            imageView.image = image
        }
        
        if isDownloaded {
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
        if downloadButton.titleLabel?.text == "다운로드" || downloadButton.titleLabel?.text == "완료"{
            print("잃시정지")
            downloadButton.setTitle("일지정지", for: .normal)
            imageView.image = UIImage(systemName: "photo.artframe")
            progressView.progress = 0
            delegate?.downloadTapped(self)
        } else {
            print("다운로드")
            downloadButton.setTitle("다운로드", for: .normal)
            delegate?.pauseTapped(self)
        }
        
    }
    
}
