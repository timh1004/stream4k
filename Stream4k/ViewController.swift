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
                collectionView!.reloadData()
                
                let alertController = UIAlertController(title: "Fehler", message: "Fehler beim laden der M3U.\nFalsche URL oder Probleme mit der Website?", preferredStyle: .Alert)
                
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
        
        collectionView!.reloadData()
        
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

