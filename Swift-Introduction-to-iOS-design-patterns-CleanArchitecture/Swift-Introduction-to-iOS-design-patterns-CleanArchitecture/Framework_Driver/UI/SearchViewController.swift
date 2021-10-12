//
//  SearchViewController.swift
//  Swift-Introduction-to-iOS-design-patterns-CleanArchitecture
//
//  Created by kazunori.aoki on 2021/10/12.
//

import UIKit

class SearchViewController: UITableViewController {

    // MARK: UI
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // MARK: Variable
    private var viewDataArray = [GitHubRepoViewData]()
    private weak var presenter: ReposPresenterProtocol!
    
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}


// MARK: - Setup
private extension SearchViewController {
    func setup() {
        setupSearchBar()
        setupTableView()
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
    }
    
    func setupTableView() {
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        let nib = RepositoryCellWithLike.nib
        tableView.register(nib, forCellReuseIdentifier: "RepositoryCell")
    }
}


// MARK: - ReposPresenterInjectable
extension SearchViewController: ReposPresenterInjectable {
    func inject(reposPresenter: ReposPresenterProtocol) {
        presenter = reposPresenter
        presenter.reposOutput = self
        presenter.startFetch(using: [])
    }
}


// MARK: - ReposPresenterOutput
extension SearchViewController: ReposPresenterOutput {
    func update(by viewDataArray: [GitHubRepoViewData]) {
        self.viewDataArray = viewDataArray
        tableView.reloadData()
    }
}


// MARK: - UITableViewDataSource
extension SearchViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewDataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell",
                                                 for: indexPath) as! RepositoryCellWithLike
        
        cell.configure(with: viewDataArray[indexPath.row])
        return cell
    }
}


// MARK: - UITableViewDelegate
extension SearchViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewData = viewDataArray[indexPath.row]
        presenter.set(liked: !viewData.isLiked, for: viewData.id)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}


// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let text = searchBar.text else { return }
        let keywords = text.split(separator: " ").map(String.init)
        presenter.startFetch(using: keywords)
    }
}
