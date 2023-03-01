//
//  MyObservable.swift
//  LoadImageController
//
//  Created by 장주명 on 2023/02/22.
//

import Foundation

class MyObservable<T> {
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
}
