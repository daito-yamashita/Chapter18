//
//  ViewController.swift
//  Chapter18-1
//
//  Created by daito yamashita on 2021/03/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mySwitch1: UISwitch!
    @IBOutlet weak var mySwitch2: UISwitch!
    
    @IBOutlet weak var textView: UITextView!
    
    var originalFrame: CGRect?
    
    let thePath = NSHomeDirectory() + "/Documents/myTextfile.txt"
    
    @IBAction func saveToFile(_ sender: Any) {
        view.endEditing(true)
        let textData = textView.text
        
        do {
            try textData?.write(toFile: thePath, atomically: true, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print("保存に失敗。\n \(error)")
        }
    }
    
    @IBAction func readFromFile(_ sender: Any) {
        // キーボードを下げる
        view.endEditing(true)
        
        do {
            let textData = try String(contentsOfFile: thePath, encoding: String.Encoding.utf8)
            // 読み込みが成功したならば表示する
            textView.text = textData
        }
        catch let error as NSError {
            textView.text = "読み込みに失敗。\n \(error)"
        }
    }
    
    @IBAction func saveStatus(_ sender: Any) {
        let defaults = UserDefaults.standard
        // キーの"switchOn"の値をBoolとして読んでmySwitchに設定する
        defaults.set(mySwitch1.isOn, forKey: "switchOn")
    }
    
    @IBAction func readStatus(_ sender: Any) {
        let defaults = UserDefaults.standard
        mySwitch2.isOn = defaults.bool(forKey: "switchOn")
    }
    
    @IBAction func tapView(_ sender: Any) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // テキストビューの元のframeを保存する
        originalFrame = textView.frame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 通知センターのオブジェクトを作成
        let notification = NotificationCenter.default
        
        // キーボードが登場した
        notification.addObserver(
            self,
            selector: #selector(self.keyboardDidShow(_ :)),
            name: UIResponder.keyboardDidShowNotification,
            object: nil)
        
        // キーボードのフレームが変更された
        notification.addObserver(
            self,
            selector: #selector(self.keyboardDidChangeFrame(_ :)),
            name: UIResponder.keyboardDidChangeFrameNotification,
            object: nil)
        
        // キーボードが退場した
        notification.addObserver(
            self,
            selector: #selector(self.keyboardDidHide(_ :)),
            name: UIResponder.keyboardDidHideNotification,
            object: nil)
    }

    // キーボードが表示されたとき実行
    @objc func keyboardDidShow(_ notification: Notification) {
        // keyboardChangeFrameも発生するのでそちらで処理
    }
    
    // キーボードのサイズが変化した
    @objc func keyboardDidChangeFrame(_ notification: Notification) {
        // キーボードのフレームを調べる
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        // キーボードで隠れないようにテキストビューの高さを変更する
        var textViewFrame = textView.frame
        textViewFrame.size.height = keyboardFrame.minY - textViewFrame.minY - 5
        textView.frame = textViewFrame
    }
    
    // キーボードが退場した
    @objc func keyboardDidHide(_ notification: Notification) {
        // テキストビューのサイズを戻す
        textView.frame = originalFrame!
    }

}

