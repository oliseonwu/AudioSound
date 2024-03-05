//
//  ProfileCell.swift
//  AudioSound
//
//  Created by Kevin Nguyen on 5/14/23.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
import ParseSwift

class ProfileCell: UICollectionViewCell{
    private var imageDataRequest: DataRequest?

    @IBOutlet weak var audioImage: UIImageView!
    
    
    func configure(audioInfo: Audio){
        if let imageFile = audioInfo.clipArt,
           let imageUrl = imageFile.url {
            
            // Use AlamofireImage helper to fetch remote image from URL
            
            // Remember Nuke packge we used some
            // labs ago was used to load up image
            // from URL. rember our imge file
            // is not an image but binary file
            
            
            imageDataRequest = AF.request(imageUrl).responseImage{
                [weak self] response in
                
                switch response.result {
                case .success(let image):
                    // Set image view image with fetched image
                    print(audioInfo)
                    self?.audioImage.image = image
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                    break
                }
            }
        }
    }
}
