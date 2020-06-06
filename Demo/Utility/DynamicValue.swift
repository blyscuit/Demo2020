//
//  DynamicValue.swift
//  Demo
//
//  Created by Pisit W on 6/6/2563 BE.
//  Copyright © 2563 confusians. All rights reserved.
//

import Foundation

// https://benoitpasquier.com/ios-swift-mvvm-pattern/

class DynamicValue<T> {
    
    typealias CompletionHandler = ((T) -> Void)
    
    var value : T {
        didSet {
            self.notify()
        }
    }
    
    internal var observers = [String: CompletionHandler]()
    
    init(_ value: T) {
        self.value = value
    }
    
    public func addObserver(_ observer: NSObject, completionHandler: @escaping CompletionHandler) {
        observers[observer.description] = completionHandler
    }
    
    public func addAndNotify(observer: NSObject, completionHandler: @escaping CompletionHandler) {
        self.addObserver(observer, completionHandler: completionHandler)
        self.notify()
    }
    
    public func removeObserver(observer: NSObject) {
        guard let index = observers.index(forKey: observer.description) else {return}
        observers.remove(at: index)
    }
    
    internal func notify() {
        observers.forEach({ $0.value(value) })
    }
    
    deinit {
        observers.removeAll()
    }
}

class GenericDataSource<T> : NSObject {
    var data: DynamicValue<[T]> = DynamicValue([])
}

class DynamicValueSingleObserver<T>: DynamicValue<T> {
    
    override func addAndNotify(observer: NSObject, completionHandler: @escaping CompletionHandler) {
        observers.removeAll()
        super.addAndNotify(observer: observer, completionHandler: completionHandler)
    }
    override func addObserver(_ observer: NSObject, completionHandler: @escaping CompletionHandler) {
        observers.removeAll()
        super.addObserver(observer, completionHandler: completionHandler)
    }
}
