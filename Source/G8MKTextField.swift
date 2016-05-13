//
//  G8MKTextField.swift
//  G8MaterialKitTextField
//
//  Created by Daniele on 08/05/16.
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
    case Name = "^[a-zA-ZÀ-ÿ\\s']+$" //8
    case Email = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$" //9
    case USBirthDate = "^(0[1-9]|1[012])[-/.](0[1-9]|[12][0-9]|3[01])[-/.](19|20)\\d\\d$" //10 MM/dd/yyyy
    case Year = "^\\d{4}$" //11
    case YearFrom1900To2099 = "^(19|20)\\d{2}$" //12
    case InternationalPhoneNumber = "^([0]{2}|[+])\\d{1,4} ?\\d{3} ?\\d{10}$" //13 es. +0000 000 0000000000 +00 000 0000000000 ....
    case InternationalPhoneNumber11 = "^([0]{2}|[+])\\d{2} ?\\d{3} ?\\d{5,8}$" //14 es. +00 000 0000000 ....
    case InternationalEPPPhoneNumber = "^\\+[0-9]{1,3}\\.[0-9]{4,14}(?:x.+)?$" //15
    case USPhoneNumber = "1?\\W*([2-9][0-8][0-9])\\W*([2-9][0-9]{2})\\W*([0-9]{4})(\\se?x?t?(\\d*))?" //16
    case EasyPassword = "(.{4,30})" //17 es. abcd
    case ComplexPassword = "((?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{4,30})" //18 es. 1num1CHAR1char
    case EUBirthDate = "^(0[1-9]|[12][0-9]|3[01])[-/.](0[1-9]|1[012])[-/.](19|20)\\d\\d$" //19 es. dd/MM/yyyy
    case AllPhoneNumbers = "^([0]{2}|[+])\\d{1,3}[.\\-()0-9x\\s]{8,}$" //20 all phone numbers
}

let regexPatterTypes: [RegexPatternTypes] = [.CustomOrNone, .ZeroOrMoreChars, .OneOrMoreChars, .OneChar, .Bool, .ZeroOrMoreNumbers, .OneOrMoreNumbers, .OneNumber, .Name, .Email, .USBirthDate, .Year, .YearFrom1900To2099, .InternationalPhoneNumber, .InternationalPhoneNumber11, .InternationalEPPPhoneNumber, .USPhoneNumber, .EasyPassword, .ComplexPassword, .EUBirthDate, .AllPhoneNumbers]

@IBDesignable
class G8MKTextField: MKTextField, UITextFieldDelegate, CountrySelectorViewDelegate {
    
    //MARK: - Class
    
    class func areValid(textFields: [G8MKTextField]) -> Bool{
        for txf in textFields {
            if(txf.isValid() == false) {
                return false
            }
        }
        return true
    }
    
    //MARK: - Instance
    
    private var regexPattern: String? = nil
    @IBInspectable var regexPatternCustom: String? = nil { //executed for first
        didSet {
            regexPattern = regexPatternCustom
        }
    }
    @IBInspectable var regexPatternEnum: Int = 0  { //executed for second
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
    
    @IBInspectable var defaultTextColor: UIColor = UIColor.darkGrayColor() {
        didSet {
            super.textColor = defaultTextColor
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
    @IBInspectable var resignFirstResponderOnReturn: Bool = true
    
    @IBInspectable var invalidTextColor: UIColor = UIColor.redColor()
    @IBInspectable var invalidBottomBorderColor: UIColor = UIColor.clearColor()
    @IBInspectable var invalidCircleLayerColor: UIColor = UIColor.redColor()
    @IBInspectable var invalidTintColor: UIColor = UIColor.redColor()
    
    @IBInspectable var validTextColor: UIColor = UIColor.redColor()
    @IBInspectable var validBottomBorderColor: UIColor = UIColor.clearColor()
    @IBInspectable var validCircleLayerColor: UIColor = UIColor.greenColor()
    @IBInspectable var validTintColor: UIColor = UIColor.greenColor()
    
    @IBInspectable var leftCountryCodeViewLeftPadding: CGFloat = 0
    @IBInspectable var leftCountryCodeViewTopPadding: CGFloat = 0
    @IBInspectable var leftCountryCodeViewRightPadding: CGFloat = 0
    @IBInspectable var leftCountryCodeViewBottomPadding: CGFloat = 0
    
    var leftCountryCodeViewPickerViewBackgroundColor: UIColor?
    var leftCountryCodeViewPresentationView: UIView? = nil
    var leftCountryCodeView: CountrySelectorView? = nil
    @IBInspectable var hasLeftCountryCodeView: Bool = false {
        didSet {
            if hasLeftCountryCodeView == true {
                leftCountryCodeView?.removeFromSuperview()
                let frame = CGRect(x: 0, y: 0 , width: 50, height: self.frame.size.height)
                leftCountryCodeView = CountrySelectorView(frame: frame)
                leftCountryCodeView?.phoneCodeLabel.frame = CGRectZero
                //leftCountryCodeView?.phoneCodeLabel.removeFromSuperview
                leftCountryCodeView?.phoneCodeLabel.textColor = UIColor.clearColor() //so the text is hidden but clickable. This is the reason for width at 50
                
                self.addSubview(leftCountryCodeView!)
                let locale = NSLocale.currentLocale()
                let code = (locale.objectForKey(NSLocaleCountryCode) as! String)
                
                leftCountryCodeView?.delegate = self
                leftCountryCodeView?.setDefaultCountry(code)
                leftCountryCodeView?.setFrequentCountryList([code])
            }
            else {
                leftCountryCodeView?.removeFromSuperview()
            }
        }
    }
    
    @IBInspectable var leftImageLeftPadding: CGFloat = 0
    @IBInspectable var leftImageTopPadding: CGFloat = 0
    @IBInspectable var leftImageRightPadding: CGFloat = 0
    @IBInspectable var leftImageBottomPadding: CGFloat = 0
    
    var leftImageView: UIImageView? = nil
    @IBInspectable var leftImage: UIImage? = nil {
        didSet {
            self.leftImageView?.removeFromSuperview()
            self.leftImageView = UIImageView(image: leftImage)
            if let imgView = self.leftImageView {
                imgView.backgroundColor = UIColor.clearColor()
                imgView.contentMode = UIViewContentMode.ScaleAspectFit
                self.addSubview(imgView)
            }
        }
    }
    
    @IBInspectable var rightImageLeftPadding: CGFloat = 0
    @IBInspectable var rightImageTopPadding: CGFloat = 0
    @IBInspectable var rightImageRightPadding: CGFloat = 0
    @IBInspectable var rightImageBottomPadding: CGFloat = 0
    
    var rightImageView: UIImageView? = nil
    @IBInspectable var rightImage: UIImage? = nil {
        didSet {
            self.rightImageView?.removeFromSuperview()
            self.rightImageView = UIImageView(image: rightImage)
            if let imgView = self.rightImageView {
                imgView.backgroundColor = UIColor.clearColor()
                imgView.contentMode = UIViewContentMode.ScaleAspectFit
                self.addSubview(imgView)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
    }
    
    private func calculateRect(r: CGRect) -> CGRect{
        var rect = r
        var hasLeft = false
        
        var tempRectWidth = self.frame.size.width
        
        if let leftImgView = self.leftImageView {
            hasLeft = true
            leftImgView.frame = CGRectMake(self.leftImageLeftPadding, self.leftImageTopPadding, self.frame.size.height - self.leftImageLeftPadding - self.leftImageRightPadding, self.frame.size.height - self.leftImageTopPadding - self.leftImageBottomPadding)
            tempRectWidth = tempRectWidth - self.frame.size.height
            rect.origin.x = self.frame.size.height
            rect.size.width = tempRectWidth
        }
        
        if let countryCodeView = self.leftCountryCodeView {
            hasLeft = true
            let ccFrame = countryCodeView.frame
            countryCodeView.frame = CGRectMake(self.leftCountryCodeViewLeftPadding, self.leftCountryCodeViewTopPadding, ccFrame.size.width - self.leftCountryCodeViewLeftPadding - self.leftCountryCodeViewRightPadding, ccFrame.size.height - self.leftCountryCodeViewTopPadding - self.leftCountryCodeViewBottomPadding)
            tempRectWidth = tempRectWidth - ccFrame.size.width
            rect.origin.x = self.frame.size.height
            rect.size.width = tempRectWidth
        }
        
        if let rightImgView = self.rightImageView {
            rightImgView.frame = CGRectMake(self.frame.size.width - self.rightImageLeftPadding - self.frame.size.height - self.rightImageRightPadding, self.rightImageTopPadding, self.frame.size.height - self.rightImageLeftPadding - self.rightImageRightPadding, self.frame.size.height - self.rightImageTopPadding - self.rightImageBottomPadding)
            rect.size.width = hasLeft ? rect.size.width - rightImgView.frame.size.width : self.frame.size.width - self.frame.size.height
        }
        
        return rect
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        let rect = super.textRectForBounds(bounds)
        return self.calculateRect(rect)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        super.placeholder = self.placeholder
        let rect = super.placeholderRectForBounds(bounds)
        return self.calculateRect(rect)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        let rect = super.editingRectForBounds(bounds)
        return self.calculateRect(rect)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.isValid()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text == nil ? "" : (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        self.isValid(text)
        return true
    }
    
    private func isValid(text: String) -> Bool {
        if(regexPattern?.isEmpty == false) {
            let regex = try? NSRegularExpression(pattern: regexPattern!, options: NSRegularExpressionOptions.CaseInsensitive)
            let range = NSMakeRange(0, text.characters.count)
            let match = regex?.rangeOfFirstMatchInString(text, options: NSMatchingOptions.ReportProgress, range: range)
            
            if( match?.location != NSNotFound) {
                self.textColor = self.validTextColor
                self.tintColor = self.validTintColor
                self.bottomBorderColor = self.validBottomBorderColor
                self.circleLayerColor = self.validCircleLayerColor
                return true
            }
            else {
                self.textColor = self.invalidTextColor
                self.tintColor = self.invalidTintColor
                self.bottomBorderColor = self.invalidBottomBorderColor
                self.circleLayerColor = self.invalidCircleLayerColor
                return false
            }
        }
        
        self.textColor = self.defaultTextColor
        self.tintColor = self.defaultTintColor
        self.bottomBorderColor = self.defaultBottomBorderColor
        self.circleLayerColor = self.defaultCircleLayerColor
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if self.resignFirstResponderOnReturn == true {
            self.resignFirstResponder()
        }
        return true
    }
    
    func isValid() -> Bool {
        return self.isValid(self.text!)
    }
    
    //MARK: CountrySelectorViewDelegate
    func layoutPickView(pickerView:UIPickerView, toolBar: UIToolbar, pickerViewContainer: UIView) {

        toolBar.tintColor = leftCountryCodeViewPickerViewBackgroundColor
        pickerView.backgroundColor = leftCountryCodeViewPickerViewBackgroundColor

        let variableBindings = ["pickerViewContainer": pickerViewContainer]
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[pickerViewContainer]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: variableBindings)
        let bottomConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[pickerViewContainer]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: variableBindings)

        if leftCountryCodeViewPresentationView != nil {
            leftCountryCodeViewPresentationView?.addConstraints(horizontalConstraints)
            leftCountryCodeViewPresentationView?.addConstraints(bottomConstraints)
        }
        else {
            self.superview?.addConstraints(horizontalConstraints)
            self.superview?.addConstraints(bottomConstraints)
        }
    }
    
    func showPickInView()->UIView {
        if self.isFirstResponder() {
            self.resignFirstResponder()
        }
        return leftCountryCodeViewPresentationView ?? self.superview!
    }
    
    func phoneCodeDidChange(myPickerView: UIPickerView, phoneCode: String) {
        self.text = phoneCode
        self.isValid()
    }
}
