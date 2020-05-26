//
//  ViewController.swift
//  BookMemo
//
//  Created by 井福弘基 on 2019/12/05.
//  Copyright © 2019 Hiroki Ifuku. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var booksTableView: UITableView!

    var dataManager = DataManager {}
    var books = [Book]()
    var selectedBookId = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        booksTableView.delegate = self
        booksTableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)

        books = dataManager.getBooks()
        booksTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.imageView?.image = UIImage(data: books[indexPath.row].image!)
        cell.textLabel?.text = books[indexPath.row].title
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.numberOfLines = 5
        cell.detailTextLabel?.text = books[indexPath.row].author
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        cell.setNeedsLayout()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/5
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBookId = books[indexPath.row].id!

        performSegue(withIdentifier: SegueDestination.editMemoView, sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueDestination.editMemoView {
            let editMemoVC = segue.destination as! EditMemoViewController
            editMemoVC.id = selectedBookId
        }
    }

    @IBAction func newCreate(_ sender: Any) {
        let actionSheetManager = AlertManager(alertType: .selectSearchMethod)
        actionSheetManager.delegate = self
        let actionSheetController = actionSheetManager.showAlert()
        present(actionSheetController, animated: true)
    }
}

extension ViewController: alertDelegate {

    func toCaptureViewController() {
        self.performSegue(withIdentifier: SegueDestination.captureBarcode, sender: nil)
    }

    func toSearchViewController() {
        self.performSegue(withIdentifier: SegueDestination.searchByKeyword, sender: nil)
    }
}
