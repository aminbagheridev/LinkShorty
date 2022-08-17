//
//  RealmObject.swift
//  linkShorty
//
//  Created by Amin  Bagheri  on 2022-08-15.
//

import Foundation
import RealmSwift

class Link: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var longLink = ""
    @Persisted var shortLink = ""
}

class RealmManager {
    
    static let shared = RealmManager()
    
    private(set) var realm: Realm?
    var links: [Link] = []
    
    init() {
        openRealm() //this opens it every time we need to use realm
        getLinks()
    }
        // must open the realm to use it
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1)
            
            Realm.Configuration.defaultConfiguration = config
            
            realm = try Realm()
        } catch {
            print("Unable to open realm.", error.localizedDescription)
        }
    }
    
    func addLink(longLink: String, shortLink: String) {
        if let realm = realm {
            do {
                try realm.write {
                    let newLink = Link(value: [
                        "longLink": longLink,
                        "shortLink" : shortLink
                    ])
                    realm.add(newLink)
                    getLinks()
                    print("Added new link to Realm: \(newLink)")
                }
            } catch {
                print("Error:", error.localizedDescription)
            }
        }
    }
    
    func getLinks() {
        if let realm = realm {
            let allLinks = realm.objects(Link.self)
            links = []
            for link in allLinks {
                links.append(link)
            }
        }
    }
    
    func deleteLink(id: ObjectId) {
        if let realm = realm {
            do {
                let linkToDelete = realm.objects(Link.self).filter(NSPredicate(format: "id == %@", id))
                guard !linkToDelete.isEmpty else { return }
                
                try realm.write {
                    realm.delete(linkToDelete)
                    getLinks()
                    print("Deleted link with id \(id) from realm.")
                }
            } catch {
                print("Error deleting link with id \(id) from realm: ", error.localizedDescription)
            }
        }
    }
    
}
