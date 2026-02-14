//
//  File.swift
//  CookPad
//
//  Created by Mariano Arselan on 13-02-26.
//

import Foundation
import FirebaseFirestore

struct User: Codable {
    var id: Int
    @DocumentID var email: String?
}
