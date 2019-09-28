//
//  HomeCoordinator.swift
//  Kiwi Flight
//
//  Created by Thành Đỗ Long on 28/09/2019.
//  Copyright © 2019 Thành Đỗ Long. All rights reserved.
//

import UIKit

public class HomeCoordinator: Coordinator {

  // MARK: - Instance Properties
  public var children: [Coordinator] = []
  public let router: Router

  // MARK: - Object Lifecycle
  public init(router: Router) {
    self.router = router
  }

  // MARK: - Instance Methods
  public func present(animated: Bool, onDismissed: (() -> Void)?) {
    let viewController = HomeViewController()
    viewController.delegate = self
    router.present(viewController, animated: animated, onDismissed: onDismissed)
  }
}

extension HomeCoordinator: HomeViewControllerDelegate {
    public func didBookFlightButtonPressed(url: URL?) {
        if let url = url {
            UIApplication.shared.open(url)
        }
    }
}
