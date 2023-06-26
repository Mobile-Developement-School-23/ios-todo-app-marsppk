//
//  segmentControlActions.swift
//  toDoList
//
//  Created by Maria Slepneva on 26.06.2023.
//

import UIKit

extension ViewController {
    
    func setImages() {
        segmentControl.setImage(imageLow, forSegmentAt: 0)
        segmentControl.setImage(imageImportant, forSegmentAt: 2)
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            importance = -1
            break
        case 2:
            importance = 1
            break
        default:
            importance = 0
            break
        }
        if textView.text != "Что надо сделать?" && textView.text != "" {
            saveTask.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
        }
    }
    
}
