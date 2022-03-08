//
//  Database.swift
//  News Feed
//
//  Created by Manish Tamta on 07/03/2022.
//

import Foundation
import RealmSwift

class Database {
    
    static func isRealmObject<T: Object>(object: T) -> Bool {
        return object.realm != nil
    }
        
    static func threadSafe<T: Object>(object: T, queue: DispatchQueue, configure: @escaping ((DispatchQueue, T) -> Void)) {
        
     //   let semaphore = DispatchSemaphore(value: 0)
        
        let objectRef = ThreadSafeReference(to: object)
        
     //   var localObj: T?
        
        queue.async {
            
            do {
                let realm = try Realm()
                guard let objectRef = realm.resolve(objectRef) else {
                  return
                }
                configure(queue, objectRef)
            } catch {
                print("Error in saving Object \(object)")
            }

        }
    }
    
    static func saveObject<T:Object>(object: T, queue: DispatchQueue?) throws {
        
        if let queue = queue {
            
            let semaphore = DispatchSemaphore(value: 0)

            if isRealmObject(object: object) {
                let objectRef = ThreadSafeReference(to: object)
                queue.async {
                    do {
                        let realm = try Realm()
                        guard let objectRef = realm.resolve(objectRef) else {
                          return
                        }
                        try realm.write {
                            realm.add(objectRef, update: .modified)
                        }
                        semaphore.signal()
                    } catch {
                        print("Error in saving Object \(object)")
                        semaphore.signal()
                    }
                }
                semaphore.wait()
            } else {
                queue.async {
                    do {
                        let realm = try Realm()
                        try realm.write {
                            realm.add(object, update: .modified)
                        }
                        semaphore.signal()
                    } catch {
                        print("Error in saving Object \(object)")
                        semaphore.signal()
                    }
                }
                semaphore.wait()
            }
            
        } else {
            let realm = try Realm()
            try realm.write {
                realm.add(object, update: .modified)
            }
            
        }
    }
    
    
    static func saveObjects<T: Object>(object: [T]) throws {
        let realm = try Realm()
        try realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    static func getObjects<T:Object>(object: T.Type, queue: DispatchQueue?) throws -> [T] {
        if let queue = queue {
            
            let semaphore = DispatchSemaphore(value: 0)
            var localObjects: [T]?
            
            queue.async {
                do {
                    let realm = try Realm()
                    let realmResults = realm.objects(object)
                    localObjects = Array(realmResults)
                    semaphore.signal()
                } catch {
                    print(error.localizedDescription)
                    semaphore.signal()
                }
            }
            
            semaphore.wait()
            return localObjects!
        } else {
            let realm = try Realm()
            let realmResults = realm.objects(object)
            return Array(realmResults)
        }
    }
    
    static func getObjects<T:Object>(object: T.Type, filter: String, sortBy: (keyPath: String, isAscending: Bool)?, queue: DispatchQueue?) throws -> [T] {
        
        if let queue = queue {
            
            let semaphore = DispatchSemaphore(value: 0)
            var localObjects: [T]?
            
            queue.async {
                do {
                    let realm = try Realm()
                    var realmResults = realm.objects(object).filter(filter)
                    if let sortBy = sortBy {
                        realmResults = realmResults.sorted(byKeyPath: sortBy.keyPath, ascending: sortBy.isAscending)
                    }
                    localObjects = Array(realmResults)
                    semaphore.signal()
                } catch {
                    print(error.localizedDescription)
                    semaphore.signal()
                }
            }
            
            semaphore.wait()
            return localObjects!
        } else {
            let realm = try Realm()
            var realmResults = realm.objects(object).filter(filter)
            if let sortBy = sortBy {
                realmResults = realmResults.sorted(byKeyPath: sortBy.keyPath, ascending: sortBy.isAscending)
            }
            return Array(realmResults)
        }
    }
    
    static func updateObject<T:Object>(object: T, updateBlock: @escaping ((T) -> Void), queue: DispatchQueue?) throws {
        
        if let queue = queue {
            
            if isRealmObject(object: object) {
                
                let objectRef = ThreadSafeReference(to: object)
                queue.async {
                    do {
                        let realm = try Realm()
                        guard let objectRef = realm.resolve(objectRef) else {
                          return
                        }
                        try realm.write {
                            updateBlock(objectRef)
                        }
                    } catch {
                        print("Error in saving Object \(object)")
                    }
                }
                
            } else {
               
                queue.async {
                    do {
                        let realm = try Realm()
                        try realm.write {
                            updateBlock(object)
                        }
                    } catch {
                        print("Error in saving Object \(object)")
                    }
                }
                
            }
            
        } else {
            let realm = try Realm()
            try realm.write {
                updateBlock(object)
            }
            
        }
    }
    
}

extension Results {
    func toArray<T>(type: T.Type) -> [T] {
        return compactMap{ $0 as? T }
    }
}
