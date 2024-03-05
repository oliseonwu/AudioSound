//
//  OptionViewCell.swift
//  AudioSound
//
//  Created by Olisemedua Onwuatogwu on 5/15/23.
//

import UIKit

class OptionViewCell: UITableViewCell {

    @IBOutlet weak var optionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(optionName:String){
        self.optionName.text = optionName
    }
}
