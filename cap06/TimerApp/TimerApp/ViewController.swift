//
//  ViewController.swift
//  TimerApp
//
//  Created by Massimiliano Bigatti on 18/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import UIKit
import WatchConnectivity


class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let styles = [
        "style0": "Rubino",
        "style1": "Bianco",
        "style2": "Default",
        "style3": "Completa"
    ]
    

    //
    // MARK: - UIPickerViewDataSource
    //
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return styles.count
    }
    
    
    //
    // MARK: - UIPickerViewDelegate
    //
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return styles["style\(row)"]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            delegate.notification.category = "style\(row)"
        }
    }
    
}

