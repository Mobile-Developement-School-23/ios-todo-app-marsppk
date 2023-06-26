//
//  textViewActions.swift
//  toDoList
//
//  Created by Maria Slepneva on 26.06.2023.
//

import UIKit

extension ViewController {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Что надо сделать?" {
            textView.text = ""
            textView.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            textView.font = UIFont(name: "HelveticaNeue", size: 17)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Что надо сделать?"
            textView.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
            textView.font = UIFont(name: "HelveticaNeue", size: 17)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.invalidateIntrinsicContentSize()
        if textView.text != "" {
            deleteButton.setTitleColor(UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0), for: .normal)
            saveTask.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
        }
        else {
            saveTask.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
            deleteButton.setTitleColor(UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3), for: .normal)
        }
    }
    
}

