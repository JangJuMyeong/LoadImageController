//
//  LoadImageViewModel.swift
//  LoadImageController
//
//  Created by 장주명 on 2023/02/22.
//

import UIKit

final class LoadImageViewModel {
    let imageData = MyObservable<[ImageInfo]>([])
    let reloadIndex = MyObservable<Int?>(nil) 
    
    init() {
        imageData.value = mockData
    }
    
    lazy var mockData: [ImageInfo] = [
        ImageInfo(downloadUrl: URL(string: "https://upload.wikimedia.org/wikipedia/commons/b/bd/Calutrons_at_Oak_Ridge.jpg"), index: 0),
        ImageInfo(downloadUrl: URL(string: "https://upload.wikimedia.org/wikipedia/commons/a/a0/%22%2430_every_Thursday%22_pension_plan_out_as_President_discusses_political_situation_with_California_candidates._Washington%2C_D.C.%2C_Sept._27._Sheridan_Downey%2C_who_defeated_Senator_William_Gibbs_LCCN2016874059.jpg"), index: 1),
        ImageInfo(downloadUrl: URL(string: "https://upload.wikimedia.org/wikipedia/commons/a/ae/%22A_message_from_God.%22_Washington%2C_D.C.%2C_March_12._The_Chairman_of_the_Senate_Judiciary_Committee_Henry_F._Ashurst%2C_was_a_bit_surprised_today_that_even_the_Lord_was_interested_in_the_LCCN2016871343.tif"), index: 2),
        ImageInfo(downloadUrl: URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/04/%22Gridiron_Widows%22_Burlesque_President_and_Chief_Justice._Washington%2C_D.C.%2C_Dec._16._Mrs._Roosevelt_played_host_to_her_guests%2C_the_%27Gridiron_Widows%27_at_the_White_House_while_the_Gridiron_Club_LCCN2016874558.tif"), index: 3),
        ImageInfo(downloadUrl: URL(string: "https://upload.wikimedia.org/wikipedia/commons/b/bf/%22Hands_off_the_court%22_Representative_before_Senate_Judiciary_Committee._Washington%2C_D.C.%2C_April_22._Representing_the_Women%27s_National_Committee_for_%22Hands_off_the_Supreme_Court%2C%22_Catherine_LCCN2016871589.tif"), index: 4)]
    
    func reloadData(_ index: Int) {
        reloadIndex.value = index
    }
    
    func downloadCancel(index: Int) {
        imageData.value[index].image = nil
        imageData.value[index].downloaded = false
        reloadIndex.value = index
    }
    
    func downloadStart(index: Int) {
        imageData.value[index].image = nil
        imageData.value[index].downloaded = false
        reloadIndex.value = index
    }
    
    func downloadComplete(index: Int, image: UIImage) {
        imageData.value[index].image = image
        imageData.value[index].downloaded = true
        reloadIndex.value = index
    }
    
}
