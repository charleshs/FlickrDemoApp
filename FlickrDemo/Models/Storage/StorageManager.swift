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

class StorageManager {
    
    private enum Entity: String {
        
        case photo = "LSPhoto"
    }
    
    private struct OrderBy {
        
        static let created = "created"
    }
    
    static let shared = StorageManager()
    
    var persistentContainer: NSPersistentContainer {
        let container =  NSPersistentContainer(name: "FlickrDemo")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        })
        return container
    }
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var photoList: [LSPhoto] = []
    
    private init() { }
    
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
    
    func savePhoto(_ photo: Photo, completion: (Result<Void, Error>) -> Void) {
        
        let lsPhoto = LSPhoto(context: viewContext)
        lsPhoto.mapping(photo)
        lsPhoto.created = Date().timeIntervalSince1970
        
        save(completion: completion)
    }
    
    func deletePhoto(_ photo: LSPhoto, completion: (Result<Void, Error>) -> Void) {
        
        viewContext.delete(photo)
        
        save(completion: completion)
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
    
    func mapping(_ object: Photo) {
        
        self.id = object.id
        self.secret = object.secret
        self.server = object.server
        self.farm = object.farm.toInt64()
        self.title = object.title
    }
}
