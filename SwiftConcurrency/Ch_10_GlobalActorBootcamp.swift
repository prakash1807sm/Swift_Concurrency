//
//  GlobalActorBootcamp.swift
//  SwiftConcurrency
//
//  Created by Prakash Rajak on 27/02/26.
//

/*
 1.In a simple app, we might need not need global actor. We need this when we do some heavy task.
 2.we use nonisolated word to make it out of isolation context to actor.
 3.Similarly, we use global actor to make a function in isolated context of an actor.
 4.Global actor is basically used to make a function which is not part of an actor into isolated context of a particular Actor. Here we have made view model getData() function in isolated context of actor MyNewDataManager() through MyFirstGlobalActor.
 5. @MainActor - it means, it is main actor which is global and it is already created for us by apple. @MainActor means the main thread. So If you want make happen anything on the main thread and you are not sure whether you're in main thread or not. mark it with @MainActor
 6. Now, if a lot of variables and functions are marked a some global actor. since this may be annoying doing this, we can mark the entire class with that global actor, let's say @MainActor. Now, everthing inside that class is isolated to MainActor i.e everything will be executed on the main thread.
 7. But if you make the entire class isolated to a global actor, you can make any function/variable to another specific global actor or you can make it nonisolated to the actor on which current class is isolated.
 
 */

import SwiftUI

@globalActor struct MyFirstGlobalActor { // mostly it is struct but if you make it class make it final so that no can inherit from this.
    static var shared = MyNewDataManager() // we created global shared instance of actor MyNewDataManager. We should always use this instance as instance of actor MyNewDataManager.
    
    private init() {
        
    }
}

actor MyNewDataManager {
    func getDataFromDatabase()  -> [String] {
        return ["1", "2", "3", "4", "5"]
    }
}

@MainActor class GlobalActorBootcampViewModel: ObservableObject {
    @Published var dataArray: [String] = [] //by marking dataArray @MainActor, if we modify it on the other thread, we will get compilation error. similarly we can mark it with another global actor
    let manager = MyFirstGlobalActor.shared
    
//    nonisolated
    @MyFirstGlobalActor func getData()  {
        //HEAVY COMPLEX METHODS
        Task {
            let data = await manager.getDataFromDatabase()
            await MainActor.run {
                self.dataArray = data
            }
        }
    }
    
}

struct GlobalActorBootcamp: View {
    @StateObject private var viewModel = GlobalActorBootcampViewModel()
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) { data in
                    Text(data)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModel.getData()
        }
    }
}

#Preview {
    GlobalActorBootcamp()
}
