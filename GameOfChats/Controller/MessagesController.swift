//
//  MessagesController.swift
//  GameOfChats
//
//  Created by Ilgar Ilyasov on 10/24/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let image = UIImage(named: "new_message")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        // User is not logged in
        checkIfUserIsLoggedIn()
    }
    
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        let navVC = UINavigationController(rootViewController: newMessageController)
        present(navVC, animated: true, completion: nil)
        
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                print("SNAPSHOT from checkIfUserIsLoggedIn: \(snapshot)")
                if let dictionary = snapshot.value as? [String: Any] {
                    self.navigationItem.title = dictionary["name"] as? String
                }
            }
        }
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch {
            NSLog("\(error)")
        }
        
        guard isViewLoaded else { return }
        let loginController = LoginViewController()
        present(loginController, animated: true, completion: nil)
    }


}

