//
//  SavedCell.swift
//  AI Photos
//
//  Created by Никита Горьковой on 28.11.24.
//
import UIKit

class SavedCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var repeatButton: UIButton!
    
    var repeatButtonTapped: (() -> Void)?
    
    @IBAction func repeatButtonTapped(_ sender: Any) {
        repeatButtonTapped?()
    }
}
