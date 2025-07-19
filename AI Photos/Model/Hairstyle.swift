//
//  Hairstyle.swift
//  AI Photos
//
//  Created by Никита Горьковой on 5.12.24.
//
import UIKit

struct HairstylePattern {
    var name: String
    var isMen: Bool
    var hairStyleText: String
    var modelImage: UIImage
}

struct Hairstyle: Identifiable, Codable {
    
    static let maxFreeHairstyles = 2
    
    @UserDefaultsValue(key: "Hairstyle.hairstyleRequestsCount", defaultValue: 0)
    static var hairstyleRequestsCount: Int
    
    static var hasFreeHairstyles: Bool {
            return hairstyleRequestsCount < maxFreeHairstyles
    }
    
    @UserDefaultsValue(key: "Hairstyle.all", defaultValue: [:])
    static var all: [UUID: Hairstyle]
    
    static let allUpdatedNotification = Notification.Name("Hairstyle.allUpdated")
    
    var id: UUID
    var name: String
    var isMan: Bool
    var isLike: Bool = false
    var isSelectedForDelete: Bool = false
    var isSelectedForCombine: Bool = false
    var creationDate: Date
    var rootText: String
    
    static let urlPost = ""
    static let urlGet = ""
    
    init(originalImage: UIImage, image: UIImage, isMan: Bool, name: String, rootText: String) {
        self.id = .init()
        self.creationDate = .init()
        self.name = name
        self.isMan = isMan
        self.rootText = rootText
        let data = image.pngData()
        try? FileManager.default.createDirectory(at: imageURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        FileManager.default.createFile(atPath: imageURL.path, contents: data)
        let originalData = originalImage.pngData()
        try? FileManager.default.createDirectory(at: originalImageURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        FileManager.default.createFile(atPath: originalImageURL.path, contents: originalData)
    }
    
    var imageURL: URL {
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentURL.appendingPathComponent("photoHair/\(id.uuidString).png")
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
        return documentURL.appendingPathComponent("originalPhotoHair/\(id.uuidString).png")
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
    
    func update() {
        Self.all[id] = self
        for (collectionId, var collection) in Collection.all {
            if let hairstyleIndex = collection.hairstyles.firstIndex(where: { $0.id == id }) {
                collection.hairstyles[hairstyleIndex] = self
                collection.update()
            }
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Self.allUpdatedNotification, object: nil)
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Collection.allUpdatedNotification, object: nil)
        }
    }
    
    static func deleteHairstyleAndFromCollections(at id: UUID) {
        for (collectionId, var collection) in Collection.all {
            if let index = collection.hairstyles.firstIndex(where: { $0.id == id }) {
                collection.hairstyles.remove(at: index)
                collection.update()
            }
        }
        Hairstyle.all.removeValue(forKey: id)
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Self.allUpdatedNotification, object: nil)
            NotificationCenter.default.post(name: Collection.allUpdatedNotification, object: nil)
        }
    }
    
    static func getImage(initImage: UIImage, isMen: Bool, hairStyle: String, completion: @escaping (UIImage?) -> Void) {
        
        func compressImage(_ image: UIImage, maxDimension: CGFloat = 2000, maxDataSizeMB: Int = 3) -> Data? {
            // 1. Убедимся, что размеры не больше 2000
            let resizedImage = resizeIfNeeded(image, maxDimension: maxDimension)
            
            // 2. Пытаемся сжать до тех пор, пока не уложимся в лимит 3 MB
            let maxDataSize = maxDataSizeMB * 1024 * 1024 // 3 MB в байтах
            var compression: CGFloat = 1.0
            
            guard var imageData = resizedImage.jpegData(compressionQuality: compression) else {
                return nil
            }
            
            // Если и без сжатия размер уже в норме, можно вернуть сразу
            if imageData.count <= maxDataSize {
                return imageData
            }
            
            // Иначе сжимаем в цикле, пока не уложимся или не достигнем минимума
            while imageData.count > maxDataSize && compression > 0.01 {
                compression -= 0.05
                if let newData = resizedImage.jpegData(compressionQuality: compression) {
                    imageData = newData
                } else {
                    return nil // если вдруг не получилось сгенерировать data
                }
            }
            
            // В этот момент либо мы уложились в лимит, либо дошли до нижней границы compression
            return imageData
        }

        /// Функция, которая проверяет, что ширина/высота не превышает `maxDimension`.
        /// Если превышает — масштабирует пропорционально до нужного лимита.
         func resizeIfNeeded(_ image: UIImage, maxDimension: CGFloat) -> UIImage {
            let width = image.size.width
            let height = image.size.height
            
            // Если обе стороны и так не превышают maxDimension, просто возвращаем исходное
            guard max(width, height) > maxDimension else {
                return image
            }
            
            // Считаем коэффициент масштабирования
            let ratio = maxDimension / max(width, height)
            let newWidth = width * ratio
            let newHeight = height * ratio
            
            // Отрисовываем новое изображение
            let newSize = CGSize(width: newWidth, height: newHeight)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: CGRect(origin: .zero, size: newSize))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // На случай, если что-то пошло не так, возвращаем исходное
            return newImage ?? image
        }
        
        print("📤 Начинаем отправку POST-запроса...")
        
        // Укажите корректный эндпоинт
        guard let urlPost = URL(string: "") else {
            print("❌ Invalid URL")
            completion(nil)
            return
        }
        
        var requestPost = URLRequest(url: urlPost)
        requestPost.httpMethod = "POST"
        requestPost.timeoutInterval = 360
        
        // Создаём boundary
        let boundary = "Boundary-\(UUID().uuidString)"
        requestPost.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Преобразуем переданные изображения в Data
        guard let initImageData = compressImage(initImage) else {
            print("❌ Ошибка конвертации initImage в Data")
            completion(nil)
            return
        }
        
        // Формируем тело запроса
        var body = Data()
        
        // 1. Добавляем gender (string)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"gender\"\r\n\r\n".data(using: .utf8)!)
        body.append(isMen ? "men".data(using: .utf8)! : "women".data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        
        // 2. Добавляем hair_style (string)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"hair_style\"\r\n\r\n".data(using: .utf8)!)
        body.append(hairStyle.data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        
        // 3. Добавляем init_image (file)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(initImageData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Закрываем body
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        // Устанавливаем тело запроса
        requestPost.httpBody = body
        
        // Выполняем запрос
        URLSession.shared.dataTask(with: requestPost) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Ошибка сети: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let data = data else {
                    print("❌ Нет данных в ответе")
                    completion(nil)
                    return
                }
                
                do {
                    let firstResponse = try JSONDecoder().decode(FirstResponse.self, from: data)
                    
                    guard firstResponse.success, firstResponse.data.error_code == 0 else {
                        print("❌ Ошибка в первом ответе: \(firstResponse.data.error_detail.message)")
                        completion(nil)
                        return
                    }
                    
                    let taskID = firstResponse.data.task_id
                    print("✅ POST-запрос выполнен успешно! Получен task_id: \(taskID)")
                    fetchImageURL(taskID: taskID, completion: completion)
                    
                } catch {
                    print("❌ Ошибка декодирования первого JSON: \(error)\nResponse data:\n\(String(data: data, encoding: .utf8) ?? "")")
                    completion(nil)
                }
            }
        }.resume()
        
        func fetchImageURL(taskID: String, completion: @escaping (UIImage?) -> Void) {
            let urlString = "=\(taskID)"
            guard let url = URL(string: urlString) else {
                print("❌ Ошибка: некорректный URL")
                completion(nil)
                return
            }

            print("📤 Отправляем GET-запрос для получения ссылки на изображение...")

            URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("❌ Ошибка сети: \(error.localizedDescription)")
                        completion(nil)
                        return
                    }

                    guard let data = data else {
                        print("❌ Нет данных в ответе")
                        completion(nil)
                        return
                    }

                    do {
                        let secondResponse = try JSONDecoder().decode(SecondResponse.self, from: data)

                        guard secondResponse.success else {
                            print("❌ Ошибка во втором ответе: запрос не удался")
                            completion(nil)
                            return
                        }

                        // Проверяем task_status
                        if secondResponse.data.task_status != 2 {
                            print("⏳ Задача ещё выполняется, повторяем запрос через 2 секунды...")
                            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                                fetchImageURL(taskID: taskID, completion: completion)
                            }
                            return
                        }

                        // Получаем URL изображения
                        guard let imageURLString = secondResponse.data.data?.images.first,
                              let imageURL = URL(string: imageURLString) else {
                            print("❌ Не удалось найти ссылку на изображение")
                            completion(nil)
                            return
                        }

                        print("✅ GET-запрос успешно выполнен! Получена ссылка на изображение: \(imageURLString)")
                        downloadImage(from: imageURL, completion: completion)

                    } catch {
                        print("❌ Ошибка декодирования второго JSON: \(error)\nResponse data:\n\(String(data: data, encoding: .utf8) ?? "")")
                        completion(nil)
                    }
                }
            }.resume()
        }


        
        @Sendable func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
            print("📥 Начинаем загрузку изображения по URL: \(url.absoluteString)")
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("❌ Ошибка загрузки изображения: \(error.localizedDescription)")
                        completion(nil)
                        return
                    }
                    
                    guard let imageData = data, let image = UIImage(data: imageData) else {
                        print("❌ Данные изображения некорректны")
                        completion(nil)
                        return
                    }
                    
                    print("✅ Изображение успешно загружено!")
                    Self.hairstyleRequestsCount += 1
                    completion(image)
                }
            }.resume()
        }
    }
    
    struct FirstResponse: Decodable {
        let success: Bool
        let data: FirstResponseData
    }
    
    struct FirstResponseData: Decodable {
        let error_code: Int
        let error_detail: ErrorDetail
        let task_id: String
        let task_type: String
    }
    
    struct ErrorDetail: Decodable {
        let status_code: Int
        let code: String
        let code_message: String
        let message: String
    }
    
    struct SecondResponse: Decodable {
        let success: Bool
        let data: SecondResponseData
    }
    
    struct SecondResponseData: Decodable {
        let data: ImageData?
        let error_code: Int
        let error_detail: ErrorDetail
        let error_msg: String?
        let task_status: Int
    }
    
    struct ImageData: Decodable {
        let images: [String]
    }
    
}

