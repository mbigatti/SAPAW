//
//  InterfaceController.swift
//  WatchApp Extension
//
//  Created by Massimiliano Bigatti on 18/10/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation


let kNumberOfVideoClips = 5

class InterfaceController : WKInterfaceController {
    
    @IBOutlet var table: WKInterfaceTable!
    
    var videoClipDataArray = [VideoClipData]()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        loadVideoClips()
        populateTable()
    }
    
    func loadVideoClips() {
        let bundle = NSBundle.mainBundle()
        
        for (var i = 1; i <= kNumberOfVideoClips; i++) {
            let url = bundle.URLForResource("Videos/Video-\(i)", withExtension: "mp4")
            let videoClipData = VideoClipData(url: url, imageName: "Poster-\(i)")
            
            videoClipDataArray.append(videoClipData)
        }
    }
    
    func populateTable() {
        table.setNumberOfRows(videoClipDataArray.count, withRowType: "VideoRowController")
        
        for (var i = 0; i < videoClipDataArray.count; i++) {
            let row = table.rowControllerAtIndex(i) as! VideoRowController
            row.setDescription("Clip #\(i)")
            
            if let imageName = videoClipDataArray[i].imageName {
                row.setImageName(imageName)
            }
        }
        
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        if let url = videoClipDataArray[rowIndex].url {
            presentMediaPlayerControllerWithURL(url, options: nil) { (didPlayToEnd, endTime, error) -> Void in
                print("didPlayToEnd \(didPlayToEnd), endTime \(endTime), error \(error)")
            }
        }
    }
    
}

class VideoClipData {
    var url : NSURL?
    var imageName : String?
    
    init(url: NSURL?, imageName: String?) {
        self.url = url
        self.imageName = imageName
    }
}

