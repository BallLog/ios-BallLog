//
//  AppleLoginModel.swift
//  balllog
//
//  Created by 전은혜 on 12/16/24.
//


import Foundation

struct AppleLoginModel {
    let userId: String
    let email: String?
    let fullName: PersonNameComponents?
    let identityToken: Data?
    let authorizationCode: Data?
}
