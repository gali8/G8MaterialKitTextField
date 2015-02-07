//
//  G8MKTextField.swift
//  G8MaterialKitTextField
//
//  Created by Daniele on 07/02/15.
//  Copyright (c) 2015 Daniele Galiotto. All rights reserved.
//

import UIKit

class G8MKTextField: MKTextField, UITextFieldDelegate {

    @IBInspectable var regexPattern: String? = nil

    @IBInspectable var invalidBorderColor: UIColor = UIColor.lightGrayColor() {
        didSet {
            super.borderColor = invalidBorderColor
        }
    }

    @IBInspectable var invalidLayerColor: UIColor = UIColor(white: 0.45, alpha: 0.5) {
        didSet {
            super.circleLayerColor = invalidLayerColor
        }
    }

    @IBInspectable var invalidTintColor: UIColor = UIColor.blueColor() {
        didSet {
            super.tintColor = invalidTintColor
        }
    }


    @IBInspectable var validBorderColor: UIColor? = UIColor.clearColor()
    @IBInspectable var validCircleLayerColor: UIColor? = UIColor.greenColor()
    @IBInspectable var validTintColor: UIColor? = UIColor.greenColor()

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        var text = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)

        self.isValid(text)

        return true
    }

    private func isValid(text: String) -> Bool {
        if(regexPattern?.isEmpty == false) {
            let regex = NSRegularExpression(pattern: regexPattern!, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
            let range = NSMakeRange(0, countElements(text))
            let match = regex?.rangeOfFirstMatchInString(text, options: NSMatchingOptions.ReportProgress, range: range)

            if( match?.location != NSNotFound) {
                self.borderColor = self.validBorderColor
                self.circleLayerColor = self.validCircleLayerColor
                self.tintColor = self.validTintColor
                return true
            }
            else {
                self.borderColor = self.invalidBorderColor
                self.circleLayerColor = self.invalidCircleLayerColor
                self.tintColor = self.invalidTintColor
                return false
            }
        }

        self.borderColor = self.validBorderColor
        self.circleLayerColor = self.validCircleLayerColor
        self.tintColor = self.validTintColor
        return true
    }

    func isValid() -> Bool {
        return self.isValid(self.text)
    }
    
}
