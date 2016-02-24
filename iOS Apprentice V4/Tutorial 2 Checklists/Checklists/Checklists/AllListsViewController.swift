//
//  AllListsViewController.swift
//  Checklists
//
//  Created by lanjing on 11/11/15.
//  Copyright © 2015 lanjing. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {

    var lists : [Checklist]
    
    required init?(coder aDecoder: NSCoder) {
        lists = [Checklist]()
        super.init(coder: aDecoder)
        configData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowChecklist", sender: checklistAtIndex(indexPath))
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("EditChecklist", sender: checklistAtIndex(indexPath))
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lists.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
            cell?.accessoryType = .DetailDisclosureButton
    
        }
    
        let checklist = checklistAtIndex(indexPath)!
        cell!.textLabel?.text = checklist.name

        return cell!
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "ShowChecklist"){
            let checklist = sender as? Checklist
            let viewController = segue.destinationViewController as! ChecklistsTableViewController
            viewController.checklist = checklist
        }else if segue.identifier == "AddChecklist" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            controller.delegate = self
            controller.checklistToEdit = nil
        }else if segue.identifier == "EditChecklist" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            controller.delegate = self
            controller.checklistToEdit = sender as? Checklist

        }
        
    }

    
    //MARK: - Private Methods
    func checklistAtIndex(indexPath:NSIndexPath) -> Checklist?{
        if indexPath.row < 0 || indexPath.row >= lists.count {
            return nil
        }
        return lists[indexPath.row]
    }
    
    
    
    //MARK: - private methods
    private func configData(){
        
        var list = Checklist(name: "Birthdays")
        lists.append(list)
        list = Checklist(name: "Groceries")
        lists.append(list)
        list = Checklist(name: "Cool Apps")
        lists.append(list)
        list = Checklist(name: "To Do")
        lists.append(list)
        
        for list in lists {
            let item = ChecklistItem()
            item.text = "item for \(list.name)"
            list.items.append(item)
        }
    }
    
    
    
    
    
    func documentDirectory()->String{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String{
        return (documentDirectory() as NSString).stringByAppendingPathComponent("Checklist.plist")
    }
    
    func saveChecklistItem(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(lists, forKey: "lists")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadChecklistItems(){
        let path = dataFilePath()
        //        if NSFileManager.defaultManager().fileExistsAtPath(path){
        if let data = NSData(contentsOfFile: path){
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
            lists = unarchiver.decodeObjectForKey("lists") as! [Checklist]
            unarchiver.finishDecoding()
        }
        //        }的
    }
    
    
    
    
    
    
    

    // MARK: - ListDetailViewController delegate
    func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist item: Checklist) {
        let index = lists.count
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        lists.append(item)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist item: Checklist) {
        let index = lists.indexOf(item)
        let indexPath = NSIndexPath(forRow: index!, inSection: 0)
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func addChecklist(sender: AnyObject) {
        performSegueWithIdentifier("AddChecklist", sender: nil)
    }
    
}
