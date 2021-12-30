//
//  CoreDataConnect.swift
//  l1stener
//
//  Created by nju on 2021/12/29.
//

import Foundation
import CoreData

class CoreDataConnect {
    var myContext :NSManagedObjectContext! = nil
    
    init(context:NSManagedObjectContext) {
        self.myContext = context
    }
    
    // insert
    func insert(data: Data, fileName: String, genre: String) -> Bool {
        let music = NSEntityDescription.insertNewObject(forEntityName: "Music", into: myContext) as! Music
        music.data = data
        music.fileName = fileName
        music.genre = genre
        do {
            try myContext.save()
            return true
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    // delete
    func delete(fileName: String) -> Bool {
        let request = NSFetchRequest<Music>(entityName: "Music")
        do {
            let results = try myContext.fetch(request)
            for result in results {
                if result.fileName == fileName {
                    myContext.delete(result)
                }
            }
            try myContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
        return true
    }
    
    // getAll
    func getAll() -> [Music] {
        var music: [Music] = []
        let request = NSFetchRequest<Music>(entityName: "Music")
        do {
            let results = try myContext.fetch(request)
            for result in results {
                music.append(result)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
        return music
    }
    
    // clear
    func clear() -> Bool {
        let request = NSFetchRequest<Music>(entityName: "Music")
        do {
            let results = try myContext.fetch(request)
            for result in results {
                myContext.delete(result)
            }
            try myContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
        return true
    }
}
