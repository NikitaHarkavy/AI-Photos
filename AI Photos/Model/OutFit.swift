//
//  OutFit.swift
//  AI Photos
//
//  Created by Никита Горьковой on 5.12.24.
//

import UIKit
import Foundation

struct OutFitPattern {
    var name: String
    var isMan: Bool
    var modelImage: UIImage
    var image: UIImage
    var category: Category
}

struct OutFit: Identifiable, Codable {
    
    static let maxFreeOutFits = 2
    
    @UserDefaultsValue(key: "OutFit.outFitRequestsCount", defaultValue: 0)
    static var outFitRequestsCount: Int
    
    static var hasFreeOutFits: Bool {
            return outFitRequestsCount < maxFreeOutFits
    }
    
    @UserDefaultsValue(key: "OutFit.all", defaultValue: [:])
    static var all: [UUID: OutFit]
    
    static let allUpdatedNotification = Notification.Name("OutFit.allUpdated")
    
    var id: UUID
    var name: String
    var isMan: Bool
    var isLike: Bool = false
    var category: Category?
    var isSelectedForDelete: Bool = false
    var isSelectedForCombine: Bool = false
    var creationDate: Date
    var rootText: String
    
    static let url = ""
    
    init(originalImage: UIImage, image: UIImage, patternImage: UIImage, isMan: Bool, name: String, category: Category?, rootText: String) {
        self.id = .init()
        self.creationDate = .init()
        self.name = name
        self.isMan = isMan
        self.category = category
        self.rootText = rootText
        let data = image.pngData()
        try? FileManager.default.createDirectory(at: imageURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        FileManager.default.createFile(atPath: imageURL.path, contents: data)
        let originalData = originalImage.pngData()
        try? FileManager.default.createDirectory(at: originalImageURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        FileManager.default.createFile(atPath: originalImageURL.path, contents: originalData)
        let patternData = patternImage.pngData()
        try? FileManager.default.createDirectory(at: patternImageURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        FileManager.default.createFile(atPath: patternImageURL.path, contents: patternData)
    }
    
    var imageURL: URL {
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentURL.appendingPathComponent("photo/\(id.uuidString).png")
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
    
    var originalImageURL: URL {
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentURL.appendingPathComponent("originalPhoto/\(id.uuidString).png")
    }
    
    var originalImage: UIImage? {
        guard
            let data = try? Data(contentsOf: originalImageURL),
            let image = UIImage(data: data)
        else {
            return nil
        }
        return image
    }
    
    var patternImageURL: URL {
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentURL.appendingPathComponent("patternPhoto/\(id.uuidString).png")
    }
    
    var patternImage: UIImage? {
        guard
            let data = try? Data(contentsOf: patternImageURL),
            let image = UIImage(data: data)
        else {
            return nil
        }
        return image
    }
    
    func update() {
        Self.all[id] = self
        for (collectionId, var collection) in Collection.all {
            if let outFitIndex = collection.outFits.firstIndex(where: { $0.id == id }) {
                collection.outFits[outFitIndex] = self
                collection.update()
            }
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Self.allUpdatedNotification, object: nil)
            NotificationCenter.default.post(name: Collection.allUpdatedNotification, object: nil)
        }
    }
    
    static func deleteOutFitAndFromCollections(at id: UUID) {
        for (collectionId, var collection) in Collection.all {
            if let index = collection.outFits.firstIndex(where: { $0.id == id }) {
                collection.outFits.remove(at: index)
                collection.update()
            }
        }
        OutFit.all.removeValue(forKey: id)
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Self.allUpdatedNotification, object: nil)
            NotificationCenter.default.post(name: Collection.allUpdatedNotification, object: nil)
        }
    }
    
    static func getImage(initImage: UIImage, clothImage: UIImage, category: Category, completion: @escaping (UIImage?) -> Void) {
        
        print("⚡ [DEBUG] Начало выполнения getImage")
        
        func compressImage(_ image: UIImage, maxDimension: CGFloat = 2000, maxDataSizeMB: Int = 3) -> Data? {
            print("🛠 [DEBUG] Начало сжатия изображения")
            let resizedImage = resizeIfNeeded(image, maxDimension: maxDimension)
            print("🔍 [DEBUG] Размер изображения после ресайза: \(resizedImage.size.width) x \(resizedImage.size.height)")
            
            let maxDataSize = maxDataSizeMB * 1024 * 1024
            var compression: CGFloat = 1.0
            guard var imageData = resizedImage.jpegData(compressionQuality: compression) else {
                print("❌ [ERROR] Не удалось преобразовать изображение в JPEG")
                return nil
            }
            
            if imageData.count <= maxDataSize {
                print("✅ [DEBUG] Размер изображения в норме, дополнительное сжатие не требуется")
                return imageData
            }
            
            while imageData.count > maxDataSize && compression > 0.01 {
                compression -= 0.05
                if let newData = resizedImage.jpegData(compressionQuality: compression) {
                    imageData = newData
                } else {
                    print("❌ [ERROR] Ошибка при сжатии изображения")
                    return nil
                }
            }
            
            print("✅ [DEBUG] Итоговый размер изображения после сжатия: \(imageData.count) байт")
            return imageData
        }
        
        func resizeIfNeeded(_ image: UIImage, maxDimension: CGFloat) -> UIImage { 
            let width = image.size.width
            let height = image.size.height
            
            guard max(width, height) > maxDimension else {
                print("✅ [DEBUG] Изображение уже в допустимых размерах")
                return image
            }
            
            let ratio = maxDimension / max(width, height)
            let newSize = CGSize(width: width * ratio, height: height * ratio)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: CGRect(origin: .zero, size: newSize))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage ?? image
        }
        
        print("🔗 [DEBUG] Создание запроса")
        
        guard let url = URL(string: url) else {
            print("❌ [ERROR] Некорректный URL")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 360
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        print("📡 [DEBUG] Начало подготовки данных для запроса")
        
        guard let initImageData = compressImage(initImage) else {
            print("❌ [ERROR] Ошибка при сжатии initImage")
            completion(nil)
            return
        }
        
        guard let clothImageData = compressImage(clothImage) else {
            print("❌ [ERROR] Ошибка при сжатии clothImage")
            completion(nil)
            return
        }
        
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"cloth_type\"\r\n\r\n".data(using: .utf8)!)
        body.append("upper_body".data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"init_image\"; filename=\"init_image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(initImageData)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"cloth_image\"; filename=\"cloth_image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(clothImageData)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        print("🚀 [DEBUG] Отправка запроса")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ [ERROR] Ошибка сети: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let data = data else {
                    print("❌ [ERROR] Сервер не вернул данные")
                    completion(nil)
                    return
                }
                
                print("📥 [DEBUG] Получен ответ от сервера, попытка декодирования JSON")
                
                do {
                    let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                    guard let imageURL = URL(string: serverResponse.output) else {
                        print("❌ [ERROR] Некорректный URL изображения в ответе сервера")
                        completion(nil)
                        return
                    }
                    
                    print("📡 [DEBUG] Запрос на скачивание изображения: \(imageURL)")
                    
                    URLSession.shared.dataTask(with: imageURL) { imageData, _, imageError in
                        DispatchQueue.main.async {
                            if let imageError = imageError {
                                print("❌ [ERROR] Ошибка загрузки изображения: \(imageError.localizedDescription)")
                                completion(nil)
                                return
                            }
                            
                            guard let imageData = imageData,
                                  let downloadedImage = UIImage(data: imageData) else {
                                print("❌ [ERROR] Полученные данные изображения некорректны")
                                completion(nil)
                                return
                            }
                            
                            print("✅ [DEBUG] Изображение успешно загружено")
                            
                            let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("test_image.jpg")
                            try? imageData.write(to: fileURL)
                            print("💾 [DEBUG] Изображение сохранено во временной директории: \(fileURL)")
                            
                            Self.outFitRequestsCount += 1
                            completion(downloadedImage)
                        }
                    }.resume()
                    
                } catch {
                    print("❌ [ERROR] Ошибка декодирования JSON: \(error)")
                    print("📄 [DEBUG] Данные ответа сервера:\n\(String(data: data, encoding: .utf8) ?? "nil")")
                    completion(nil)
                }
            }
        }.resume()
    }

}

struct ServerResponse: Codable {
    let output: String
}
