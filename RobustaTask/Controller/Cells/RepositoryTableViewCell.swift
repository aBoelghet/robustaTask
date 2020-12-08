//
//  RepositoryTableViewCell.swift
//  RobustaTask
//
//  Created by aBoelghet  on 12/8/20.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    // MARK: Cell Oultests
    @IBOutlet weak var repositoryNamebeLabel: UILabel!
    @IBOutlet weak var repositoryOwnerNameLabel: UILabel!
    @IBOutlet weak var repositoryCreationDateLabel: UILabel!
    @IBOutlet weak var repositoryOwnerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
