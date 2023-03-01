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
}
