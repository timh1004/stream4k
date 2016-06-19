//
//  TVStationsController.swift
//  Stream4k
//
//  Created by timh1004 on 17.01.16.
//  Copyright © 2016 timh1004. All rights reserved.
//

import Foundation

struct MediaItem {
    var title: String?
    var group: String?
    var urlString: String?
}


class TVStationsController {
    
    func parseM3U(contentsOfFile: String) -> [MediaItem]? {
        var mediaItems = [MediaItem]()
        contentsOfFile.enumerateLines({ line, stop in
            if line.hasPrefix("#EXTINF:") {
                //                let infoLine    = line.stringByReplacingOccurrencesOfString("#EXTINF:-1 tvg-logo=\"\"", withString: "")
                //                let infos       = Array(infoLine.componentsSeparatedByString(","))
                //                print(infoLine)
                //                print(line)
                
                let result = line.rangeOfString("tvg-id =",
                    options: NSStringCompareOptions.LiteralSearch,
                    range: line.startIndex..<line.endIndex,
                    locale: nil)
                
                //print(result)
                
                // See if string was found.
                if let range = result {
                    
                    // Display range.
                    //    print(range)
                    
                    // Start of range of found string.
                    let start = range.startIndex.advancedBy(9)
                    
                    //    print(start)
                    
                    // Display string starting at first index.
                    //                    print(line[start..<line.endIndex])
                    let array = (line[start..<line.endIndex].componentsSeparatedByString("\""))
                    //    print("Name = " + array[0] + ", Gruppe = " + array[2])
                    
                    // Display string before first index.
                    //                    var beforeStart = start.predecessor()
                    //    print(line[line.startIndex..<beforeStart])
                    let title = array[3].substringFromIndex(array[3].startIndex.advancedBy(1)).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    print(title)
                    let mediaItem   = MediaItem(title: title, group: array[2], urlString: "")
                    mediaItems.append(mediaItem)
                }
                
                
                //                    print(mediaItem)
                
            } else {
                if mediaItems.count > 0 && line.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != "" {
                    var item = mediaItems.last
                    mediaItems.removeLast()
                    let trimmedLine = line.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    item?.urlString = trimmedLine
//                    print(line)
//                    print(item)
                    mediaItems.append(item!)
                }
            }
        })
        return mediaItems
    }
    
    func getImageUrlForStation(stationName: String) -> String {
        
        if stationName ==  "Sky Sport News HD" {
            return "https://upload.wikimedia.org/wikipedia/de/thumb/e/eb/Sky_Sport_News_HD_off-air_2011.png/799px-Sky_Sport_News_HD_off-air_2011.png"
        } else {
            return "http://dummyimage.com/320x200/ffffff/000000.png&text=No+image"
        }
    
    
    }
    
}
