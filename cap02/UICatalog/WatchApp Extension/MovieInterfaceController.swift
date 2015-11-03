//
//  MovieInterfaceController.swift
//  UICatalog
//
//  Created by Massimiliano Bigatti on 15/09/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit

class MovieInterfaceController : WKInterfaceController {
    
    @IBOutlet var movie: WKInterfaceMovie!
    
    override func willActivate() {
        super.willActivate()
        
        let url = NSBundle.mainBundle().URLForResource("Video-1", withExtension: "mp4")
        movie.setMovieURL(url!)
        movie.setLoops(true)
    }
    
}
