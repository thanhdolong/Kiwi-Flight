//
//  HomeView.swift
//  Kiwi Flight
//
//  Created by Thành Đỗ Long on 28/09/2019.
//  Copyright © 2019 Thành Đỗ Long. All rights reserved.
//

import UIKit

class HomeView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    
}

extension HomeView: UITableViewDelegate {
    
}
