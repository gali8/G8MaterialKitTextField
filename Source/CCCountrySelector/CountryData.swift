//
//  CountryData.swift
//  CCCountrySelector
//
//  Created by Chad on 10/17/15 updated by Daniele Galiotto 04/19/16..
//  Copyright © 2015 Chad. All rights reserved.
//

import UIKit

struct CountryData  {
  let name:String
  let countryCode:String
  let phoneCode:String
  
  
  init(name:String,countryCode:String,phoneCode:String){
    self.name = name
    self.countryCode = countryCode
    self.phoneCode = phoneCode
  }
}
