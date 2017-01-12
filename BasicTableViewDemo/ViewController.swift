//
//  ViewController.swift
//  MyTableView
//
//  Created by Federico Gentile on 21/12/16.
//  Copyright © 2016 Federico Gentile. All rights reserved.
//

import UIKit

class ViewController: UIViewController, RootTableViewDelegate {

    @IBOutlet weak var tableView_: BasicTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView_.tableDelegate = self
        
        var arrayCell = [UITableViewCell]()
        var text = "micio "
        for _ in 0...10 {
            let cell = tableView_.createBasicTextImageCell(withString: text, image: UIImage(named: "gattino")!)
            tableView_.addBasicCell(withType: .textSubtitleImage, inSection: 0, atIndex: nil, withTitle: "ciao", withSubtitle: "cane", withImage: UIImage(named: "gattino")!)
            text += text
            arrayCell.append(cell)
        }
        tableView_.addSection(view: nil, rows: arrayCell)
        tableView_.addBasicHeader(withType: .text, inSection: 0, withTitle: "LALALALA", backgroundColor: nil, withHeight: nil)
        tableView_.addBasicHeader(withType: .text, inSection: 1, withTitle: "Header quello bello", backgroundColor: nil, withHeight: nil)
    }

    func RootTableViewSelected(row: UITableViewCell, at Index: IndexPath) {
        if row.reuseIdentifier == BasicCellType.textSubtitleImage.rawValue {
            (row as! BasicTextSubtitleImageCell).cellSubtitleLabel.text = ((row as! BasicTextSubtitleImageCell).cellSubtitleLabel.text == nil) ? "miao" : (row as! BasicTextSubtitleImageCell).cellSubtitleLabel.text! + " miao"
            tableView_.reloadData()
        }
    }
}

