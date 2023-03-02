//
//  LoadImageViewController.swift
//  LoadImageController
//
//  Created by 장주명 on 2023/02/22.
//

import UIKit

class LoadImageViewController: UIViewController {
    
    @IBOutlet weak var imageDownloadCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    private let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    private let downloadService = DownloadService()
    private let viewModel = LoadImageViewModel()
    
    private lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        
        return URLSession(configuration: configuration,
                          delegate: self,
                          delegateQueue: nil)
    }()
    
    private func localFilePath(for url: URL) -> URL {
        return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillLayoutSubviews() {
        if imageDownloadCollectionView.contentSize.height > 0 {
            collectionViewHeight.constant = imageDownloadCollectionView.contentSize.height
        }
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
                DispatchQueue.main.async {
                    self.imageDownloadCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                }
            }
        }
    }
    
    @IBAction func downloadAllImageButtonTapped(_ sender: UIButton) {
        
        for i in 0 ..< viewModel.imageData.value.count {
            print(i)
            let imageInfo = viewModel.imageData.value[i]
            downloadService.startDownload(imageInfo)
            viewModel.downloadStart(index: i)
        }
    }
}

extension LoadImageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageData.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadImageCell", for: indexPath) as? LoadImageCell else { return UICollectionViewCell()}
        
        let info = viewModel.imageData.value[indexPath.row]
        
        cell.delegate = self
        cell.setUpCell(info, isDownloaded: info.downloaded)
        
        return cell
    }
    
    
}

extension LoadImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = 100.0
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
            viewModel.downloadStart(index: indexPath.row)
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
        
        guard let sourceURL = downloadTask.originalRequest?.url else {
            return
        }
        let download = downloadService.activeDownloads[sourceURL]
        downloadService.activeDownloads[sourceURL] = nil
        
        guard let data = try? Data(contentsOf: location), let image = UIImage(data: data) else {
            print("load image fail")
            return
        }
        
        if let index = download?.imageInfo.index {
            viewModel.downloadComplete(index: index, image: image)
        }
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        guard let url = downloadTask.originalRequest?.url,
            let download = downloadService.activeDownloads[url]  else {
            return
        }
    
        download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            if let imageCell = self.imageDownloadCollectionView.cellForItem(at: IndexPath(row: download.imageInfo.index,
                                                                       section: 0)) as? LoadImageCell {
                imageCell.updateDisplay(progress: download.progress)
            }
        }
    }
}
