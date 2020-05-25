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

    init(completionClosure: @escaping() -> Void) {
        persistentContainer = NSPersistentContainer(name: "BookMemo")
        persistentContainer.loadPersistentStores {(_, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completionClosure()
        }
    }

    //新規作成
    func createBook() -> Book {
        let context = persistentContainer.viewContext
        if let book: Book = NSEntityDescription.insertNewObject(forEntityName: "Book", into: context) as? Book {
            return book
        }else{
            fatalError()
        }
    }

    //保存
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    //読み込み
    func getBooks() -> [Book] {
        let context = persistentContainer.viewContext
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
    func serchBook(id: String) -> [Book] {
        let context = persistentContainer.viewContext
        let booksfetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        let predicate = NSPredicate(format: "id == %@", id)
        booksfetch.predicate = predicate

        do {
            let fetchedBooks = try context.fetch(booksfetch) as! [Book]
            return fetchedBooks
        } catch {
            fatalError("Failed to fetch books: \(error)")
        }
    }

    //更新
    func updateBook(id: String, updatedBook: Book) {
        var Books = serchBook(id: id)
        Books[0] = updatedBook
        saveContext()
    }

    //削除
    func delete(id: String) {
        let context = persistentContainer.viewContext
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
