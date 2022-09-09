//
//  ViewController.swift
//  URL
//
//  Created by Andrew Kvasha on 09.09.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private let identifier = "MyCell"
    private let searchController = UISearchController(searchResultsController: nil)
    private let networkService = NetworkService()
    private var table = UITableView()
    private var searchResponse: SearchResponse? = nil
    private var timer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTable()
        createSearch()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func createTable() {
        
        self.table = UITableView(frame: view.bounds, style: .plain)
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: self.identifier)
        
        self.table.delegate = self
        self.table.dataSource = self
        
        view.addSubview(table)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponse?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let track = searchResponse?.results[indexPath.row]
        cell.textLabel?.text = track?.trackName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ViewController: UISearchBarDelegate {
    
    
    private func createSearch() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false
        title = "Search"
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let urlString = "https://itunes.apple.com/search?term=\(searchText)&limit=25"
        
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.networkService.request(urlString: urlString) { [ weak self] result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let searchResponse):
                    self?.searchResponse = searchResponse
                    self?.table.reloadData()
                }
                
            }
        })
    }
}

