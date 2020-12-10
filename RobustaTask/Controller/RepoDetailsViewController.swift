//
//  RepoDetailsViewController.swift
//  RobustaTask
//
//  Created by aBoelghet  on 12/8/20.
//

import UIKit

class RepoDetailsViewController: UIViewController {

    //MARK: DetailsView Outlets
    
    @IBOutlet weak var repoOwnerImage:UIImageView!
    @IBOutlet weak var repoOwnerNameLabel:UILabel!
    @IBOutlet weak var repoNameLabel:UILabel!

    
    //MARK: ViewController Variables
    var ownerImageURL: String!
    var repoName: String!
    var repoOwnerName: String!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Make Circular Image
        self.repoOwnerImage.layer.masksToBounds = true
        self.repoOwnerImage.layer.cornerRadius = (self.repoOwnerImage.layer.frame.width)/2
        // Set Transfered data
        self.repoOwnerImage.image = UIImage(url: URL(string:ownerImageURL))
        self.repoNameLabel.text = repoName
        self.repoOwnerNameLabel.text = repoOwnerName
        
    }

}
