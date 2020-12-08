//
//  ViewController.swift
//  RobustaTask
//
//  Created by aBoelghet  on 12/8/20.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var reposTableView: UITableView!
    
    // MARK: Public View Variables
    let dataRequestOject = DataRequests()
    var repositoriesNameArr: [String] = []
    var rerepositoriesURLArr: [String] = []
    var ownerImageURLArr: [String] = []
    var ownerNameArr:[String] = []
    var creationDateArr: [String] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get repositriesData from Server
//        dataRequestOject.dataRequest()
        dataRequestOject.dataRequest(with: "https://api.github.com/repositories", objectType: [Repository].self) { (result: Result) in
            switch result {
            case .success(let repos):
                for repo in repos{
                    self.repositoriesNameArr.append(repo.name)
                    self.dataRequestOject.dataRequest(with: repo.url, objectType: RepoOwner.self) { (result: Result) in
                        switch result {
                        case .success(let owner):
                            print(owner)
                            self.ownerNameArr.append(owner.name)
                            self.ownerImageURLArr.append(owner.avatarUrl)
                            self.creationDateArr.append(owner.created_at)
                            DispatchQueue.main.async {                            self.reposTableView.reloadData()
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
extension HomeViewController: UITableViewDataSource,UITableViewDelegate{
    // MARK: TableView dataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoriesNameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryTableViewCell", for: indexPath)as! RepositoryTableViewCell
        
        cell.repositoryNamebeLabel.text = self.repositoriesNameArr[indexPath.row]
        cell.repositoryCreationDateLabel.text = self.creationDateArr[indexPath.row]
        cell.repositoryOwnerNameLabel.text = self.ownerNameArr[indexPath.row]
        cell.repositoryOwnerImage.image = UIImage(url: URL(string: ownerImageURLArr[indexPath.row]))
        cell.backgroundView?.addCornerRadius()
        cell.backgroundColor = #colorLiteral(red: 0.9214808345, green: 0.9216319919, blue: 0.921448648, alpha: 1)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
extension HomeViewController:UISearchBarDelegate{
    // MARK: SerachBar delegete methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //
    }
}
   
extension UIView {
    
    func addCornerRadius(width:CGFloat = 3, height:CGFloat = 3, Opacidade:Float = 0.7, radius:CGFloat = 3){
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
}
extension UIImage {
  convenience init?(url: URL?) {
    guard let url = url else { return nil }
            
    do {
      self.init(data: try Data(contentsOf: url))
    } catch {
      print("Cannot load image from url: \(url) with error: \(error)")
      return nil
    }
  }
}
