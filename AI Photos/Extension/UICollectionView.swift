//
//  UICollectionView.swift
//  AICombine
//
//  Created by Mikhail Verenich on 15.02.2024.
//

import UIKit

extension UICollectionView {
    
    func dequeueReusableCell<T: UICollectionViewCell>(of cellClass: T.Type, suffix: String = "", for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: cellClass) + suffix, for: indexPath) as! T
    }
    
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        let identifier = String(describing: cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(of supplementaryViewClass: T.Type, kind: String, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: supplementaryViewClass), for: indexPath) as! T
    }
    
    func register<T: UICollectionReusableView>(_ supplementaryViewClass: T.Type, kind: String) {
        let identifier = String(describing: supplementaryViewClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }
    
}
