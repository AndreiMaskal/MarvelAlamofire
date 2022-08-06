//
//  RootView.swift
//  AlamofireMarvel
//
//  Created by Andrei Maskal on 04/08/2022.
//

import UIKit

class RootView: UIView {
    
    func configureView(with model: [Character]) {
        self.model = model
        charactersTableView.reloadData()
    }
    
    var delegate: RootViewDelegate?
    var model = [Character]()


    private lazy var charactersTableView = UITableView(frame: self.bounds, style: UITableView.Style.plain)

    init() {
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        setupHierarchy()
        setupLayout()
        setupView()
        
        setupDataSource()
        setupDelegate()
        setupTableCells()
    }
    
    private func setupHierarchy() {
        self.addSubview(charactersTableView)
    }

    private func setupLayout() {
        charactersTableView.addConstraints(top: self.topAnchor, left: self.leadingAnchor, right: self.trailingAnchor, bottom: self.bottomAnchor)
    }
    
    private func setupView() {
        self.backgroundColor = .gray

    }
    
    private func setupDataSource() {
        charactersTableView.dataSource = self
    }

    private func setupDelegate() {
        charactersTableView.delegate = self
    }
    
    private func setupTableCells() {
        charactersTableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.identifier)
    }
}

extension RootView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension RootView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = model[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.identifier, for: indexPath) as? CharacterTableViewCell else {
            return UITableViewCell()
        }

        cell.configureCell(with: model)
        return cell
    }
}

extension RootView {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let character = model[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)

        delegate?.changeViewController(with: character)
    }
}
