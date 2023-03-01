//
//  LoadImageViewModel.swift
//  LoadImageController
//
//  Created by 장주명 on 2023/02/22.
//

import Foundation

final class LoadImageViewModel {
    let imageData = MyObservable<[ImageInfo]>([])
    let reloadIndex = MyObservable<Int?>(nil) 
    
    init() {
        imageData.value = mockData
    }
    
    lazy var mockData: [ImageInfo] = [
        ImageInfo(downloadUrl: URL(string: "https://img1.daumcdn.net/thumb/R800x0/?scode=mtistory2&fname=https%3A%2F%2Ft1.daumcdn.net%2Fcfile%2Ftistory%2F1159C8524D6C365821")),
        ImageInfo(downloadUrl: URL(string: "https://t1.daumcdn.net/cfile/tistory/1653FD374EF0D4C412")),
        ImageInfo(downloadUrl: URL(string: "https://cdn.pixabay.com/photo/2023/01/23/00/52/waves-7737627__340.jpg")),
        ImageInfo(downloadUrl: URL(string: "https://i.pinimg.com/736x/23/03/66/2303664f477a60718e4b2eb82e29d422.jpg")),
        ImageInfo(downloadUrl: URL(string: "https://t1.daumcdn.net/cfile/tistory/996333405A8280FC23"))]
    
    func reloadData(_ index: Int) {
        reloadIndex.value = index
    }
    
}
