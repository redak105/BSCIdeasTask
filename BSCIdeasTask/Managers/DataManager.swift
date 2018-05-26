//
//  DataManager.swift
//  BSCIdeasTask
//
//  Created by Radek Zmeskal on 25/05/2018.
//  Copyright © 2018 Radek Zmeskal. All rights reserved.
//

import UIKit
import Alamofire

let URL_NOTES = "http://private-9aad-note10.apiary-mock.com/notes"
let URL_NOTE = "http://private-9aad-note10.apiary-mock.com/note"

class DataManager: NSObject {
    
    class func fetchNotes(completion: @escaping ([Note]?) -> Void) {
        guard let url = URL(string: URL_NOTES) else {
            completion(nil)
            return
        }
        Alamofire.request(url,
                        method: .get
                          )
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching from remote")
                        completion(nil)
                    return
                }
                
                guard let result = response.result.value as? [[String: Any]] else {
                    completion(nil)
                    return
                }
                
                let notes = result.flatMap { note in return Note(json: note) }
                completion(notes)
        }
    }
    
    class func deleteNote(note: Note, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: URL_NOTES + "/\(note.id)") else {
            completion(false)
            return
        }
        Alamofire.request(url,
                        method: .delete
            )
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching from remote")
                    completion(false)
                    return
                }
                
                completion(true)
        }
    }
    
    class func updateNote(note: Note, title: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: URL_NOTES + "/\(note.id)") else {
            completion(false)
            return
        }
        Alamofire.request(url,
                        method: .put,
                        parameters: ["id": note.id, "title": title]
            )
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching from remote")
                    completion(false)
                    return
                }
                
                guard let result = response.result.value as? [[String: Any]] else {
                    completion(false)
                    return
                }
                
                note.title = title
                completion(true)
        }
    }
    
    class func postNote(title: String, completion: @escaping (Note?) -> Void) {
        guard let url = URL(string: URL_NOTES) else {
            completion(nil)
            return
        }
        Alamofire.request(url,
                        method: .post,
                        parameters: ["title": title]
            )
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching from remote")
                    completion(nil)
                    return
                }
                
                guard let result = response.result.value as? [String: Any] else {
                    completion(nil)
                    return
                }
                
                let note = Note(json: result)
                completion(note)
        }
    }


}
