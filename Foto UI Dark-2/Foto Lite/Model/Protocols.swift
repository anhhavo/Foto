//
//  Protocols.swift
//  Foto Lite
//
//  Created by Anh Vo on 11/12/18.
//  Copyright © 2018 Anh Vo. All rights reserved.
//

import UIKit


protocol SendBackDataDelegate {
    func dataReceived<T>(identifier: String, info: [T])
}
