//
//  SnackBar.swift
//  Laza
//
//  Created by Perdi Yansyah on 10/08/23.
//

import SnackBar
 
class AppSnackBar: SnackBar {
    
    override var style: SnackBarStyle {
        var style = SnackBarStyle()
        style.background = .red
        style.textColor = .green
        return style
    }
}


