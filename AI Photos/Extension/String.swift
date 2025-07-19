//
//  String.swift
//  AI Photos
//
//  Created by Никита Горьковой on 25.11.24.
//

import Foundation

extension String {
    func styled(as style: TextStyle) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: style.attributes)
    }
}
