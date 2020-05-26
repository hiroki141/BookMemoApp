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

class DataManager: NSObject {
    var persistentContainer: NSPersistentContainer!
    let context: NSManagedObjectContext

    init(completionClosure: @escaping() -> Void) {
        persistentContainer = NSPersistentContainer(name: "BookMemo")
        persistentContainer.loadPersistentStores {(_, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completionClosure()
        }
        context = persistentContainer.viewContext
    }

    //新規作成
    func createBook() -> Book {
        if let book: Book = NSEntityDescription.insertNewObject(forEntityName: "Book", into: context) as? Book {
            return book
        }else{
            fatalError()
        }
    }

    //保存
    func saveContext() {
        print("saveContext() is called")
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    //読み込み
    func getBooks() -> [Book] {
        let booksfetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        let sort = NSSortDescriptor(key: "editDate", ascending: false)
        booksfetch.sortDescriptors = [sort]
        do {
            let fetchedBooks = try context.fetch(booksfetch) as! [Book]
            return fetchedBooks
        } catch {
            fatalError("Failed to fetch books: \(error)")
        }
    }

    //検索
    func serchBook(id: String) -> Book {
        let booksfetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        let predicate = NSPredicate(format: "id == %@", id)
        booksfetch.predicate = predicate

        do {
            let fetchedBooks = try context.fetch(booksfetch) as! [Book]
            let book = fetchedBooks[0]
            return book
        } catch {
            fatalError("Failed to fetch books: \(error)")
        }
    }

//    //更新
//    func updateBook(id: String, updatedBook: Book) {
//        var Book = serchBook(id: id)
//        Book = updatedBook
//        saveContext()
//    }

    //削除
    func delete(id: String) {
        let booksfetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        let predicate = NSPredicate(format: "id == %@", id)
        booksfetch.predicate = predicate

        do {
            let fetchedBooks = try context.fetch(booksfetch) as! [Book]
            context.delete(fetchedBooks[0])
            try context.save()
        } catch {
            fatalError("Failed to fetch books: \(error)")
        }
    }
}
