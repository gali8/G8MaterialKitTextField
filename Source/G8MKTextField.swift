//
//  G8MKTextField.swift
//  G8MaterialKitTextField
//
//  Created by Daniele on 07/02/15.
//  Copyright (c) 2015 Daniele Galiotto. All rights reserved.
//

import UIKit

enum RegexPatternTypes: String {
    case CustomOrNone = "" //0
    case ZeroOrMoreChars = "^.*$" //1
    case OneOrMoreChars = "^.+$" //2
    case OneChar = "^.$" //3
    case Bool = "^[0-1]?$" //4
    case ZeroOrMoreNumbers = "^[0-9]*$" //5
    case OneOrMoreNumbers = "^[0-9]+$" //6
    case OneNumber = "^[0-9]$" //7
    case Name = "^[a-zA-Z\\s]+$" //8
    case Email = "^[_a-z0-9-]+(\\.[_a-z0-9-]+)*@[a-z0-9-]+(\\.[a-z0-9-]+)*(\\.[a-z]{2,4})$" //9
    case USBirthDate = "^(0[1-9]|1[012])[-/.](0[1-9]|[12][0-9]|3[01])[-/.](19|20)\\d\\d$" //10 MM/dd/yyyy
    case Year = "^\\d{4}$" //11
    case YearFrom1900To2099 = "^(19|20)\\d{2}$" //12
    case InternationalPhoneNumber = "^([0]{2}|[+])\\d{1,4} ?\\d{3} ?\\d{10}$" //13 es. +0000 000 0000000000 +00 000 0000000000 ....
    case InternationalPhoneNumber11 = "^([0]{2}|[+])\\d{2} ?\\d{3} ?\\d{7}$" //14 es. +00 000 0000000 ....
    case InternationalEPPPhoneNumber = "^\\+[0-9]{1,3}\\.[0-9]{4,14}(?:x.+)?$" //15
    case USPhoneNumber = "1?\\W*([2-9][0-8][0-9])\\W*([2-9][0-9]{2})\\W*([0-9]{4})(\\se?x?t?(\\d*))?" //16
}
let regexPatterTypes: [RegexPatternTypes] = [.CustomOrNone, .ZeroOrMoreChars, .OneOrMoreChars, .OneChar, .Bool, .ZeroOrMoreNumbers, .OneOrMoreNumbers, .OneNumber, .Name, .Email, .USBirthDate, .Year, .YearFrom1900To2099, .InternationalPhoneNumber, .InternationalPhoneNumber11, .InternationalEPPPhoneNumber, .USPhoneNumber]

@IBDesignable
class G8MKTextField: MKTextField, UITextFieldDelegate {

    private var regexPattern: String? = nil
    @IBInspectable var regexPatternCustom: String? = nil { //executed for first
        didSet {
            regexPattern = regexPatternCustom
        }
    }
    @IBInspectable var regexPatternEnum: Int = 0 { //executed for second
        didSet {
            if regexPatternEnum != 0 && regexPatterTypes.count > regexPatternEnum {
                regexPattern = (regexPatterTypes[regexPatternEnum] as RegexPatternTypes).rawValue
            }
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.blackColor() {
        didSet {
            super.layer.borderColor = borderColor.CGColor
        }
    }

    @IBInspectable var defaultBottomBorderColor: UIColor = UIColor.lightGrayColor() {
        didSet {
            super.bottomBorderColor = defaultBottomBorderColor
        }
    }
    @IBInspectable var defaultCircleLayerColor: UIColor = UIColor(white: 0.45, alpha: 0.5) {
        didSet {
            super.circleLayerColor = defaultCircleLayerColor
        }
    }
    @IBInspectable var defaultTintColor: UIColor = UIColor.blueColor() {
        didSet {
            super.tintColor = defaultTintColor
        }
    }

    @IBInspectable var invalidBottomBorderColor: UIColor = UIColor.greenColor()
    @IBInspectable var invalidCircleLayerColor: UIColor = UIColor.greenColor()
    @IBInspectable var invalidTintColor: UIColor = UIColor.greenColor()

    @IBInspectable var validBottomBorderColor: UIColor = UIColor.greenColor()
    @IBInspectable var validCircleLayerColor: UIColor = UIColor.greenColor()
    @IBInspectable var validTintColor: UIColor = UIColor.greenColor()

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
    }

    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        super.placeholder = self.placeholder
        return super.placeholderRectForBounds(bounds)
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.isValid()
        return true
    }
    
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
                self.tintColor = self.validTintColor
                self.bottomBorderColor = self.validBottomBorderColor
                self.circleLayerColor = self.validCircleLayerColor
                return true
            }
            else {
                self.tintColor = self.invalidTintColor
                self.bottomBorderColor = self.invalidBottomBorderColor
                self.circleLayerColor = self.invalidCircleLayerColor
                return false
            }
        }

        self.tintColor = self.defaultTintColor
        self.bottomBorderColor = self.defaultBottomBorderColor
        self.circleLayerColor = self.defaultCircleLayerColor
        return true
    }

    func isValid() -> Bool {
        return self.isValid(self.text)
    }
    
    
}
