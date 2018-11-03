//
//  User.swift
//  GameOfChats
//
//  Created by Ilgar Ilyasov on 11/1/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var email: String?
    var profileImageURL: String?
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageURL = dictionary["profileImageUrl"] as? String
    }
}
