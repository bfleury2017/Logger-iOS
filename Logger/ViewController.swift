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

    @IBAction func start(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Press OK to start log", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default,
            handler: {
                action in
                self.startData()
        })
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func stop(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Press OK to stop log", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive,
            handler: {
                action in
                self.stopData()
        })
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func toggleClear(_ sender: AnyObject) {
        if !toggleOutlet.isOn {
            showDialog()
        }
    }
    
    func showDialog() {
        let alertController = UIAlertController(title: "Clear log?", message: "", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive,
            handler: {
                action in
                self.clearData()
        })
        
        let noAction = UIAlertAction(title: "No", style: .cancel,
            handler: {
                action in
                self.toggleOutlet.isOn = true
        })
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func getFileContents() {
        filePath = dataFilePath()
        
        if (FileManager.default.fileExists(atPath: filePath)) {
            listArray = NSMutableArray(contentsOfFile: filePath)!
            tableView.reloadData()
        }
    }
    
    func clearData() {
        self.getFileContents()
        
        listArray = []
        listArray.write(toFile: filePath, atomically: false)
        
        tableView.reloadData()
    }
    
    func startData() {
        if !toggleOutlet.isOn {
            toggleOutlet.isOn = true
        }
        
        startButton.isEnabled = false
        endButton.isEnabled = true
        toggleOutlet.isEnabled = false
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        startTime = formatter.string(from: date)
    }
    
    func stopData() {
        startButton.isEnabled = true
        endButton.isEnabled = false
        toggleOutlet.isEnabled = true
        
        getFileContents()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        let itemText = startTime + " to " + formatter.string(from: date)
        listArray.add(itemText)
        listArray.write(toFile: filePath, atomically: false)
        
        tableView.reloadData()

    }
    
    func dataFilePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths[0] as NSString
        return documentsDirectory.appendingPathComponent("locations.plist") as String
    }
    

    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            
            var cell = tableView.dequeueReusableCell(withIdentifier: tableIdent) as UITableViewCell!
            
            if (cell == nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: tableIdent)
            }
            
            cell?.textLabel?.text = listArray[indexPath.row] as? String
            return cell!
    }
    
    
    func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int{
            return listArray.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            // Delete the row from the data source
            listArray.removeObject(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            
            listArray.write(toFile: filePath, atomically: false)
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        endButton.isEnabled = false
        getFileContents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

