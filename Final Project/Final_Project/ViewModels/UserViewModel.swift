//
//  UserViewModel.swift
//  Final_Project
//
//  Created by Sebastian Boyd on 5/30/22.
//

import Foundation

class UserViewModel: ObservableObject {
    init(user: User) {
        self.user = user
    }
    @Published var user: User
}
