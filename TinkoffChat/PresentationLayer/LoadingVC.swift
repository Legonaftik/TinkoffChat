//
//  LoadingVC.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 21/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

class LoadingVC: UIViewController {

    private lazy var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        activityIndicator.startAnimating()
    }
}
