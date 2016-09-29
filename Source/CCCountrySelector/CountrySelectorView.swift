//
//  CountrySelectorView.swift
//  CCCountrySelector
//
//  Created by Chad on 10/16/15 updated by DD Daniele Galiotto 10/01/16.
//  Copyright © 2015 Chad. All rights reserved.
//

import UIKit

@objc public protocol CountrySelectorViewDelegate:class {
    func layoutPickView(pickerView:UIPickerView, toolBar: UIToolbar, pickerViewContainer: UIView)
    func showPickInView()->UIView
    func phoneCodeDidChange(myPickerView:UIPickerView,phoneCode:String)
}

@objc public class CountrySelectorView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var flagImageView: UIImageView
    var phoneCodeLabel: UILabel
    public weak var delegate: CountrySelectorViewDelegate?
    
    var countryDataList:[CountryData] = []
    var pickerViewToolbar: UIToolbar
    var pickerView: UIPickerView
    var backgroundBlurEffect: UIBlurEffectStyle = .Light
    var selectedCountryData: CountryData? = nil
    private var pickerViewContainer: UIView
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        flagImageView = UIImageView.init()
        phoneCodeLabel = UILabel.init()
        pickerView = UIPickerView.init()
        pickerViewToolbar = UIToolbar.init()
        pickerViewContainer = UIView()
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        flagImageView = UIImageView.init()
        phoneCodeLabel = UILabel.init()
        pickerView = UIPickerView.init()
        pickerViewToolbar = UIToolbar.init()
        pickerViewContainer = UIView()
        super.init(coder: aDecoder)
        setup()
    }
    
    
    private func setup() {
        
        do {
            let resouceBundle = NSBundle(forClass: self.classForCoder)
            let path = resouceBundle.pathForResource("diallingcode", ofType: "json")
            
            let dataStr = try NSString(contentsOfFile: path!,
                                       encoding: NSUTF8StringEncoding)
            
            
            let jsonData: AnyObject = try! NSJSONSerialization.JSONObjectWithData(
                dataStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!,
                options: [])
            
            var tempCountrylist:[CountryData] = []
            
            if let jsonItems = jsonData as? NSArray {
                for itemDesc in jsonItems {
                    let item: CountryData = CountryData.init(name: itemDesc["name"] as! String!, countryCode: itemDesc["code"] as! String!, phoneCode: (itemDesc["dial_code"] as! String!))
                    
                    tempCountrylist.append(item)
                }
            }
            
            tempCountrylist = tempCountrylist.sort({ (a, b) -> Bool in
                return a.name <= b.name
            })
            countryDataList = tempCountrylist
            
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        self.userInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action:#selector(CountrySelectorView.showPicker))
        self.addGestureRecognizer(tapGesture)
        
        pickerViewToolbar.barStyle = .Default
        pickerViewToolbar.translucent = true
        pickerViewToolbar.translatesAutoresizingMaskIntoConstraints = false

        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(CountrySelectorView.donePickerSelectedRow))
        pickerViewToolbar.setItems([spaceButton, doneButton], animated: false)
        pickerViewToolbar.userInteractionEnabled = true
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        updateView(0)
        
        let blurView = self.blurView(pickerViewContainer, style: backgroundBlurEffect)
        pickerViewContainer.addSubview(blurView)
        pickerViewContainer.addSubview(pickerView)
        pickerViewContainer.addSubview(pickerViewToolbar)
        pickerViewContainer.backgroundColor = UIColor.clearColor()
        pickerViewContainer.translatesAutoresizingMaskIntoConstraints = false

        let toolBarWidth = NSLayoutConstraint(item: pickerViewToolbar, attribute: .Width, relatedBy: .Equal, toItem: pickerView, attribute: .Width, multiplier: 1, constant: 0)
        let toolBarHeight = NSLayoutConstraint(item: pickerViewToolbar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: 44)
        let pickerViewWidth = NSLayoutConstraint(item: pickerView, attribute: .Width, relatedBy: .Equal, toItem: pickerViewContainer, attribute: .Width, multiplier: 1, constant: 0)
        
        let containerVariableBindings = ["pickerView": pickerView, "toolBar": pickerViewToolbar]
        let bottomContainerConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[toolBar]-0-[pickerView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: containerVariableBindings)
        
        pickerViewContainer.addConstraint(pickerViewWidth)
        pickerViewContainer.addConstraint(toolBarHeight)
        pickerViewContainer.addConstraint(toolBarWidth)
        
        pickerViewContainer.addConstraints(bottomContainerConstraints)
        
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        flagImageView.contentMode = .ScaleAspectFit
        self.addSubview(flagImageView)
        flagImageView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: UILayoutConstraintAxis.Horizontal)
        
        phoneCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneCodeLabel.textAlignment = .Center
        self.addSubview(phoneCodeLabel)
        phoneCodeLabel.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: UILayoutConstraintAxis.Horizontal)
        
        let variableBindings = ["flagImageView": flagImageView, "phoneCodeLabel": phoneCodeLabel]
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[flagImageView]-10-[phoneCodeLabel]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: variableBindings)
        self.addConstraints(horizontalConstraints)
        
        let flagImageViewVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[flagImageView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: variableBindings)
        self.addConstraints(flagImageViewVerticalConstraints)
        
        let phoneCodeLabelImageViewVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[phoneCodeLabel]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: variableBindings)
        self.addConstraints(phoneCodeLabelImageViewVerticalConstraints)
        
    }
    
    private func blurView(view: UIView, style: UIBlurEffectStyle = .Light) -> UIView  {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        return blurEffectView
    }
    
    public func setDefaultCountry(country:String) {
        
        let indexToSelect = countryDataList.indexOf({$0.countryCode == country})
        
        if let indexToSelect = indexToSelect {
            pickerView.selectRow(indexToSelect, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: indexToSelect, inComponent: 0)
            selectedCountryData = countryDataList[indexToSelect]
        }
    }
    
    public func setFrequentCountryList(countryList:[String]) {
        
        let currentSelectCountry = countryDataList[pickerView.selectedRowInComponent(0)]
        
        for frequestCountryCode in countryList.reverse() {
            let indexAtFound = countryDataList.indexOf({$0.countryCode == frequestCountryCode})
            if let indexAtFound = indexAtFound {
                countryDataList.insert(countryDataList[indexAtFound], atIndex: 0)
            }
        }
        
        
        if let foundIndex = countryDataList.indexOf({$0.countryCode == currentSelectCountry.countryCode})
        {
            pickerView.selectRow(foundIndex, inComponent: 0, animated: false)
            selectedCountryData = countryDataList[foundIndex]
        }
        
    }
    
    
    func updateView(selectRow:Int) {
        let countryData = countryDataList[selectRow]
        self.phoneCodeLabel.text =  countryData.phoneCode
        self.selectedCountryData = countryData
        self.flagImageView.image =  UIImage(named: countryData.countryCode.lowercaseString)
    }
    
    func showPicker(){
        delegate?.showPickInView().addSubview(pickerViewContainer);
        delegate?.layoutPickView(pickerView, toolBar: pickerViewToolbar, pickerViewContainer: pickerViewContainer)
    }
    
    
    func hidePicker(){
        pickerViewContainer.removeFromSuperview()
    }
    
    
    //MARK: UIPickerView Delegate & DataSource
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryDataList.count;
    }
    
    
    public func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    {
        var customCountryPickView = view as? CustomCountryPickView
        
        let countryData = countryDataList[row]
        customCountryPickView = CustomCountryPickView(countryData: countryData)
        
        return customCountryPickView!
    }
    
    
    public func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return 44.0
        
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let countryData = countryDataList[row]
        delegate?.phoneCodeDidChange(pickerView, phoneCode: countryData.phoneCode)
        updateView(row)
    }
    
    func donePickerSelectedRow() {
        let row = pickerView.selectedRowInComponent(0)
        let countryData = countryDataList[row]
        delegate?.phoneCodeDidChange(pickerView, phoneCode: countryData.phoneCode)
        updateView(row)
        hidePicker()
    }
    
    
    
}
