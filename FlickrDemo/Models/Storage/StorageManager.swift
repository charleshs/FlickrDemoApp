//
//  StorageManager.swift
//  FlickrDemo
//
//  Created by Charles Hsieh on 2020/4/1.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import Foundation
import CoreData

typealias LSPhotoResults = (Result<[LSPhoto], Error>) -> Void

enum StorageManagerError: Error {
    
    case unableToDeletePhoto
}

class StorageManager: NSObject {
    
    private enum Entity: String {
        
        case photo = "LSPhoto"
    }
    
    private struct OrderBy {
        
        static let created = "created"
    }
    
    static let shared = StorageManager()
    
    var persistentContainer: NSPersistentContainer = {
        let container =  NSPersistentContainer(name: "FlickrDemo")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        })
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    @objc dynamic var photoList: [LSPhoto] = []
    
    private override init() {
        
        print(" Core data file path: \(NSPersistentContainer.defaultDirectoryURL())")
    }
    
    func fetchPhoto(completion: LSPhotoResults = { _ in }) {
        
        let fetchRequest = NSFetchRequest<LSPhoto>(entityName: Entity.photo.rawValue)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: OrderBy.created, ascending: true)]
        
        do {
            let photos = try viewContext.fetch(fetchRequest)
            self.photoList = photos
            completion(.success(photos))
            
        } catch {
            completion(.failure(error))
        }
    }
    
    func savePhoto(_ photo: PhotoPresentable, completion: (Result<Void, Error>) -> Void) {
        
        let lsPhoto = LSPhoto(context: viewContext)
        lsPhoto.mapping(photo)
        lsPhoto.created = Date().timeIntervalSince1970
        
        save(completion: completion)
    }
    
    func deletePhoto(_ photo: LSPhoto, completion: (Result<Void, Error>) -> Void) {
        
        viewContext.delete(photo)
        
        save(completion: completion)
    }
    
    func deletePhoto(_ photo: PhotoPresentable, completion: (Result<Void, Error>) -> Void) {
        
        let matched = photoList.filter { (lsPhoto) -> Bool in
            return lsPhoto.id == photo.id &&
                   lsPhoto.server == photo.server &&
                   lsPhoto.secret == photo.secret &&
                   lsPhoto.farm == photo.farm
        }
        guard matched.count > 0 else {
            completion(.failure(StorageManagerError.unableToDeletePhoto))
            return
        }
        deletePhoto(matched.first!, completion: completion)
    }
    
    func save(completion: (Result<Void, Error>) -> Void) {
        
        do {
            try viewContext.save()
            fetchPhoto(completion: { (result) in
                switch result {
                case .success:
                    completion(.success(()))
                case let .failure(error):
                    completion(.failure(error))
                }
            })
            
        } catch {
            completion(.failure(error))
        }
    }
}

extension LSPhoto {
    
    func mapping(_ object: PhotoPresentable) {
        
        self.id = object.id
        self.secret = object.secret
        self.server = object.server
        self.farm = object.farm.toInt64()
        self.title = object.title
    }
    
    func converted() -> Photo? {
        
        guard
            let id = self.id,
            let secret = self.secret,
            let server = self.server,
            let title = self.title
        else {
            return nil
        }
        
        return Photo(id: id, secret: secret, server: server, farm: Int(farm), title: title)
    }
}
