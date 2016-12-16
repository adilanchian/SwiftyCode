//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Alec Dilanchian on 11/18/16.
//  Copyright © 2016 Alec Dilanchian. All rights reserved.
//

import UIKit
import Messages

//-- Protocols --//
// TODO: Setup language protocol to transfer data

//-- Compact View Controller --//
class CompactViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    // UI Properties //
    @IBOutlet weak var languagePicker: UIPickerView!
    @IBOutlet weak var languageSelectionButton: UIButton!
    let pickerData = [["Swift", "Objective-C", "C"]]
    var pickerValue = "Swift"
    
    // Language Selection Button Action //
    @IBAction func languageSelectionButtonAction(_ sender: Any) {
        print("Language Selected: \(pickerValue)")
        
        DataContainerSingleton.sharedInstance.setLanguage(language: pickerValue)
        
        guard let messageVC = storyboard?.instantiateViewController(withIdentifier: "MessageVC") as? MessagesViewController else {
            fatalError("Can't instantiate MessagesViewController")
        }
        
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        addChildViewController(messageVC)
        
        // ...constraints and view setup... //
        view.addSubview(messageVC.view)
        messageVC.requestPresentationStyle(.expanded)
    }
    
    override func viewDidLoad() {
        // Setup Picker //
        languagePicker.dataSource = self
        languagePicker.delegate = self
        languagePicker.layer.borderColor = UIColor.darkGray.cgColor
        languagePicker.layer.borderWidth = 1
        languagePicker.layer.cornerRadius = 5
        
        // Setup Button //
        languageSelectionButton.layer.cornerRadius = 5
        
    }
    
    //-- Picker Helpers --//
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    //-- Picker Delegate Functions --//
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int
        ) -> String? {
        return pickerData[component][row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerValue = pickerData[component][row]
    }
}

//-- Expanded View Controller --//
class ExpandedViewController: UIViewController, UITextViewDelegate, UICollectionViewDataSource {
    //-- UI Properties --//
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var codeTextView: UITextView!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var clearTextViewButton: UIButton!
    @IBOutlet weak var quickActionCollectionView: UICollectionView!
    let collectionViewCellIndentifier = "ActionCell"
    var actionArray = [String]()
    var cursorLocation: UITextPosition? = nil
    var currentLevel = 0
    var actionIndex = 0
    
    @IBAction func clearTextViewAction(_ sender: Any) {
        codeTextView.text = nil
        currentLevel = 0
    }
    
    override func viewDidLoad() {
        // Label //
        self.languageLabel.text = DataContainerSingleton.sharedInstance.getLanguage()
        
        // Collection View //
        actionArray = actionsForLanguage()
        quickActionCollectionView.dataSource = self
        
        // UITextField //
        codeTextView.delegate = self
        
        // Setup Keyboard //
        codeTextView.keyboardType = UIKeyboardType.default
        
        // Setup UI //
        sendMessageButton.layer.cornerRadius = 5
        clearTextViewButton.layer.cornerRadius = 5
        codeTextView.layer.cornerRadius = 5
    }
    
    //-- Collection View Helpers --//
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return (actionArray.count)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActionCell",
                                                      for: indexPath) as! QuickActionCell
        cell.layer.cornerRadius = 5
        cell.actionButton.layer.cornerRadius = 5
        cell.actionButton.setTitle(actionArray[actionIndex], for: .normal)
        cell.actionButton.tag = actionIndex
        actionGenerator(action: actionArray[actionIndex], button: cell.actionButton)
        actionIndex = actionIndex + 1
        
        return cell
    }
    
    func actionsForLanguage() -> [String] {
        var actionArray = [String]()
        let selectedLanguage = DataContainerSingleton.sharedInstance.getLanguage()
        
        if selectedLanguage == "Swift" {
            actionArray = [
                "Let",
                "Var",
                "Function",
                "Class",
                "Structure",
                "For Loop",
                "Cond. If",
                "While Loop"
            ]
        }
        
        return actionArray
    }
    
    func actionGenerator(action: String, button: UIButton) {
        let selectedLanguage = DataContainerSingleton.sharedInstance.getLanguage()
        
        if selectedLanguage == "Swift" {
            switch(button.tag) {
            case 0:
                button.addTarget(self, action: #selector(swiftLet), for: .touchUpInside)
                break
            case 1:
                button.addTarget(self, action: #selector(swiftVar), for: .touchUpInside)
                break
            case 2:
                button.addTarget(self, action: #selector(swiftFunc), for: .touchUpInside)
                break
            case 3:
                button.addTarget(self, action: #selector(swiftClass), for: .touchUpInside)
                break
            case 4:
                button.addTarget(self, action: #selector(swiftStruct), for: .touchUpInside)
                break
            case 5:
                button.addTarget(self, action: #selector(swiftFor), for: .touchUpInside)
                break
            case 6:
                button.addTarget(self, action: #selector(swiftIf), for: .touchUpInside)
                break
            case 7:
                button.addTarget(self, action: #selector(swiftWhile), for: .touchUpInside)
                break
            default:
                print("Action not available")
            }
        }
        
        if selectedLanguage == "Objective-C" {
            
        }
        
        if selectedLanguage == "C" {
            
        }
    }
    
    //-- String Generator --//
    func stringGenerator(data: NSMutableAttributedString, type: String) {
        
//        if (currentLevel == 0) {
            codeTextView.attributedText = data
//        } else {
            // codeTextView.insertText(addIndentation(data: data, type: type))
//        }
    }
    
//    func addIndentation(data: NSMutableAttributedString, type: String) -> NSMutableAttributedString {
//        // Find number of lines set //
//        // let lineCount = codeTextView.contentSize.height / (codeTextView.font?.lineHeight)!
//        
//        // Is there a need for indentation? //
//        // If there is nothing in the editor return string //
//        if currentLevel == 0 {
//            return data
//        } else {
//            var mutableData = data
//            let indentation = String(repeatElement("\t", count: currentLevel))
//            if mutableData.characters.contains("}") && type != "variable" {
//                var search = mutableData.components(separatedBy: "}")
//                search[1].append(indentation)
//                search[1].append("}")
//                
//                return indentation + search[0] + search[1]
//            } else {
//                return indentation + data
//            }
//        }
//    }
}


class QuickActionCell: UICollectionViewCell {
    @IBOutlet weak var actionButton: UIButton!
    
}


class MessagesViewController: MSMessagesAppViewController {
    
    //-- Properties --//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Get current conversation and become active //
        super.willBecomeActive(with: conversation)
        
        // Present the proper viewcontroller //
        presentVC(presentationStyle: presentationStyle)
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        if presentationStyle == .expanded {
            return
        } else {
            presentVC(presentationStyle: presentationStyle)
        }
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
        
        if presentationStyle == .compact {
            return
        } else {
            presentVC(presentationStyle: presentationStyle)
        }
    }
    
    //-- Helpers --//
    private func presentVC(presentationStyle: MSMessagesAppPresentationStyle) {
        
        let controller: UIViewController
        
        if presentationStyle == .compact {
            controller = instantiateCompactVC()
        } else {
            controller = instantiateExpandedVC()
        }

        addChildViewController(controller)
        
        // ...constraints and view setup... //
        
        view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }
    
    private func instantiateCompactVC() -> UIViewController {
        
        guard let compactVC = storyboard?.instantiateViewController(withIdentifier: "CompactVC") as? CompactViewController else {
            fatalError("Can't instantiate CompactViewController")
        }
        
        return compactVC
    }
    
    private func instantiateExpandedVC() -> UIViewController {
        guard let expandedVC = storyboard?.instantiateViewController(withIdentifier: "ExpandedVC") as? ExpandedViewController else {
            fatalError("Can't instantiate ExpandedViewController")
        }
        return expandedVC
    }
    
    //-- Close Keyboard function --//
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
