//
//  ListEnglishController.swift
//  1542257-1542258
//
//  Created by Phu on 5/28/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

protocol protocolListEditController {
    
    func doneEdit()
}

class ListEnglishController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, protocolListEditController {
    
    // MARK: *** UI Element
    @IBOutlet weak var labelTitle: InsetLabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: *** Data model
    var vocabularys = [[Vocabulary]]()
    var vo_words = [Vocabulary]()
    var vo_phrase = [Vocabulary]()
    var vo_idioms = [Vocabulary]()
    var language: String?
    var buttonSearchBarSelected = 0
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Dang ky xu ly su kien lien quan den ban phim
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
        searchBar.showsScopeBar = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        language = UserDefaults.standard.value(forKey: "App_Language") as? String
        
        if language == "vi" {
            labelTitle.text = "Danh Sách Từ Vựng"
            self.navigationItem.title = ""
            searchBar.scopeButtonTitles = ["Tất cả", "Từ", "Cụm từ", "Thành ngữ"]
        } else {
            labelTitle.text = "List Vocabulary"
            self.navigationItem.title = ""
            searchBar.scopeButtonTitles = ["All", "Word", "Phrase", "Idioms"]
        }
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        vocabularys.removeAll()
        vo_words = DatabaseManagement.shared.getAllVocabularybyCatID(cat_id: 1)
        vo_phrase = DatabaseManagement.shared.getAllVocabularybyCatID(cat_id: 2)
        vo_idioms = DatabaseManagement.shared.getAllVocabularybyCatID(cat_id: 3)
        
        vocabularys.append(vo_words)
        vocabularys.append(vo_phrase)
        vocabularys.append(vo_idioms)
        searchBar.text = ""
        searchBar.selectedScopeButtonIndex = 0
        buttonSearchBarSelected = searchBar.selectedScopeButtonIndex
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func keyboardWillShow(_ notification: NSNotification) {
        
        // Lay thong tin ban phim
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        // Thay doi content inset de scroll duoc
        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height - (self.tabBarController?.tabBar.frame.size.height)!
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
    }
    
    func keyboardWillHide(_ notificatio: NSNotification) {
        
        // Thay doi content inset de scroll duoc
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueListEditWordID" {
            let dest = segue.destination as! ListEditWordController
            dest.delegate = self
            dest.vocabulary = vocabularys[selectedSection][selectedRow]
        } else if segue.identifier == "segueListEditPhraseID" {
            let dest = segue.destination as! ListEditPhraseController
            dest.vocabulary = vocabularys[selectedSection][selectedRow]
            dest.delegate = self
        } else if segue.identifier == "segueListEditIdiomsID" {
            let dest = segue.destination as! ListEditIdiomsController
            dest.vocabulary = vocabularys[selectedSection][selectedRow]
            dest.delegate = self
        }
    }
    
    // MARK: *** UITbaleViewController
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if buttonSearchBarSelected == 0 {
            if language == "vi" {
                if section == 0 {
                    return "Từ"
                } else if section == 1 {
                    return "Cụm từ"
                } else if section == 2 {
                    return "Thành ngữ"
                }
            } else {
                if section == 0 {
                    return "Word"
                } else if section == 1 {
                    return "Phrase"
                } else if section == 2 {
                    return "Idioms"
                }
            }
        } else {
            return ""
        }
        return ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return vocabularys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vocabularys[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vocabulary = vocabularys[indexPath.section][indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListEnglishCellID", for: indexPath) as! ListEnglishCell
        cell.labelEnglish.text = vocabulary.name_en
        cell.labelVietnamese.text = vocabulary.name_vn
        cell.id = vocabulary.id
        cell.status = vocabulary.status
        cell.cat_id = vocabulary.cat_id
        cell.tableView = self.tableView
        cell.vocabylarys = self.vocabularys
        cell.section = indexPath.section
        cell.row = indexPath.row
        
        cell.updateMenu()
        
        if vocabulary.status == true {
            cell.imageViewRemember.image = UIImage(named: "remembered-29.png")
        } else {
            cell.imageViewRemember.image = UIImage(named: "remember-29.png")
        }
        
        return cell
        
    }
    
    var selectedSection: Int = 0
    var selectedRow: Int = 0
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedSection = indexPath.section
        selectedRow = indexPath.row
        
        if buttonSearchBarSelected == 0 {
            if indexPath.section == 0 {
                performSegue(withIdentifier: "segueListEditWordID", sender: nil)
            } else if indexPath.section == 1 {
                performSegue(withIdentifier: "segueListEditPhraseID", sender: nil)
            } else if indexPath.section == 2 {
                performSegue(withIdentifier: "segueListEditIdiomsID", sender: nil)
            }
        } else if buttonSearchBarSelected == 1 {
            performSegue(withIdentifier: "segueListEditWordID", sender: nil)
        } else if buttonSearchBarSelected == 2 {
            performSegue(withIdentifier: "segueListEditPhraseID", sender: nil)
        } else if buttonSearchBarSelected == 3 {
            performSegue(withIdentifier: "segueListEditIdiomsID", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        
        return false
    }
    
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        
    }
    
    // MARK: *** SearchBar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        buttonSearchBarSelected = searchBar.selectedScopeButtonIndex
        filterTableView(ind: buttonSearchBarSelected, text: searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        buttonSearchBarSelected = searchBar.selectedScopeButtonIndex
        filterTableView(ind: buttonSearchBarSelected, text: searchText)
    }
    
    func filterTableView(ind: Int, text: String) {
        
        switch ind {
        case 0: // ALL
            
            vocabularys.removeAll()
            
            if text.isEmpty {
                
                vocabularys.append(vo_words)
                vocabularys.append(vo_phrase)
                vocabularys.append(vo_idioms)
                
                self.tableView.reloadData()
            } else {
                
                vocabularys.append([])
                vocabularys.append([])
                vocabularys.append([])
                
                for vo in vo_words {
                    if vo.name_en.lowercased().contains(text.lowercased()) {
                        vocabularys[0].append(vo)
                    }
                }
                
                for vo in vo_phrase {
                    if vo.name_en.lowercased().contains(text.lowercased()) {
                        vocabularys[1].append(vo)
                    }
                }
                
                for vo in vo_idioms {
                    if vo.name_en.lowercased().contains(text.lowercased()) {
                        vocabularys[2].append(vo)
                    }
                }
                
                self.tableView.reloadData()

            }
            break
            
        case 1: // Word
            
            vocabularys.removeAll()
            
            if text.isEmpty {
                vocabularys.append(vo_words)
                
                self.tableView.reloadData()
            } else {
                
                vocabularys.append([])
                
                for vo in vo_words {
                    if vo.name_en.lowercased().contains(text.lowercased()) {
                        vocabularys[0].append(vo)
                    }
                }
                
                self.tableView.reloadData()
            }
            break
            
        case 2: // Phrase
            
            vocabularys.removeAll()
            
            if text.isEmpty {
                vocabularys.append(vo_phrase)
                
                self.tableView.reloadData()
            } else {
                
                vocabularys.append([])
                
                for vo in vo_phrase {
                    if vo.name_en.lowercased().contains(text.lowercased()) {
                        vocabularys[0].append(vo)
                    }
                }
                
                self.tableView.reloadData()
            }
            break
        case 3: // Idioms
            
            vocabularys.removeAll()
            
            if text.isEmpty {
                vocabularys.append(vo_idioms)
                
                self.tableView.reloadData()
            } else {
                
                vocabularys.append([])
                
                for vo in vo_idioms {
                    if vo.name_en.lowercased().contains(text.lowercased()) {
                        vocabularys[0].append(vo)
                    }
                }
                
                self.tableView.reloadData()
            }
            break
            
        default:
            print("No type")
            break
        }
    }
    
    // MARK: *** protocolListEditController
    func doneEdit() {
        vo_words = DatabaseManagement.shared.getAllVocabularybyCatID(cat_id: 1)
        vo_phrase = DatabaseManagement.shared.getAllVocabularybyCatID(cat_id: 2)
        vo_idioms = DatabaseManagement.shared.getAllVocabularybyCatID(cat_id: 3)
        filterTableView(ind: buttonSearchBarSelected, text: searchBar.text!)
    }
}
