//
//  RootTableView.swift
//  MyTableView
//
//  Created by Federico Gentile on 21/12/16.
//  Copyright © 2016 Federico Gentile. All rights reserved.
//

import UIKit

/// A RootTableView to manage rows and section in a better way
public class RootTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    private var sections = [Section]()
    public var tableDelegate: RootTableViewDelegate?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        self.delegate = self
        self.dataSource = self
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    //MARK: Delegate methods
    //Section
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sections[section].header
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (self.sections[section].headerHeight == nil) ? UITableViewAutomaticDimension : sections[section].headerHeight!
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return (self.sections[section].header == nil) ? UITableViewAutomaticDimension : 10
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    //Row
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.sections[indexPath.section].rows[indexPath.row].cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.sections[indexPath.section].rows[indexPath.row].height == nil) ? UITableViewAutomaticDimension : self.sections[indexPath.section].rows[indexPath.row].height!
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].rows.count
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableDelegate?.RootTableViewSelected(row: self.sections[indexPath.section].rows[indexPath.row].cell, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            if (self.tableDelegate?.RootTableViewLoadOtherCells?() != nil) {
                self.tableDelegate?.RootTableViewLoadOtherCells!()
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let elem = sections[sourceIndexPath.section].rows[sourceIndexPath.row]
        sections[sourceIndexPath.section].rows.remove(at: sourceIndexPath.row)
        sections[destinationIndexPath.section].rows.insert(elem, at: destinationIndexPath.row)
    }
    
    //MARK: Manage Section methods
    /// Add a section to your tableView
    ///
    /// - Parameters:
    ///   - view: header view (optional)
    ///   - rows: rows array (optional)
    public func addSection(view: UIView?, rows: [UITableViewCell]?) {
        var section = Section()
        section.set(cells: rows)
        section.header = view
        self.sections.append(section)
        self.reloadData()
    }
    
    /// Set a view as section header for your section in a specific index
    ///
    /// - Parameters:
    ///   - view: header view (optional)
    ///   - atIndex: section index
    ///   - forHeight: header height (optional)
    public func setSectionHeader(view: UIView?, atIndex: Int, forHeight: CGFloat?) {
        self.sections[atIndex].header = view
        self.sections[atIndex].headerHeight = forHeight
        self.reloadData()
    }
    
    /// Set a section header height
    ///
    /// - Parameters:
    ///   - atIndex: section index
    ///   - forHeight: section height
    public func setSectionHeaderHeight(atIndex: Int, forHeight: CGFloat?) {
        self.sections[atIndex].headerHeight = forHeight
        self.reloadData()
    }
    
    /// Remove a section header in a specific index
    ///
    /// - Parameter atIndex: section index
    public func removeSectionHeader(atIndex: Int) {
        self.sections[atIndex].header = nil
        self.reloadData()
    }
    
    /// Remove a section at a specific indexx
    ///
    /// - Parameter atIndex: section index
    public func removeSection(atIndex: Int) {
        self.sections.remove(at: atIndex)
        self.reloadData()
    }
    
    
    //MARK: Manage Cells Methods
    /// Set all tableView cells as a bidimensional array. It creates a Section for every sub-array
    ///
    /// - Parameter cellsMatrix: bi-dimensional array formed by cells
    public func setAllCells(cellsMatrix: [[UITableViewCell]]) {
        self.sections.removeAll()
        for cells in cellsMatrix {
            var section = Section()
            section.set(cells: cells)
            self.sections.append(section)
        }
        self.reloadData()
    }
    
    /// Add a cell in a section
    ///
    /// - Parameters:
    ///   - cell: cell to add
    ///   - inSection: section index
    public func add(cell: UITableViewCell, inSection: Int) {
        add(cell: cell, inSection: inSection, atIndex: nil, forHeight: nil)
    }
    
    /// Add a cell in a section to a specific index
    ///
    /// - Parameters:
    ///   - cell: cell to add
    ///   - inSection: section index
    ///   - atIndex: cell index
    public func add(cell: UITableViewCell, inSection: Int, atIndex: Int?) {
        add(cell: cell, inSection: inSection, atIndex: atIndex, forHeight: nil)
    }
    
    /// Add a cell in a section to a specific index with a defined height
    ///
    /// - Parameters:
    ///   - cell: cell to add
    ///   - inSection: section index
    ///   - atIndex: cell index
    ///   - forHeight: cell height
    public func add(cell: UITableViewCell, inSection: Int, atIndex: Int?, forHeight: CGFloat?) {
        if sections.count == 0 {
            let section = Section()
            sections.append(section)
        }
        sections[inSection].add(cell: cell, atIndex: atIndex, forHeight: forHeight)
        self.reloadData()
    }
    
    /// Set cell's height ina a section at a specific index
    ///
    /// - Parameters:
    ///   - height: cell's height
    ///   - inSection: section index
    ///   - atIndex: cell index
    public func setCell(height: CGFloat, inSection: Int, atIndex: Int) {
        sections[inSection].rows[atIndex].height = height
        self.reloadData()
    }
    
    /// Remove a cell in a section
    ///
    /// - Parameters:
    ///   - inSection: section index
    ///   - atIndex: cell index
    public func removeCell(inSection: Int, atIndex: Int) {
        sections[inSection].rows.remove(at: atIndex)
        self.reloadData()
    }
    
    /// Remove all cells in a section
    ///
    /// - Parameter inSection: section index
    public func removeAllCells(inSection: Int) {
        sections[inSection].rows.removeAll()
        self.reloadData()
    }
    
    public func getAllCells(inSection section: Int) -> [UITableViewCell] {
        var cellArr = [UITableViewCell]()
        for row in sections[section].rows {
            cellArr.append(row.cell)
        }
        return cellArr
    }
}


//MARK: Models
struct Section {
    var header: UIView? = nil
    var headerHeight: CGFloat? = nil
    var rows = [Row]()
    
    mutating func set(cells: [UITableViewCell]?) {
        if cells == nil {
            return
        }
        
        for cell in cells! {
            var newCell = Row()
            newCell.cell = cell
            rows.append(newCell)
        }
    }
    
    mutating func add(cell: UITableViewCell, atIndex: Int?, forHeight: CGFloat?) {
        var newCell = Row()
        newCell.cell = cell
        newCell.height = forHeight
        
        if atIndex == nil {
            rows.append(newCell)
        } else {
            rows.insert(newCell, at: atIndex!)
        }
    }
}

struct Row {
    var cell = UITableViewCell()
    var height: CGFloat? = nil
}


//MARK: Protocol
@objc public protocol RootTableViewDelegate {
    /// Returns a cell and an index when a row is tapped
    ///
    /// - Parameters:
    ///   - row: returned cell
    ///   - Index: returned index
    func RootTableViewSelected(row: UITableViewCell, at Index: IndexPath)
    
    /// Called when the tableView reach the bottom. Useful to load new cells
    @objc optional func RootTableViewLoadOtherCells()
}
