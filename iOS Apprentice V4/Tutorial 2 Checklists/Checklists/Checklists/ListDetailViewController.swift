//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by lanjing on 11/11/15.
//  Copyright © 2015 lanjing. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(controller: ListDetailViewController)
    func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist item: Checklist)
    func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist item: Checklist)
}

class ListDetailViewController: UITableViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    var checklistToEdit: Checklist?
    weak var delegate: ListDetailViewControllerDelegate?
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        if let item = checklistToEdit {
            title = "Edit \(item.name)"
            textField.text = item.name
            doneBarButton.enabled = true
        }
    }
    
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = checklistToEdit {
            item.name = textField.text!
            delegate?.listDetailViewController(self, didFinishEditingChecklist: item)
        }else{
            let item = Checklist()
            item.name = textField.text!
            delegate?.listDetailViewController(self, didFinishAddingChecklist: item)
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        doneBarButton.enabled = (newText.length > 0)
        return true
    }

}
