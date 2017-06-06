//
//  ViewController.swift
//  Logger
//
//  Created by Brian Fleury on 2/12/16.
//  Copyright © 2016 Fleury. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toggleOutlet: UISwitch!
    
    var filePath: String = ""
    let tableIdent = "TableIdent"
    var listArray: NSMutableArray = []
    var startTime: String!

    @IBAction func start(sender: AnyObject) {
        let alertController = UIAlertController(title: "Press OK to start log", message: "", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default,
            handler: {
                action in
                self.startData()
        })
        
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func stop(sender: AnyObject) {
        let alertController = UIAlertController(title: "Press OK to stop log", message: "", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Destructive,
            handler: {
                action in
                self.stopData()
        })
        
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func toggleClear(sender: AnyObject) {
        if !toggleOutlet.on {
            showDialog()
        }
    }
    
    func showDialog() {
        let alertController = UIAlertController(title: "Clear log?", message: "", preferredStyle: .Alert)
        let yesAction = UIAlertAction(title: "Yes", style: .Destructive,
            handler: {
                action in
                self.clearData()
        })
        
        let noAction = UIAlertAction(title: "No", style: .Cancel,
            handler: {
                action in
                self.toggleOutlet.on = true
        })
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)

        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func getFileContents() {
        filePath = dataFilePath()
        
        if (NSFileManager.defaultManager().fileExistsAtPath(filePath)) {
            listArray = NSMutableArray(contentsOfFile: filePath)!
            tableView.reloadData()
        }
    }
    
    func clearData() {
        self.getFileContents()
        
        listArray = []
        listArray.writeToFile(filePath, atomically: false)
        
        tableView.reloadData()
    }
    
    func startData() {
        if !toggleOutlet.on {
            toggleOutlet.on = true
        }
        
        startButton.enabled = false
        endButton.enabled = true
        toggleOutlet.enabled = false
        
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        
        startTime = formatter.stringFromDate(date)
    }
    
    func stopData() {
        startButton.enabled = true
        endButton.enabled = false
        toggleOutlet.enabled = true
        
        getFileContents()
        
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        
        let itemText = startTime + " to " + formatter.stringFromDate(date)
        listArray.addObject(itemText)
        listArray.writeToFile(filePath, atomically: false)
        
        tableView.reloadData()

    }
    
    func dataFilePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory = paths[0] as NSString
        return documentsDirectory.stringByAppendingPathComponent("locations.plist") as String
    }
    

    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
            
            var cell = tableView.dequeueReusableCellWithIdentifier(tableIdent) as UITableViewCell!
            
            if (cell == nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: tableIdent)
            }
            
            cell.textLabel?.text = listArray[indexPath.row] as? String
            return cell
    }
    
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int{
            return listArray.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            // Delete the row from the data source
            listArray.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            
            listArray.writeToFile(filePath, atomically: false)
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        endButton.enabled = false
        getFileContents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

