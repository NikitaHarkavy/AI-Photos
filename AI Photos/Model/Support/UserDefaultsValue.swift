//
//  LocalValue.swift
//  Blueberrys
//
//  Created by ILLIA HARKAVY on 23.12.21.
//

import Foundation

@propertyWrapper
struct UserDefaultsValue<Value> where Value: Codable {
    
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard

    var wrappedValue: Value {
        get {
            if let data = container.data(forKey: key), let value = try? JSONDecoder().decode(Value.self, from: data) {
                return value
            } else {
                return defaultValue
            }
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                container.removeObject(forKey: key)
            } else if let data = try? JSONEncoder().encode(newValue) {
                container.set(data, forKey: key)
            }
        }
    }
}

extension UserDefaultsValue where Value: ExpressibleByNilLiteral {
    
    init(key: String, _ container: UserDefaults = .standard) {
        self.init(key: key, defaultValue: nil, container: container)
    }
}

protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    public var isNil: Bool { self == nil }
}
