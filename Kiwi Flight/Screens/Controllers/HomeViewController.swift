//
//  HomeViewController.swift
//  Kiwi Flight
//
//  Created by Thành Đỗ Long on 28/09/2019.
//  Copyright © 2019 Thành Đỗ Long. All rights reserved.
//

import UIKit

public protocol HomeViewControllerDelegate: class {
    func didBookFlightButtonPressed(url: URL?)
}

class HomeViewController: UIViewController {
    
    let flightService = NetworkingManager()
    var viewModel: FlightViewModel?
    var indicator: UIView?
    
    weak var delegate: HomeViewControllerDelegate?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(refresh(_:)),
                                 for: UIControl.Event.valueChanged)

        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Flight Offers")
        return refreshControl
    }()
    
    var homeView: HomeView! {
        guard isViewLoaded else { return nil }
        return (view as! HomeView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        homeView.tableView.delegate = homeView
        homeView.tableView.dataSource = self
        homeView.tableView.addSubview(refreshControl)
        
        registerCellForReuse()
        requestFlightOffers()
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        self.requestFlightOffers()
    }
    

    @IBAction func didBookFlighButtonPressed(_ sender: UIButton) {
        let url = viewModel?.getURL(from: sender.tag)
        delegate?.didBookFlightButtonPressed(url: url)
    }
    
    private func registerCellForReuse() {
        homeView.tableView.register(FlightTableViewCell.nib, forCellReuseIdentifier: FlightTableViewCell.reuseIdentifier)
    }
    
    private func requestFlightOffers() {
        indicator = showActivityIndicatory(onView: self.view)
        
        flightService.fetchFlights { (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.viewModel = FlightViewModel(flights: response)
                    self.homeView.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                
                guard let indicator = self.indicator else { return }
                self.removeIndicator(indicator: indicator)
            }
        }
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
