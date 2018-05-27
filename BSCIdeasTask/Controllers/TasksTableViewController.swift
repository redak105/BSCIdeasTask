//
//  TasksTableViewController.swift
//  BSCIdeasTask
//
//  Created by Radek Zmeskal on 25/05/2018.
//  Copyright © 2018 Radek Zmeskal. All rights reserved.
//

import UIKit

class TasksTableViewController: UITableViewController {

    var notes:[Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.title = LOC_NOTES_TITLE
        
        DataManager.fetchNotes(completion: { (notes) in
            if let notesArray = notes {
                self.notes = notesArray
                self.tableView.reloadData()
            } else {
                self.notes = []
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellNote", for: indexPath)

        let note = self.notes[indexPath.row]
        
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = note.title
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // 1
        let actionEdit = UITableViewRowAction(style: .normal, title: LOC_CELL_EDIT , handler: { (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
            let note = self.notes[indexPath.row]
            self.showEdit(note: note)
        })
        let actionDelete = UITableViewRowAction(style: .destructive, title: LOC_CELL_DELETE , handler: { (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
            let note = self.notes[indexPath.row]
            DataManager.deleteNote(note: note, completion: { (result) in
                if result {
                    self.notes.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            })
        })
        // 5
        return [ actionDelete, actionEdit]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = self.notes[indexPath.row]
        
        self.showDetail(note: note)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showDetail(note: Note) {
        let alertController = UIAlertController(title: LOC_NOTE, message: note.title, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: LOC_NOTE_OK, style: .default)
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true)
    }
    
    func showEdit(note: Note?) {
        
        let alertController = UIAlertController(title: LOC_NOTE, message: "", preferredStyle: .alert)
        
        if let note = note {
            
            alertController.addTextField { textField in
                textField.placeholder = LOC_NOTE_PLACEHOLDER
                textField.text = note.title
            }
            
            let cancelAction = UIAlertAction(title: LOC_NOTE_CANCEL, style: .cancel) { action in
                
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: LOC_NOTE_CHANGE, style: .default) { action in
                let loginTextField = alertController.textFields![0] as UITextField
                
                if let title = loginTextField.text {
                    DataManager.updateNote(note: note, title: title, completion: { (result) in
                        if (result) {
                            self.tableView.reloadData()
                        }
                    })
                }
            }
            alertController.addAction(OKAction)
        } else {
            alertController.addTextField { textField in
                textField.placeholder = LOC_NOTE_PLACEHOLDER
            }
            
            let cancelAction = UIAlertAction(title: LOC_NOTE_CANCEL, style: .cancel) { action in
                
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: LOC_NOTE_ADD, style: .default) { action in
                let loginTextField = alertController.textFields![0] as UITextField
                
                if let title = loginTextField.text {
                    DataManager.postNote(title: title, completion: { (note) in
                        if let note = note {
                            self.notes.append(note)
                            self.tableView.reloadData()
                        }
                    })
                }
            }
            alertController.addAction(OKAction)
        }
        
        
        self.present(alertController, animated: true)
    }

    @IBAction func touchAdd(_ sender: UIBarButtonItem) {
        self.showEdit(note: nil)
    }
    
    
}
