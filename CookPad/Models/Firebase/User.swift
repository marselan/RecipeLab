//
//  User.swift
//  CookPad
//
//  Created by Mariano Arselan on 13-02-26.
//

import Foundation
import FirebaseFirestore

struct User: Codable, Identifiable {
    var fbid: String
    @DocumentID var id: String?
}
