//
//  StampButton.swift
//  7Leaves Card
//
//  Created by Jason McCoy on 1/24/17.
//  Copyright © 2016 Jason McCoy. All rights reserved.
//

import UIKit


class StampButton: UIButton {
    
    // MARK: Variables
    
    private(set) var _redeemed: Bool = false
    
    // MARK: Public Methods
    
    func setRedeemed(_ redeemed: Bool) {
        if _redeemed == redeemed {
            return
        }
        
        _redeemed = redeemed
        
        DispatchQueue.main.async {
            if self._redeemed {
                self.playExplicitBounceAnimation()
                return
            }
        }
    }
}
