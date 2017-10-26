//
//  CustomPickerView.swift
//  BranchBlogBasic
//
//  Created by Joseph Geraghty on 10/24/17.
//  Copyright © 2017 Branch. All rights reserved.
//

import Foundation
import UIKit

class CustomPickerView : UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var pickerData : [String]!
    var pickerTextField : UITextField!
    var selectionHandler : ((_ selectedText: String, _ row: Int) -> Void)?

    
    init(pickerData: [String], dropdownField: UITextField, barButtons: [UIBarButtonItem]?) {
        super.init(frame: CGRect.zero)
        
        self.pickerData = pickerData
        self.pickerTextField = dropdownField
        self.delegate = self
        self.dataSource = self
        
        DispatchQueue.main.async {
            if pickerData.count > 0 {
                self.pickerTextField.text = self.pickerData[0]
                self.pickerTextField.isEnabled = true
                
                // ToolBar
                let toolBar = UIToolbar()
                toolBar.barStyle = .default
                toolBar.isTranslucent = true
                toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
                toolBar.sizeToFit()
                toolBar.setItems(barButtons, animated: false)
                toolBar.isUserInteractionEnabled = true
                self.pickerTextField.inputAccessoryView = toolBar
            } else {
                self.pickerTextField.text = nil
                self.pickerTextField.isEnabled = false
            }
        }
    }
    
    convenience init(pickerData: [String], dropdownField: UITextField, barButtons: [UIBarButtonItem]?, onSelect selectionHandler : @escaping (_ selectedText: String, _ row: Int) -> Void) {
        
        self.init(pickerData: pickerData, dropdownField: dropdownField, barButtons: barButtons)
        
        self.selectionHandler = selectionHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        pickerTextField.text = pickerData[row]
        selectionHandler!(pickerData[row], row)
    }
    
    
}


extension UITextField {
    func loadDropdownData(data: [String], barButtons: [UIBarButtonItem]?, onSelect selectionHandler : @escaping (_ selectedText: String, _ row: Int) -> Void) {
        self.inputView = CustomPickerView(pickerData: data, dropdownField: self, barButtons: barButtons, onSelect: selectionHandler)
    }
}
