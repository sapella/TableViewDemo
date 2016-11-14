//
//  ViewController.swift
//  TableViewDemo
//
//  Created by Shawn Pellacani on 24/10/2016.
//  Copyright © 2016 Shawn Pellacani. All rights reserved.
//

import UIKit
class TableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
   
    @IBOutlet weak var tableView: UITableView!
    
    var items = [DataItem]()
    var otherItems = [DataItem]()
    var allItems = [[DataItem]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        for i in 1...12 {
            if i > 9 {
                items.append(DataItem(title: "Title #\(i)", subtitle: "This is subtitle #\(i)", imageName: "img\(i).jpg"))
            } else {
                items.append(DataItem(title: "Title #0\(i)", subtitle: "This is subtitle #0\(i)", imageName: "img0\(i).jpg"))
            }
        }
        for i in 1...12 {
            if i > 9 {
                otherItems.append(DataItem(title: "Another Title #\(i)", subtitle: "This is another subtitle #\(i)", imageName: "anim\(i).jpg"))
            } else {
                otherItems.append(DataItem(title: "Another Title #0\(i)", subtitle: "This is another subtitle #0\(i)", imageName: "anim0\(i).jpg"))
            }
        }
        
        allItems.append(items)
        allItems.append(otherItems)
        
        tableView.allowsSelectionDuringEditing = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let addedRow = isEditing ? 1 : 0
        
        return allItems [section].count + addedRow
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if indexPath.row >= allItems[indexPath.section].count && isEditing {
            cell.textLabel?.text = "Add New Item"
            cell.detailTextLabel?.text = nil
            cell.imageView?.image = nil
        } else {
            
            let item = allItems[indexPath.section][indexPath.row]
        
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.subtitle
        
            if let imageView = cell.imageView, let itemImage = item.image {
                imageView.image = itemImage
           } else {
            cell.imageView?.image = nil
           }
       }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section #\(section)"
        
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                allItems[indexPath.section].remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with : UITableViewRowAnimation.fade)
            }   else if editingStyle == .insert {
                let newData = DataItem(title: "New Data", subtitle: "", imageName: nil)
                allItems[indexPath.section].append(newData)
                tableView.insertRows(at: [indexPath], with: .fade)
        }
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        if editing {
           tableView.beginUpdates()
            
            for (index, sectionItems) in allItems.enumerated() {
                let indexPath = NSIndexPath(row: sectionItems.count, section: index)
                tableView.insertRows(at: [indexPath as IndexPath], with: .fade)
            }
            
            tableView.endUpdates()
            tableView.setEditing(true, animated: true)
        }  else {
            tableView.beginUpdates()
            
            for (index, sectionItems) in allItems.enumerated() {
                let indexPath = NSIndexPath(row: sectionItems.count, section:index)
                tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
            }
            
            tableView.endUpdates()
            tableView.setEditing(false, animated: true)
       }
    }

    func tableView(_ tablView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        let sectionItems = allItems[indexPath.section]
        if indexPath.row >= sectionItems.count {
            return .insert
        } else {
            return .delete
        }
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let sectionItems = allItems[indexPath.section]
        if isEditing && indexPath.row < sectionItems.count {
            return nil
        }
        return indexPath
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sectionItems = allItems[indexPath.section]
        if indexPath.row >= sectionItems.count && isEditing {
            self.tableView(tableView, commit: .insert, forRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let sectionItems = allItems[indexPath.section]
        if indexPath.row >= sectionItems.count && isEditing {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var fromSectionItems = allItems[sourceIndexPath.section]
        var toSectionItems = allItems[destinationIndexPath.section]
        let itemToMove = fromSectionItems[sourceIndexPath.row]
        
        if sourceIndexPath.section == destinationIndexPath.section {
            if destinationIndexPath.row != sourceIndexPath.row {
                swap(&toSectionItems[destinationIndexPath.row], &toSectionItems[sourceIndexPath.row])
            }
        } else {
            toSectionItems.insert(itemToMove, at: destinationIndexPath.row)
            fromSectionItems.remove(at: sourceIndexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        let sectionItems = allItems[proposedDestinationIndexPath.section]
        if proposedDestinationIndexPath.row >= sectionItems.count {
            return IndexPath(row: sectionItems.count - 1, section: proposedDestinationIndexPath.section)
        }
        return proposedDestinationIndexPath
    }    
}














