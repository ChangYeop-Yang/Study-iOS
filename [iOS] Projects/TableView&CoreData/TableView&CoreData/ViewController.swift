//
//  ViewController.swift
//  TableView&CoreData
//
//  Created by 양창엽 on 02/12/2018.
//  Copyright © 2018 양창엽. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    // MARK: - Outlet Variables
    @IBOutlet weak var table: UITableView!
    
    // MARK: - Variables
    private var people: [Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        table.delegate = self
        table.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadCoreData()
    }

    // MARK: - Action Method
    @IBAction func addObject(_ sender: UIButton) {
        saveCoreData(name: "Person \(Int.random(in: 0..<100))", age: Int.random(in: 0..<100))
    }
    
    // MARK: - Private User Method
    private func saveCoreData(name: String, age: Int) {
        
        guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let person: Person = Person(context: managedContext)
        person.name = name
        person.age = Int16(age)
        
        let family1: Family = Family(context: managedContext)
        family1.family = "001 Child \(Int.random(in: 0..<100)) - \(name)"
        
        let family2: Family = Family(context: managedContext)
        family2.family = "002 Child \(Int.random(in: 0..<100)) - \(name)"

        person.addToChild(family1)
        person.addToChild(family2)
        
        do {
            try managedContext.save()
            self.people.append(person)
            self.table.reloadData()
        }
        catch let error as NSError { print("Could net save. \(error.debugDescription), \(error.localizedDescription)") }
    }
    private func loadCoreData() {
      
        guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        
        do {
            self.people = try managedContext.fetch(fetchRequest) as! [Person]
            
            // Ont to Many
            for personal in self.people {
                print("Count - \(String(describing: personal.child?.count))")
                for family in personal.child! {
                    let item: Family = family as! Family
                    print("😺 \(String(describing: item.family))")
                }
            }
        } catch let error as NSError { print("Could net save. \(error.debugDescription), \(error.localizedDescription)") }
    }
    private func deleteCoreData(index: Int) {
        
        guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(self.people.remove(at: index))
        
        do {
            try managedContext.save()
            self.people.remove(at: index)
            self.table.reloadData()
        }
        catch let error as NSError { print("Could net save. \(error.debugDescription), \(error.localizedDescription)") }
    }
}

// MARK: - UITableViewDelegate Extension
extension ViewController: UITableViewDelegate {
    
    // 사용자가 Cell을 선택시 Cell의 인덱스를 반환하는 메소드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("- Select Table Cell: \(indexPath)")
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            self.deleteCoreData(index: indexPath.row)
        }
    }
}


// MARK: - UITableViewDataSource Extension
extension ViewController: UITableViewDataSource {
    
    // N 번째 섹션에 몇 개의 Row가 존재하는지를 반환하는 메소드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.people.count
    }
    
    // N 번째 섹션에 M 번째 Row를 그리는데 필요한 셀을 반환하는 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let person: NSManagedObject = self.people[indexPath.row]
        
        let cell: UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "Detail")
        cell.textLabel?.text = person.value(forKey: "name") as? String
        cell.detailTextLabel?.text = "- My Age: \(String(describing: person.value(forKey: "age") as? Int))"
        
        return cell
    }
}
