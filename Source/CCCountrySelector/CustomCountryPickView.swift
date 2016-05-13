//
//  CustomCountryPickView.swift
//  CustomCountryPickView
//
//  Created by Chad on 10/16/15 updated by DD Daniele Galiotto 04/19/16.
//  Copyright © 2015 Chad. All rights reserved.
//
import UIKit

@objc class CustomCountryPickView: UIView {
    
    let countryData:CountryData
    
    var flagImageView:UIImageView!
    var countryNameLabel:UILabel!
    
    
    init(countryData:CountryData) {
        self.countryData = countryData
        super.init(frame: CGRectZero)
        
        flagImageView = UIImageView()
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        
        flagImageView.image = UIImage(named: countryData.countryCode.lowercaseString)
        flagImageView.contentMode = .ScaleAspectFit
        addSubview(flagImageView)
        
        let flagImageCenterYConstraint = NSLayoutConstraint.init(item: flagImageView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0)
        self.addConstraint(flagImageCenterYConstraint)
        
        countryNameLabel = UILabel()
        countryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        countryNameLabel.text = countryData.name
        addSubview(countryNameLabel)
        
        let countryNameCenterYConstraint = NSLayoutConstraint.init(item: countryNameLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0)
        self.addConstraint(countryNameCenterYConstraint)
        
        
        let variableBindings = [ "flagImageView": flagImageView,"countryNameLabel":countryNameLabel]
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-30-[flagImageView(30)]-10-[countryNameLabel]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: variableBindings)
        self.addConstraints(horizontalConstraints)
        
        let flagImageHeightConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[flagImageView(30)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: variableBindings)
        self.addConstraints(flagImageHeightConstraints)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init error")
    }
    
    
    
}
