//
//  StationsTableViewController.swift
//  Stream4k
//
//  Created by timh1004 on 19.01.16.
//  Copyright © 2016 timh1004. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class StationsTableViewController: UITableViewController {
    
    var tvStations: [MediaItem] = []
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(StationsTableViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        
        //loadStations()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if tvStations.count == 0 {
            if let _ = self.defaults.stringForKey("kodiUrl") {
                loadStations()
            } else {
                showUserAlertController()
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func userButtonPressed(sender: AnyObject) {
        showUserAlertController()
        
    }
    
    func showUserAlertController() {
        
        let alertController = UIAlertController(title: "URL für Kodi", message: "Bitte gib deinen M3U Link für Kodi ein. Diesen findest du im Panel unter Kodi.", preferredStyle: .Alert)
        
        let loginAction = UIAlertAction(title: "Speichern", style: .Default) { (_) in
            let urlTextField = alertController.textFields![0] as UITextField
            //            let tldTextField = alertController.textFields![1] as UITextField
            self.defaults.setObject(urlTextField.text, forKey: "kodiUrl")
            //            self.defaults.setObject(tldTextField.text, forKey: "userTld")
            
            self.loadStations()
        }
        loginAction.enabled = true
        
        let cancelAction = UIAlertAction(title: "Abbrechen", style: .Cancel) { (_) in }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            if let kodiUrl = self.defaults.stringForKey("kodiUrl") {
                if kodiUrl.characters.count >= 0 {
                    textField.text = kodiUrl
                } else {
                    textField.placeholder = "Kodi URL"
                }
            }
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                loginAction.enabled = textField.text?.characters.count >= 0
            }
            
        }
        //        alertController.addTextFieldWithConfigurationHandler { (textField) in
        //            if let userTld = self.defaults.stringForKey("userTld") {
        //                if userTld.characters.count >= 0 {
        //                    textField.text = userTld
        //                } else {
        //                    textField.placeholder = "Zum Beispiel \"net\""
        //                }
        //            }
        //
        //            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
        //                loginAction.enabled = textField.text?.characters.count >= 2
        //            }
        //
        //        }
        
        
        alertController.addAction(loginAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
        
    }
    
    func loadStations() {
        
        if let kodiUrl = defaults.stringForKey("kodiUrl") {
            
            
            print(kodiUrl)
            
            if let contentsOfFile = try? String(contentsOfURL: NSURL(string: kodiUrl)!) {
                print(contentsOfFile)
                
                
                let instance = TVStationsController()
                
                
                
                tvStations = instance.parseM3U(contentsOfFile)!
                
                print(tvStations)
                
                
                
            } else {
                print("keine website")
                
                tvStations = []
                tableView.reloadData()
                
                let alertController = UIAlertController(title: "Fehler", message: "Fehler beim laden der M3U.\nFalsche Benutzerkennung/TLD oder Probleme mit der Website?", preferredStyle: .Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    self.showUserAlertController()
                }
                
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true) {
                }
                
            }
            
            
        } else {
            showUserAlertController()
        }
        
        self.refreshControl!.endRefreshing()
        tableView.reloadData()
        
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        loadStations()
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tvStations.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SenderTableViewCell
        
        let currentItem: MediaItem = tvStations[indexPath.row]
        
        if let label = cell.titleLabel {
            
            if currentItem.urlString == "" {
                label.text = currentItem.title! + "❌"
            } else {
                label.text = currentItem.title
            }
            
            
            
            
            print(currentItem.urlString)
        }
        
        if let image = UIImage(named: currentItem.title!) {
            cell.senderImage.image = image
        } else {
            cell.senderImage.image = UIImage(named: "No image")
            
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let videoURL = NSURL(string: tvStations[indexPath.row].urlString!)!
        let player = AVPlayer(URL: videoURL)
        let playerViewController = AVPlayerViewController()
        
        do {
            
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
        }
            
        catch {
            
            print("Something bad happened. Try catching specific errors to narrow things down")
        }
        playerViewController.player = player
        
        self.presentViewController(playerViewController, animated: false) {
            playerViewController.player!.play()
        }
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
    
    //    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    ////        if segue.identifier == "showPlayer" {
    //
    //            let videoURL = NSURL(string: tvStations[(tableView.indexPathForSelectedRow?.row)!].urlString!)!
    //            let player = AVPlayer(URL: videoURL)
    //            let playerViewController = AVPlayerViewController()
    //            playerViewController.player = player
    //            self.presentViewController(playerViewController, animated: false) {
    //                playerViewController.player!.play()
    ////            }
    ////            let destination = segue.destinationViewController as! PlayerViewController
    ////            let index = tableView.indexPathForSelectedRow?.row
    ////            destination.urlString = tvStations[index!].urlString!
    //        }
    //    }
    
    
}
