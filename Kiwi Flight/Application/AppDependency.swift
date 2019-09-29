//
//  AppDependency.swift
//  Kiwi Flight
//
//  Created by Thành Đỗ Long on 29/09/2019.
//  Copyright © 2019 Thành Đỗ Long. All rights reserved.
//

import Foundation

public protocol Container: class {
    var networkingManager: Networking { get }
    var flightService: FlightService { get }
}

final class AppDependency: Container {
    lazy var networkingManager: Networking = NetworkingManager()
    lazy var flightService: FlightService = FlightServiceImpl(networking: networkingManager)
}
