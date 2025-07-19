//
//  OutFitCell.swift
//  AI Photos
//
//  Created by Никита Горьковой on 26.11.24.
//

import UIKit

class OutFitCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkbox: CheckboxView!
    
    var onCheckboxTapped: (() -> Void)?
    
    func configure(outFit: OutFit?, hairstyle: Hairstyle?, isDeleteMode: Bool?, isCombineMode: Bool?) {
        if let hairstyle = hairstyle {
            imageView.image = hairstyle.image
            imageView.backgroundColor = .clear
            nameLabel.attributedText = hairstyle.name.styled(as: .Regular16)
        } else if let outFit = outFit {
            imageView.image = outFit.image
            imageView.backgroundColor = .clear
            nameLabel.attributedText = outFit.name.styled(as: .Regular16)
        }
        
        var isSelected = false
        if isDeleteMode == true {
            if let hairstyle = hairstyle {
                isSelected = hairstyle.isSelectedForDelete
            } else if let outFit = outFit {
                isSelected = outFit.isSelectedForDelete
            }
        } else if isCombineMode == true {
            if let hairstyle = hairstyle {
                isSelected = hairstyle.isSelectedForCombine
            } else if let outFit = outFit {
                isSelected = outFit.isSelectedForCombine
            }
        }
        
        checkbox.isChecked = isSelected
        checkbox.isHidden = !(isDeleteMode == true || isCombineMode == true)
        
        checkbox.onCheckboxTapped = { [weak self] in
            self?.onCheckboxTapped?()
        }
    }
    
    func makeHidden() {
        UIView.animate(withDuration: 0.3) {
            self.checkbox.alpha = 0
        } completion: { _ in
            self.checkbox.isHidden = true
        }
    }
    
    func makeNotHidden() {
        self.checkbox.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.checkbox.alpha = 1
        }
    }
}
