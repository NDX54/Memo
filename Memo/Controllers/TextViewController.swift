//
//  ViewController.swift
//  Memo
//
//  Created by Jared Juangco on 29/9/21.
//

import UIKit
import RealmSwift

class TextViewController: UIViewController {
    
    private let realm = try! Realm()
    var uniqueID = UUID()
    var selectedNotes : NoteItem? {
        didSet {
            loadNote()
        }
    }
    @IBOutlet weak var noteTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(uniqueID)
        noteTextView.delegate = self
        if selectedNotes?.noteTextContent == "" {
            noteTextView.text = ""
        } else {
            loadNote()
        }
        
        noteTextView.isScrollEnabled = true
        
        noteTextView.dataDetectorTypes = .all
        noteTextView.autocapitalizationType = .none
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//    }
    
    override func viewDidLayoutSubviews() {
        noteTextView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        noteTextView.endEditing(true)
        
    }
    
    func saveNote(_ noteText: String) {
        
            do {
                try realm.write {
                    selectedNotes?.noteTextContent = noteText
                }
            } catch {
                print("Error saving note content: \(error)")
            }

    }
    
    func loadNote() {
        
        guard let selectedNoteText = selectedNotes?.noteTextContent else { fatalError("Contents of selected note does not exist.") }
        if let textView = noteTextView {
            textView.text = selectedNoteText
        }
        
    }
    
    
    
}

extension TextViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let content = textView.text {
            print(content)
            saveNote(content)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textViewDidEndEditing(textView)
        }
        
        return true
    }
    
//    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//        if textView.text != "" {
//            return true
//        } else {
//
//        }
//    }
}

