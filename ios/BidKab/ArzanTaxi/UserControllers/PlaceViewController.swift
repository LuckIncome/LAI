//
//  PlaceViewController.swift
//  BidKab
//
//  Created by Nursultan on 08.03.2019.
//  Copyright © 2019 Nursultan Zhiyembay. All rights reserved.
//

import UIKit

class PlaceViewController: UIViewController {

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self

        return searchBar
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureMapView()
        setupViews()
    }

    private func configureMapView(){
    }

    private func setupViews(){
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (searchBar) in
            searchBar.top.width.equalToSuperview()

        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (tableView) in
            tableView.top.equalTo(searchBar.snp_bottomMargin)
            tableView.width.bottom.equalToSuperview()
        }
    }

}

extension PlaceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)

        return cell
    }
}

extension PlaceViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    }
}
