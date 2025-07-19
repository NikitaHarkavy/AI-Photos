//
//  CollectionItem.swift
//  AI Photos
//
//  Created by Никита Горьковой on 7.12.24.
//
import UIKit

enum CollectionItem {
    case outfit(OutFit)
    case hairstyle(Hairstyle)
    
    var creationDate: Date {
        switch self {
        case .outfit(let outfit):
            return outfit.creationDate
        case .hairstyle(let hairstyle):
            return hairstyle.creationDate
        }
    }
    
    var isSelectedForDelete: Bool {
        get {
            switch self {
            case .outfit(let outfit):
                return outfit.isSelectedForDelete
            case .hairstyle(let hairstyle):
                return hairstyle.isSelectedForDelete
            }
        }
        set {
            switch self {
            case .outfit(var outfit):
                outfit.isSelectedForDelete = newValue
                OutFit.all[outfit.id] = outfit
            case .hairstyle(var hairstyle):
                hairstyle.isSelectedForDelete = newValue
                Hairstyle.all[hairstyle.id] = hairstyle
            }
        }
    }
    
    var isLike: Bool {
        get {
            switch self {
            case .outfit(let outfit):
                return outfit.isLike
            case .hairstyle(let hairstyle):
                return hairstyle.isLike
            }
        }
        set {
            switch self {
            case .outfit(var outfit):
                outfit.isLike = newValue
                OutFit.all[outfit.id] = outfit
            case .hairstyle(var hairstyle):
                hairstyle.isLike = newValue
                Hairstyle.all[hairstyle.id] = hairstyle
            }
        }
    }
    
    var id: UUID {
        switch self {
        case .outfit(let outfit):
            return outfit.id
        case .hairstyle(let hairstyle):
            return hairstyle.id
        }
    }
    
    var image: UIImage? {
            switch self {
            case .outfit(let outfit):
                return outfit.image
            case .hairstyle(let hairstyle):
                return hairstyle.image
            }
        }
    
    var originalImage: UIImage? {
            switch self {
            case .outfit(let outfit):
                return outfit.originalImage
            case .hairstyle(let hairstyle):
                return hairstyle.originalImage
            }
        }
    
    var patternImage: UIImage? {
            switch self {
            case .outfit(let outfit):
                return outfit.patternImage
            case .hairstyle(let hairstyle):
                return nil
            }
        }
    
    mutating func update() {
            switch self {
            case .outfit(var outfit):
                outfit.update()
                self = .outfit(outfit)
            case .hairstyle(var hairstyle):
                hairstyle.update()
                self = .hairstyle(hairstyle)
            }
        }
}
