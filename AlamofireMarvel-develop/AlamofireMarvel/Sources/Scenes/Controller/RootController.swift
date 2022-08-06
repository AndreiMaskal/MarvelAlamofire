//
//  RootController.swift
//  AlamofireMarvel
//
//  Created by Andrei Maskal on 04/08/2022.
//

import UIKit

class RootController: UIViewController {
        
    var model: [Character]?
    var characters: [Character]?
    
    private let networkProvider = NetworkProvider()

    private var rootView: RootView? {
        guard isViewLoaded else { return nil }
        return view as? RootView
    }
    
    private lazy var searchController: UISearchController = {
        var search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search named character"

        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = RootView()
        setupNavigation()
        setupSeach()
        
        searchController.searchBar.delegate = self
        configureViewDelegate()
        configureNetworkProviderDelegate()
        
        networkProvider.fetchData(characterName: nil) { characters in
            self.model = characters
            self.characters = characters
            self.configureView()
        }
    }
}

extension RootController {
    private func setupNavigation() {
        navigationItem.title = "Characters"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - Search

extension RootController {
    private func setupSeach() {
        navigationItem.searchController = searchController
    }
}

extension RootController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let characterName = searchController.searchBar.text else { return }
        networkProvider.fetchData(characterName: characterName) { characters in
            self.model = characters
            self.configureView()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.text = nil
        searchController.searchBar.resignFirstResponder()
        model = characters
        configureView()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard characters != nil,
              searchController.searchBar.text == ""
        else { return }
        
        self.model = characters
        self.configureView()
    }
}

extension RootController: NetworkProviderDelegate {
    func showAlert(message: String?) {
        let alert = UIAlertController(title: "Error",
                                      message: message != nil ? message : "Nothing was found at your request. Try to enter another request.",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension RootController: RootViewDelegate {
    func changeViewController(with character: Character) {
        let detailViewController = DetailViewController()
        detailViewController.model = character
        
        detailViewController.modalPresentationStyle = .popover
        detailViewController.modalTransitionStyle = .coverVertical
        navigationController?.present(detailViewController, animated: true, completion: nil)
    }
}

extension RootController: ModelDelegate {
    func configureView() {
        guard let model = model else { return }
        rootView?.configureView(with: model)
    }
}

private extension RootController {
    func configureViewDelegate() {
        rootView?.delegate = self
    }
    
    func configureNetworkProviderDelegate() {
        networkProvider.delegate = self
    }
}

