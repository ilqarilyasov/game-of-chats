//
//  ViewController.swift
//  GameOfChats
//
//  Created by Ilgar Ilyasov on 10/24/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        // User is not logged in
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            handleLogout()
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

