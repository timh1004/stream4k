//
//  ViewController.swift
//  Stream4k
//
//  Created by timh1004 on 17.01.16.
//  Copyright © 2016 timh1004. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var tvStations: [MediaItem] = []
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadStations()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if tvStations.count == 0 {
            if let _ = self.defaults.stringForKey("userID") {
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
    @IBAction func reloadButtonPressed(sender: AnyObject) {
        loadStations()
    }
    
    func loadStations() {
        
        if let userID = defaults.stringForKey("userID") {
            if let userTld = defaults.stringForKey("userTld") {
                if userID.characters.count == 8 {
                    
                    let urlWithUserID = "http://\(userID).xbmc.stream4k.\(userTld)"
                    if let contentsOfFile = try? String(contentsOfURL: NSURL(string: urlWithUserID)!) {
                        print(contentsOfFile)
                        
                        
                        let instance = TVStationsController()
                        
                        
                        
                        tvStations = instance.parseM3U(contentsOfFile)!
                        
                        print(tvStations)
                        
                        
                        
                    } else {
                        print("keine website")
                        
                        tvStations = []
                        collectionView!.reloadData()
                        
                        let alertController = UIAlertController(title: "Fehler", message: "Fehler beim laden der M3U.\nFalsche Benutzerkennung/TLD oder Probleme mit der Website?", preferredStyle: .Alert)
                        
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                            self.showUserAlertController()
                        }
                        
                        alertController.addAction(OKAction)
                        
                        self.presentViewController(alertController, animated: true) {
                        }
                        
                    }
                }
            } else {
                showUserAlertController()
            }
        } else {
            print("no id")
            showUserAlertController()
        }
        
        collectionView!.reloadData()
        
    }
    
    func showUserAlertController() {
        
        let alertController = UIAlertController(title: "Benutzerkennung und TLD", message: "Bitte gib deine 8-stellige Benutzerkennung und die TLD (Zum Beispiel \"net\") ein. Diese findest du im Forum unter Kodi innerhalb des M3U Links.", preferredStyle: .Alert)
        
        let loginAction = UIAlertAction(title: "Speichern", style: .Default) { (_) in
            let loginTextField = alertController.textFields![0] as UITextField
            let tldTextField = alertController.textFields![1] as UITextField
            self.defaults.setObject(loginTextField.text, forKey: "userID")
            self.defaults.setObject(tldTextField.text, forKey: "userTld")
            
            print(loginTextField.text)
            print(tldTextField.text)
            self.loadStations()
        }
        loginAction.enabled = true
        
        let cancelAction = UIAlertAction(title: "Abbrechen", style: .Cancel) { (_) in }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            if let userID = self.defaults.stringForKey("userID") {
                if userID.characters.count >= 0 {
                    textField.text = userID
                } else {
                    textField.placeholder = "Benutzerkennung"
                }
            }
            
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            if let userTld = self.defaults.stringForKey("userTld") {
                if userTld.characters.count >= 0 {
                    textField.text = userTld
                } else {
                    textField.placeholder = "Zum Beispiel \"net\""
                }
            }
            
        }
        
        
        alertController.addAction(loginAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
        
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        self.collectionView?.delegate = self
        
        return 1;
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return tvStations.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! SenderCollectionViewCell
        
        let currentItem: MediaItem = tvStations[indexPath.row]
        
        if let label = cell.titleLabel {
            
            if currentItem.urlString == "" {
                label.text = currentItem.title! + "❌"
            } else {
                label.text = currentItem.title
            }
            
            label.alpha = 0.0
            
            
            print(currentItem.urlString)
        }
        
        if let image = UIImage(named: currentItem.title!) {
            cell.imageView.image = image
        } else {
            cell.imageView.image = UIImage(named: "No image")
            
        }
        
        
        return cell
    }
    
    //    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    //    {
    //
    //        let playerViewController = PlayerViewController()
    //        playerViewController.urlString = tvStationsController()!.hlsURLOfTVStationInRegion(region, station: indexPath.row)
    //
    //        self.tabBarController?.presentViewController(playerViewController, animated: true, completion: { () -> Void in
    //
    //        })
    //    }
    
    override func collectionView(collectionView: UICollectionView, didUpdateFocusInContext context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
        
        if let previouslyFocusedIndexPath = context.previouslyFocusedIndexPath {
            let nextCell = self.collectionView?.cellForItemAtIndexPath(previouslyFocusedIndexPath) as! SenderCollectionViewCell
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                nextCell.backgroundColor = UIColor.clearColor()
                nextCell.titleLabel.alpha = 0.0
            })
            
        }
        
        if let nextFocusedIndexPath = context.nextFocusedIndexPath {
            let oldCell = self.collectionView?.cellForItemAtIndexPath(nextFocusedIndexPath) as? SenderCollectionViewCell
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                oldCell?.backgroundColor = UIColor.lightGrayColor()
                oldCell?.titleLabel.alpha = 1.0
            })
            
        }
    }
    
    override func collectionView(collectionView: UICollectionView, shouldUpdateFocusInContext context: UICollectionViewFocusUpdateContext) -> Bool {
        
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        //		collectionView.backgroundColor = UIColor.lightGrayColor()
        
    }
    
    
    override func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPlayer" {
            let destination = segue.destinationViewController as! PlayerViewController
            let index = collectionView?.indexPathsForSelectedItems()![0].row
            destination.urlString = tvStations[index!].urlString!
        }
    }
    
    
}

