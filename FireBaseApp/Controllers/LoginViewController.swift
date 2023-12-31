//
//  ViewController.swift
//  FireBaseApp
//
//  Created by Ilnur on 30.07.2023.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    private let segueIdentifier = "tasksSegue"
    var ref: DatabaseReference!
    
    @IBOutlet var warnLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        warnLabel.alpha = 0
        
        ref = Database.database().reference(withPath: "users")
        
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
        
        // checking if user change his accaunt
        Auth.auth().addStateDidChangeListener {[weak self] (auth, user) in
            if user != nil {
                self?.performSegue(
                    withIdentifier: (self?.segueIdentifier)!,
                    sender: nil
                )
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
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
    
    func displayWarningLabel(with text: String) {
        warnLabel.text = text
        
        UIView.animate(
            withDuration: 3,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseInOut,
            animations: { [weak self] in self?.warnLabel.alpha = 1 },
            completion: { [weak self]  complete in self?.warnLabel.alpha = 0 }
        )
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              email != "",
              password != ""
        else {
            displayWarningLabel(with: "Info is incorrect")
            return
        }
        
        Auth.auth().signIn(
            withEmail: email,
            password: password) { [weak self] (user, error) in
                if error != nil {
                    self?.displayWarningLabel(with: "Error occured")
                    return
                }
                
                if user != nil {
                    self?.performSegue(
                        withIdentifier: (self?.segueIdentifier)!,
                        sender: nil
                    )
                    return
                }
                
                self?.displayWarningLabel(with: "No such users")
            }
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              email != "",
              password != ""
        else {
            displayWarningLabel(with: "Info is incorrect")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            
            guard error == nil, user != nil else {
                
                print(error!.localizedDescription)
                return
            }
            
            let userRef = self?.ref.child((user?.user.uid)!)
            userRef?.setValue(["email": user?.user.email])
        }
    }
}
