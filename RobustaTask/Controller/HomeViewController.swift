//
//  ViewController.swift
//  RobustaTask
//
//  Created by aBoelghet  on 12/8/20.
//

import UIKit

class HomeViewController: UIViewController{
    
    // MARK: Outlets
    @IBOutlet weak var reposTableView: UITableView!
    // searchController
    let searchController = UISearchController(searchResultsController: nil)
    // load more indicator
    fileprivate var activityIndicator: LoadMoreActivityIndicator!
    // A simple indicator to show during tableview load data
    var indicator = UIActivityIndicatorView()
    // MARK: Public View Variables
    let dataRequestOject = DataRequests()
    var repositoriesNameArr: [String] = []
    var rerepositoriesURLArr: [String] = []
    var ownerImageURLArr: [String] = []
    var ownerNameArr:[String] = []
    var creationDateArr: [String] = []
    //    var repositoriesDescArr: [String] = []
    //    var rerepositoriesprivacyArr: [Bool] = []
    var filteredRepos: [String]!
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set this default values for searchController
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        definesPresentationContext = true
        // Add search to table
        reposTableView.tableHeaderView = searchController.searchBar
        // SetTableViewColor
        reposTableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        // Set load more activitiyIndicator
        reposTableView.tableFooterView = UIView()
        activityIndicator = LoadMoreActivityIndicator(scrollView: reposTableView, spacingFromLastCell: 10, spacingFromLastCellWhenLoadMoreActionStart: 60)
        // Get repositriesData from Server
        DispatchQueue.global(qos: .background).async {
            self.reposTableView.showActivityIndicator()
            self.dataRequestOject.dataRequest(with: "https://api.github.com/repositories", objectType: [Repository].self) { (result: Result) in
                switch result {
                case .success(let repos):
                    for repo in repos{
                        self.repositoriesNameArr.append(repo.name)
                        self.dataRequestOject.dataRequest(with: repo.ownerUrl, objectType: RepoOwner.self) { (result: Result) in
                            switch result {
                            case .success(let owner):
                                print(owner)
                                self.ownerNameArr.append(owner.name)
                                self.ownerImageURLArr.append(owner.avatarUrl)
                                self.creationDateArr.append(owner.created_at)
                                DispatchQueue.main.async {                            self.reposTableView.reloadData()
                                     self.reposTableView.hideActivityIndicator()
                                }
                                print(self.ownerNameArr.count)
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                    self.filteredRepos = self.repositoriesNameArr
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
extension HomeViewController: UITableViewDataSource,UITableViewDelegate{
    // MARK: TableView dataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != nil {
            return filteredRepos.count
        } else {
            return ownerNameArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryTableViewCell", for: indexPath)as! RepositoryTableViewCell
        
        
        if searchController.isActive && searchController.searchBar.text != nil {
            let index = filteredRepos.startIndex.advanced(by: indexPath.row)
            cell.repositoryNamebeLabel.text = self.repositoriesNameArr[index]
            cell.repositoryCreationDateLabel.text = self.creationDateArr[index]
            cell.repositoryOwnerNameLabel.text = self.ownerNameArr[index]
            cell.repositoryOwnerImage.image = UIImage(url: URL(string: self.ownerImageURLArr[index]))
            cell.repositoryOwnerImage.layer.masksToBounds = true
            cell.repositoryOwnerImage.layer.cornerRadius = (cell.repositoryOwnerImage.layer.frame.width)/2
            cell.backgroundView?.addCornerRadius()
            cell.backgroundColor = #colorLiteral(red: 0.9214808345, green: 0.9216319919, blue: 0.921448648, alpha: 1)
        } else {
            let index = repositoriesNameArr.startIndex.advanced(by: indexPath.row)
            cell.repositoryNamebeLabel.text = self.repositoriesNameArr[index]
            cell.repositoryCreationDateLabel.text = self.creationDateArr[index]
            cell.repositoryOwnerNameLabel.text = self.ownerNameArr[index]
            cell.repositoryOwnerImage.image = UIImage(url: URL(string: self.ownerImageURLArr[index]))
            cell.repositoryOwnerImage.layer.masksToBounds = true
            cell.repositoryOwnerImage.layer.cornerRadius = (cell.repositoryOwnerImage.layer.frame.width)/2
            cell.backgroundView?.addCornerRadius()
            cell.backgroundColor = #colorLiteral(red: 0.9214808345, green: 0.9216319919, blue: 0.921448648, alpha: 1)
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    // MARK: TableView Delegte method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsVc = storyboard.instantiateViewController(identifier: "RepoDetailsViewController")as! RepoDetailsViewController
        detailsVc.ownerImageURL = self.ownerImageURLArr[indexPath.row]
        detailsVc.repoName = self.repositoriesNameArr[indexPath.row]
        detailsVc.repoOwnerName = self.ownerNameArr[indexPath.row]
        self.navigationController?.pushViewController(detailsVc, animated: true)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        activityIndicator.start {
            DispatchQueue.global(qos: .utility).async {
                sleep(3)
                DispatchQueue.main.async { [weak self] in
                    self?.activityIndicator.stop()
                }
            }
        }
    }
}
extension HomeViewController:UISearchResultsUpdating{
   
    // MARK: SerachController delegete methods
    func updateSearchResults(for searchController: UISearchController) {
        filteredRepos = repositoriesNameArr
        print(filteredRepos!)
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        if searchText.count >= 2 {
            // Filter your search results here
            filteredRepos  = repositoriesNameArr.filter({$0.lowercased().contains(searchText.lowercased())})

            print(filteredRepos!)
        }
        reposTableView.reloadData()
    }
    
}


extension UIView {
    
    func addCornerRadius(width:CGFloat = 3, height:CGFloat = 3, Opacidade:Float = 0.7, radius:CGFloat = 3){
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
}
// Tableview simple indicator
extension UITableView {
    func showActivityIndicator() {
        DispatchQueue.main.async {
            let activityView = UIActivityIndicatorView(style: .medium)
            self.backgroundView = activityView
            activityView.startAnimating()
        }
    }

    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.backgroundView = nil
        }
    }
}

// Handle Seting Image from URL Nativly :-)
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
