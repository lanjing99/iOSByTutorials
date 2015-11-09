//
//  ChecklistsTableViewController.swift
//  Checklists
//
//  Created by lanjing on 11/8/15.
//  Copyright © 2015 lanjing. All rights reserved.
//

import UIKit

class ChecklistsTableViewController: UITableViewController, ItemDetailViewControllerDelegate {

    var items = Array<ChecklistItem>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        configData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("checklistItem", forIndexPath: indexPath)
        configCell(cell, forItem: itemAtIndexPath(indexPath)!)
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            items.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    //MARK: - tableview delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
            let item = itemAtIndexPath(indexPath)!
            item.checked = !item.checked
            configCell(cell, forItem: item)
        }
        
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
        }else if segue.identifier == "editItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
            let item = itemAtIndexPath(indexPath)
            controller.itemToEdit = item
        }
    }

    
    //MARK: - private methods
    private func configData(){
        let row0item = ChecklistItem()
        row0item.text = "Walk the dog"
        row0item.checked = false
        items.append(row0item)
        
        let row1item = ChecklistItem()
        row1item.text = "Brush my teeth"
        row1item.checked = true
        items.append(row1item)
        
        let row2item = ChecklistItem()
        row2item.text = "Learn iOS development"
        row2item.checked = true
        items.append(row2item)
        
        let row3item = ChecklistItem()
        row3item.text = "Soccer practice"
        row3item.checked = false
        items.append(row3item)
        let row4item = ChecklistItem()
        row4item.text = "Eat ice cream"
        row4item.checked = true
        items.append(row4item)
    }

    func itemAtIndexPath(indexPath:NSIndexPath) -> ChecklistItem?{
        if(indexPath.row < 0 || indexPath.row >= items.count){
            return nil
        }else{
            return items[indexPath.row]
        }
    }
    
    private func configCell(cell:UITableViewCell, forItem item:ChecklistItem){
                cell.accessoryType = .DetailDisclosureButton
                if let textLabel = cell.viewWithTag(1000) as! UILabel?{
                    textLabel.text = item.text
                }
       
                let checkLabel = cell.viewWithTag(1001) as! UILabel
                if item.checked {
                    checkLabel.text  = "✅"
                }else{
                    checkLabel.text = ""
                }
    }
    
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        let index = items.indexOf(item)
        let indexPath = NSIndexPath(forRow: index!, inSection: 0)
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation:.Fade)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
                let newRowIndex = items.count
                let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
                let indexPaths = [indexPath]
                items.append(item)
                tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
