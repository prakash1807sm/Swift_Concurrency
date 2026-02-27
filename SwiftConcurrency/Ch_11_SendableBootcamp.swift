//
//  SendableBootcamp.swift
//  SwiftConcurrency
//
//  Created by Prakash Rajak on 27/02/26.
//

/*
 1. Sendable protocol is basically used to send objects which are not thread safe into actor isolated context which are thread safe. By default value types conform to Sendable protocol.
 2. Sendable : The Sendable protocol indicates that value of the given type can be safely used in concurrent code.
 3. @unchecked Sendable means we are telling the compiler that this will be Sendable, we will make sure of it. don't worry and you don't need to check and so compiler will not check if it is sendable or not.
 4. We are using swift5 language.
 */

import SwiftUI

actor CurrentUserManager {
    func updateDatabase(userInfo: MyClassUserInfo) {
        
    }
}

struct MyUserInfo : Sendable {
    let name: String
}

final class MyClassUserInfo : @unchecked Sendable {
    private var name: String
    
    let queue = DispatchQueue(label: "com.MyApp.MyClassUserInfo")
    
    init(name: String) {
        self.name = name
    }
    
    //We are making sure that this class is thread safe.
    func updateName(name: String) {
        queue.async {
            self.name = name
        }
    }
}

class SendableBootcampViewModel: ObservableObject {
    let manager = CurrentUserManager()
    
    func updateCurrentUserInfo() async {
        let info =  MyClassUserInfo(name: "info")
        await manager.updateDatabase(userInfo: info)
    }
}

struct SendableBootcamp: View {
    @StateObject private var viewModel = SendableBootcampViewModel()
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    SendableBootcamp()
}
