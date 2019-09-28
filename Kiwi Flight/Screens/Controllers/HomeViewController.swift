//
//  HomeViewController.swift
//  Kiwi Flight
//
//  Created by Thành Đỗ Long on 28/09/2019.
//  Copyright © 2019 Thành Đỗ Long. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var viewModel: FlightViewModel?
    
    var homeView: HomeView! {
        guard isViewLoaded else { return nil }
        return (view as! HomeView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        homeView.tableView.delegate = homeView
        homeView.tableView.dataSource = self
        
        registerCellForReuse()
        
        let network = NetworkingManager()
        network.fetchFlights { (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.viewModel = FlightViewModel(flights: response)
                    self.homeView.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    private func registerCellForReuse() {
        homeView.tableView.register(FlightTableViewCell.nib, forCellReuseIdentifier: FlightTableViewCell.reuseIdentifier)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRowsInSection ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = homeView.tableView.dequeueReusableCell(withIdentifier: FlightTableViewCell.reuseIdentifier, for: indexPath) as? FlightTableViewCell else {
            return self.tableView(tableView, cellForRowAt: indexPath)
        }
        
        viewModel?.configureFlightCell(cell, for: indexPath)
        cell.selectionStyle = .none
        
        return cell
    }
}
