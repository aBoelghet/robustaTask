//
//  ViewController.swift
//  RobustaTask
//
//  Created by aBoelghet  on 12/8/20.
//

import UIKit

class HomeViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

}
extension HomeViewController: UITableViewDataSource,UITableViewDelegate{
    // MARK: TableView dataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}
extension HomeViewController:UISearchBarDelegate{
    // MARK: SerachBar delegete methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        <#code#>
    }
}
   
