//
//  Collection.swift
//  AI Photos
//
//  Created by Никита Горьковой on 26.11.24.
//

import UIKit

struct Collection: Identifiable, Codable {
    
    @UserDefaultsValue(key: "Collection.all", defaultValue: [:])
    static var all: [UUID: Collection]
    
    static let allUpdatedNotification = Notification.Name("Collection.allUpdated")
    
    var id: UUID
    var name: String
    var outFits: [OutFit]
    var hairstyles: [Hairstyle]
    var creationDate: Date
    
    init(image: UIImage, name: String, outFits: [OutFit], hairstyles: [Hairstyle]) {
        self.id = .init()
        self.name = name
        self.outFits = outFits
        self.hairstyles = hairstyles
        self.creationDate = .init()
        let data = image.pngData()
        try? FileManager.default.createDirectory(at: imageURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        FileManager.default.createFile(atPath: imageURL.path, contents: data)
    }
    
    var imageURL: URL {
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentURL.appendingPathComponent("collectionPhoto/\(id.uuidString).png")
    }
    
    var image: UIImage? {
        guard
            let data = try? Data(contentsOf: imageURL),
            let image = UIImage(data: data)
        else {
            return nil
        }
        return image
    }
    
    func update() {
        Self.all[id] = self
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Self.allUpdatedNotification, object: nil)
        }
    }
    
    static func deleteCollection(at id: UUID) {
        Collection.all.removeValue(forKey: id)
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Self.allUpdatedNotification, object: nil)
        }
    }
    
    static func deleteOutFitFromCollection(collectionId: UUID, outFitId: UUID) {
        if var collection = Collection.all[collectionId] {
            if let index = collection.outFits.firstIndex(where: { $0.id == outFitId }) {
                collection.outFits.remove(at: index)
                collection.update()
            }
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Self.allUpdatedNotification, object: nil)
        }
    }
    
    static func deleteHairstyleFromCollection(collectionId: UUID, hairstyleId: UUID) {
        if var collection = Collection.all[collectionId] {
            if let index = collection.hairstyles.firstIndex(where: { $0.id == hairstyleId }) {
                collection.hairstyles.remove(at: index)
                collection.update()
            }
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Self.allUpdatedNotification, object: nil)
        }
    }
}

struct Category: Codable, Equatable {
    var key: String
    var title: String
}
