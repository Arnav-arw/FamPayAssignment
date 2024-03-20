//
//  Constants.swift
//  FamPayAssignment
//
//  Created by Arnav Singhal on 19/03/24.
//

import Foundation
import SwiftUI

let deviceWidth = UIScreen.main.bounds.width
let deviceHeight = UIScreen.main.bounds.height

func fromHexCodes(_ hexCodes: [String]) -> [Color] {
    var colors: [Color] = []
    for hexCode in hexCodes {
        if let color = Color(hex: hexCode) {
            colors.append(color)
        }
    }
    return colors
}
