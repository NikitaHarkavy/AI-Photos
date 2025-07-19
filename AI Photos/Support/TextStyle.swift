//
//  TextStyle.swift
//  AI Photos
//
//  Created by Никита Горьковой on 25.11.24.
//

import UIKit

enum TextStyle {
    
    case SemiBold15
    case SemiBold16
    case SemiBold17
    case SemiBold18
    case SemiBold20
    case SemiBold22
    case SemiBold23
    case SemiBold24
    case SemiBold26
    case SemiBold54
    
    case Regular12
    case Regular14
    case Regular15
    case Regular16
    case Regular17
    case Regular21
    case Regular16Placeholder
    
    case Medium14
    case Medium16
    case Medium18
    case Medium19
    
    var attributes: [NSAttributedString.Key: Any] {
        switch self {
        case .SemiBold15:
            let font = UIFont(name: "Inter-SemiBold", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .semibold)
            return [
                .font: font,
            ]
            
        case .SemiBold16:
            let font = UIFont(name: "Inter-SemiBold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .semibold)
            return [
                .font: font,
            ]
            
        case .SemiBold17:
            let font = UIFont(name: "Inter-SemiBold", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .semibold)
            return [
                .font: font,
            ]
            
        case .SemiBold18:
            let font = UIFont(name: "Inter-SemiBold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .semibold)
            return [
                .font: font,
            ]
            
        case .SemiBold20:
            let font = UIFont(name: "Inter-SemiBold", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .semibold)
            return [
                .font: font,
            ]
            
        case .SemiBold22:
            let font = UIFont(name: "Inter-SemiBold", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .semibold)
            return [
                .font: font,
            ]
            
        case .SemiBold23:
            let font = UIFont(name: "Inter-SemiBold", size: 23) ?? UIFont.systemFont(ofSize: 23, weight: .semibold)
            return [
                .font: font,
            ]
            
        case .SemiBold24:
            let font = UIFont(name: "Inter-SemiBold", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .semibold)
            return [
                .font: font,
            ]
            
        case .SemiBold26:
            let font = UIFont(name: "Inter-SemiBold", size: 26) ?? UIFont.systemFont(ofSize: 26, weight: .semibold)
            return [
                .font: font,
            ]
            
        case .SemiBold54:
            let font = UIFont(name: "Inter-SemiBold", size: 54) ?? UIFont.systemFont(ofSize: 54, weight: .semibold)
            return [
                .font: font,
            ]
            
        case .Regular12:
            let font = UIFont(name: "Inter-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
            return [
                .font: font,
            ]
            
        case .Regular14:
            let font = UIFont(name: "Inter-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
            return [
                .font: font,
            ]
            
        case .Regular15:
            let font = UIFont(name: "Inter-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .regular)
            return [
                .font: font,
            ]
            
        case .Regular16:
            let font = UIFont(name: "Inter-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
            return [
                .font: font,
            ]
            
        case .Regular16Placeholder:
            let font = UIFont(name: "Inter-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
            return [
                .font: font,
                .strokeColor: UIColor.greyCollection
            ]
            
        case .Regular17:
            let font = UIFont(name: "Inter-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .regular)
            return [
                .font: font,
            ]
            
        case .Regular21:
            let font = UIFont(name: "Inter-Regular", size: 21) ?? UIFont.systemFont(ofSize: 21, weight: .regular)
            return [
                .font: font,
            ]
            
        case .Medium14:
            let font = UIFont(name: "Inter-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
            return [
                .font: font,
            ]
            
        case .Medium16:
            let font = UIFont(name: "Inter-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
            return [
                .font: font,
            ]
            
        case .Medium18:
            let font = UIFont(name: "Inter-Medium", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .medium)
            return [
                .font: font,
            ]
            
        case .Medium19:
            let font = UIFont(name: "Inter-Medium", size: 19) ?? UIFont.systemFont(ofSize: 19, weight: .medium)
            return [
                .font: font,
            ]
        }
    }
}

