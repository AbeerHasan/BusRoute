//
//  RoundedButton.swift
//  BusRoute
//
//  Created by Abeer Abbas Saber on 12/8/20.
//  Copyright © 2020 Abeer Abbas Saber. All rights reserved.
//

import UIKit

class CustomizedButton: UIButton {
    
    //---Attributes Appearse on the proprities-----
    @IBInspectable
    var cornerRadius : CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable
    var shadowOpacity : CGFloat = 0{
        didSet {
            self.layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    
    //---------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setUpView()
    }
    
    //----------------------------------------------
    func setUpView(){
        let sceenWidth = UIScreen.main.bounds.width
        if sceenWidth >= 568 {
            self.layer.cornerRadius = cornerRadius * 2.5
            
        }else {
            self.layer.cornerRadius = cornerRadius
        }
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 2
    }
   
}
