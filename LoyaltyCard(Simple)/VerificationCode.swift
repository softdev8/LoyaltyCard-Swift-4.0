//
//  VerificationCode.swift
//  7Leaves Card
//
//  Created by Jason McCoy on 12/17/16.
//  Copyright © 2016 Jason McCoy. All rights reserved.
//

import Foundation


struct VerificationCode {
  var code: String = "";
  var stamps: Int = 0;
  
  init(code: String, stamps: Int? = nil) {
    self.code = code;
    if let stamps = stamps {
      self.stamps = stamps;
    }
  }
}

func == (lhs: VerificationCode, rhs: VerificationCode) -> Bool {
  return lhs.code == rhs.code
}
