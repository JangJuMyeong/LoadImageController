//
//  LoadImageViewController.swift
//  LoadImageController
//
//  Created by 장주명 on 2023/02/22.
//

import UIKit

class LoadImageViewController: UIViewController {
    
    @IBOutlet weak var imageDownloadCollectionView: UICollectionView!
    
    private let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    private let downloadService = DownloadService()
    private let viewModel = LoadImageViewModel()
    
    private lazy var downloadsSession: URLSession = {
      let configuration = URLSessionConfiguration.default
      
      return URLSession(configuration: configuration,
                        delegate: self,
                        delegateQueue: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    private func setUpView() {
        downloadService.downloadsSession = downloadsSession
        
        imageDownloadCollectionView.dataSource = self
        imageDownloadCollectionView.delegate = self
        
        viewModel.imageData.bind { [weak self] datas in
            self?.imageDownloadCollectionView.reloadData()
        }
        
        viewModel.reloadIndex.bind { index in
            if let index = index {
                self.imageDownloadCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
            }
        }
    }
    
    @IBAction func downloadAllImageButtonTapped(_ sender: UIButton) {
    }
}

extension LoadImageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageData.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadImageCell", for: indexPath) as? LoadImageCell else { return UICollectionViewCell()}
        
        cell.delegate = self
        
        return cell
    }
    
    
}

extension LoadImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = 130.0
        return CGSize(width: width, height: height)
    }
}

extension LoadImageViewController: LoadImageCellDelegate {
    func cancelTapped(_ cell: LoadImageCell) {
        if let indexPath = imageDownloadCollectionView.indexPath(for: cell) {
            let imageInfo = viewModel.imageData.value[indexPath.row]
          downloadService.cancelDownload(imageInfo)
            viewModel.reloadData(indexPath.row)
        }
    }
    
    func downloadTapped(_ cell: LoadImageCell) {
        if let indexPath = imageDownloadCollectionView.indexPath(for: cell) {
            let imageInfo = viewModel.imageData.value[indexPath.row]
          downloadService.startDownload(imageInfo)
            viewModel.reloadData(indexPath.row)
        }
    }
    
    func pauseTapped(_ cell: LoadImageCell) {
        if let indexPath = imageDownloadCollectionView.indexPath(for: cell) {
            let imageInfo = viewModel.imageData.value[indexPath.row]
          downloadService.pauseDownload(imageInfo)
            viewModel.reloadData(indexPath.row)
        }
    }
    
    func resumeTapped(_ cell: LoadImageCell) {
        if let indexPath = imageDownloadCollectionView.indexPath(for: cell) {
            let imageInfo = viewModel.imageData.value[indexPath.row]
          downloadService.resumeDownload(imageInfo)
            viewModel.reloadData(indexPath.row)
        }
    }
    
    
}

extension LoadImageViewController: URLSessionDownloadDelegate {
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                  didFinishDownloadingTo location: URL) {
    print("Finished downloading to \(location).")
  }
}
