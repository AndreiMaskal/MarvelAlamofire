//
//  UIColor+Ext.swift
//  AlamofireMarvel
//
//  Created by Andrei Maskal on 04/08/2022.
//

import UIKit

infix operator |: AdditionPrecedence
public extension UIColor {

 
    static func | (lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return lightMode }

        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
        }
    }
}
