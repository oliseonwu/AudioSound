//
//  SearchCell.swift
//  AudioSound
//
//  Created by ANISHA
//

import UIKit
import Alamofire

protocol MyTableViewCellDelegate: AnyObject {
    func didTapButton(user: User, button: UIButton)
}

class SearchCell: UITableViewCell {

    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var labelUserTag: UILabel!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var bFollow: UIButton!
    
    private var imageDataRequest: DataRequest?
    
    weak var delegate: MyTableViewCellDelegate?
    private var user = User()
    
    func configure(with user: User) {
        self.user = user
        
        labelUserTag.text = user.username
        labelUsername.text = "\(user.firstName!) \(user.lastName!)"
        
        // Image
        if let imageFile = user.profile,
           let imageUrl = imageFile.url {

            // Use AlamofireImage helper to fetch remote image from URL
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    // Set image view image with fetched image
                    self?.ivProfile.image = image
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                    break
                }
            }
        }
    }

    @IBAction func bFollowClicked(_ sender: Any) {
        delegate?.didTapButton(user: self.user, button: bFollow)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        // Reset image view image.
        ivProfile.image = nil

        // Cancel image request.
        imageDataRequest?.cancel()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
