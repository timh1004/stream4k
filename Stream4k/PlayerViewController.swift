//
//  PlayerViewController.swift
//  Stream4k
//
//  Created by timh1004 on 18.01.16.
//  Copyright © 2016 timh1004. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class PlayerViewController: AVPlayerViewController {
    
    var urlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(urlString)
        
        if let url = urlString {
            player = AVPlayer(URL: NSURL(string: url)!)
            player?.play()
        }
    
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
