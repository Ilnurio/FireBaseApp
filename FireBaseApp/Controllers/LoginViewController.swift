//
//  ViewController.swift
//  FireBaseApp
//
//  Created by Ilnur on 30.07.2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var warnLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(kbDidShow),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(kbDidHide),
            name: UIResponder.keyboardDidHideNotification,
            object: nil
        )
    }
    
    @objc func kbDidShow(notification: Notification) {
        guard let userinfo = notification.userInfo else { return }
        let kbFrameSize = (userinfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        (self.view as! UIScrollView).contentSize = CGSize(
            width: self.view.bounds.size.width,
            height: self.view.bounds.size.height + kbFrameSize.height
        )
        
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
    }
    
    @objc func kbDidHide() {
        (self.view as! UIScrollView).contentSize = CGSize(
            width: self.view.bounds.size.width,
            height: self.view.bounds.size.height
        )
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        
    }
    
}

