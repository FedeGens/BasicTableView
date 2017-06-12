//
//  RTViewController.swift
//  Pods
//
//  Created by Federico Gentile on 12/06/17.
//
//

import UIKit

public class RTViewController: UIViewController {
    var table: RootTableView!
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        table.cancelOperation()
    }
}
