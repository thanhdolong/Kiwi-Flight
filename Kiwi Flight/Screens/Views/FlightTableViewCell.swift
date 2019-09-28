//
//  FlightTableViewCell.swift
//  Kiwi Flight
//
//  Created by Thành Đỗ Long on 28/09/2019.
//  Copyright © 2019 Thành Đỗ Long. All rights reserved.
//

import UIKit

public protocol FlightCell: class {
    var fromLabel: UILabel! { get }
    var toLabel: UILabel! { get }
    var priceLabel: UILabel! { get }
    var departureTimeLabel: UILabel! { get }
    var durationLabel: UILabel! { get }
    var bookButton: UIButton! { get }
}

class FlightTableViewCell: UITableViewCell, FlightCell, ReusableView {
    
    @IBOutlet weak var fromLabel: UILabel!
    
    @IBOutlet weak var toLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var departureTimeLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var bookButton: UIButton! {
        didSet {
            bookButton.layer.cornerRadius = 8
            bookButton.backgroundColor = UIColor(named: "backgroundButtonColor")
        }
    }
}
