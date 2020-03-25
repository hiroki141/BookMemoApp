//
//  DataController.swift
//  BookMemo
//
//  Created by 井福弘基 on 2019/12/07.
//  Copyright © 2019 Hiroki Ifuku. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class DataManager: NSObject{
    var persistentContainer: NSPersistentContainer!
    
    init(completionClosure: @escaping()->()) {
        persistentContainer = NSPersistentContainer(name:"BookMemo")
        persistentContainer.loadPersistentStores(){(description, error) in
            if let error = error{
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completionClosure()
        }
    }
    
    //新規作成
    func createBook() -> Book {
        let context = persistentContainer.viewContext
        let book = NSEntityDescription.insertNewObject(forEntityName: "Book", into: context) as! Book
        return book
    }
    
    //保存
    func saveContext(){
        let context = persistentContainer.viewContext
        if context.hasChanges{
            do {
                try context.save()
            }catch{
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //読み込み
    func getBooks() -> [Book]{
        let context = persistentContainer.viewContext
        let booksfetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        
        do {
            let fetchedBooks = try context.fetch(booksfetch) as! [Book]
            return fetchedBooks
        }catch{
            fatalError("Failed to fetch books: \(error)")
        }
        return []
    }
    
    //検索
    func serchBook(title: String) -> [Book]{
        let context = persistentContainer.viewContext
        let booksfetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        let predicate = NSPredicate(format:"title == %@", title)
        booksfetch.predicate = predicate
        
        do {
            let fetchedBooks = try context.fetch(booksfetch) as! [Book]
            return fetchedBooks
        }catch{
            fatalError("Failed to fetch books: \(error)")
        }
    }
    
    //更新
    func updateBook(title: String,updatedBook:Book){
        var Books = serchBook(title: title)
        Books[0] = updatedBook
        saveContext()
    }
    
    //削除
    func delete(title:String){
        let context = persistentContainer.viewContext
        let booksfetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        let predicate = NSPredicate(format:"title == %@", title)
        booksfetch.predicate = predicate
        
        do {
            let fetchedBooks = try context.fetch(booksfetch) as! [Book]
            context.delete(fetchedBooks[0])
            try context.save()                
        }catch{
            fatalError("Failed to fetch books: \(error)")
        }
    }
}


