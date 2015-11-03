//
//  PickerInterfaceControllers.swift
//  UICatalog
//
//  Created by Massimiliano Bigatti on 23/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit

let kTitleKey = "kTitleKey"
let kCaptionKey = "kCaptionKey"
let kImageName = "kImageName"

let itemDataArray = [
    [
        kTitleKey: "Cascata",
        kCaptionKey: "Natura",
        kImageName: "image1"
    ],
    [
        kTitleKey: "Valli",
        kCaptionKey: "Natura",
        kImageName: "image2"
    ],
    [
        kTitleKey: "Montagne",
        kCaptionKey: "Natura",
        kImageName: "image3"
    ],
    [
        kTitleKey: "Lago",
        kCaptionKey: "Natura",
        kImageName: "image4"
    ],
    [
        kTitleKey: "Pupazzetto",
        kCaptionKey: "Oggetti",
        kImageName: "image5"
    ]
]

class AbstractPickerInterfaceController : WKInterfaceController {
    
    @IBOutlet var picker: WKInterfacePicker!
    
    func populatePicker(picker : WKInterfacePicker, keys: [String] ) {
        var items = [WKPickerItem]()
        
        for itemData in itemDataArray {
            let item = WKPickerItem()
            
            if keys.contains(kTitleKey) {
                item.title = itemData[kTitleKey]
            }
            if keys.contains(kCaptionKey) {
                item.caption = itemData[kCaptionKey]
            }
            if keys.contains(kImageName) {
                if let imageName = itemData[kImageName] {
                    item.contentImage = WKImage(imageName: imageName)
                }
            }
            items.append(item)
        }
        
        picker.setItems(items)
    }
    
}

class ListPickerInterfaceController : AbstractPickerInterfaceController {
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        populatePicker(picker, keys: [kTitleKey, kCaptionKey])
    }
    
}

class StackPickerInterfaceController : AbstractPickerInterfaceController {
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        populatePicker(picker, keys: [kImageName])
    }
    
}

class SequencePickerInterfaceController : AbstractPickerInterfaceController {
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        populatePicker(picker, keys: [kImageName])
    }
    
}

class CoordinatedImagesPickerInterfaceController : WKInterfaceController {
    
    @IBOutlet var group: WKInterfaceGroup!
    @IBOutlet var picker: WKInterfacePicker!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        //
        // init picker
        //
        var images: [UIImage]! = []
        var pickerItems: [WKPickerItem]! = []
        
        for index in 1...60 {
            let name = "progress-\(index)"
            images.append(UIImage(named: name)!)
            
            let pickerItem = WKPickerItem()
            pickerItem.title = "\(index)"
            pickerItems.append(pickerItem)
        }
        
        let progressImages = UIImage.animatedImageWithImages(images, duration: 0.0)
        group.setBackgroundImage(progressImages)
        
        picker.setCoordinatedAnimations([group])
        picker.setItems(pickerItems)
        picker.setSelectedItemIndex(15)
    }
}

