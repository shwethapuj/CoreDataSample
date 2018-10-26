//
//  Protocols.swift
//  CoreDataTask
//
//  Created by ios1 on 24/10/18.
//  Copyright © 2018 ios. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView: class {
    
}

extension ReusableView where Self : UIView{
    static var reuseIdentifier : String{
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
