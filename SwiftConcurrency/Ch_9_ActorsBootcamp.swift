//
//  ActorsBootcamp.swift
//  SwiftConcurrency
//
//  Created by Prakash Rajak on 27/02/26.
//

import SwiftUI

/*
 1. What is the problem that actor are solving
 2. How was this problem solved prior to actors?
 3. Actors can solve the problem!
 */

/*
 //Actor is thread safe since it is isolated and we need to await to get any parameter or function of that isolated context.
 //isolated - means that is in the actor enviroment and we need to use await to access that variable or function.
 //nonisolated - means that is not in the actor enviroment
 
 */

class MyDataManager {
    static let instance = MyDataManager()
    private init() {}
    
    var data: [String] = []
    private let queue = DispatchQueue(label: "com.MyApp.MyDataManager")
    
//    func getRandomData() -> String? {
//        self.data.append(UUID().uuidString)
//        print(Thread.current)
//        return data.randomElement()
//    }
    
    func getRandomData(completionHandler: @escaping (_ title: String?) -> ()) {
        queue.async {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            completionHandler(self.data.randomElement())
        }
    }
}

actor MyActorDataManager {
    static let instance = MyActorDataManager()
    private init() {}
    
    var data: [String] = []
    nonisolated let myRandomText = "dskasncka kdjnwc cskdnikwf wdfjkwd"
    
    func getRandomData() -> String? {
        self.data.append(UUID().uuidString)
        print(Thread.current)
        return data.randomElement()
    }
    
    nonisolated func getSavedData() -> String {
        Task {
            await self.getRandomData()
        }
        
        return "NEW DATA"
    }
}

struct HomeView: View {
    
    let manager = MyActorDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            Color.gray.opacity(0.8)
                .ignoresSafeArea()
            
            Text(text)
                .font(.headline)
            
        }
        .onAppear {
            
            let newString = manager.myRandomText
//            Task {
//                let newString = await manager.getRandomData()
//            }
        }
        .onReceive(timer) { _ in
            Task {
                if let data = await manager.getRandomData() {
                   await MainActor.run {
                       self.text = data
                    }
                }
            }
            
//            DispatchQueue.global(qos: .background).async {
////                if let data = manager.getRandomData() {
////                    DispatchQueue.main.async {
////                        self.text = data
////                    }
////                }
//                
//                manager.getRandomData { title in
//                    if let data = title {
//                        DispatchQueue.main.async {
//                            self.text = data
//                        }
//                    }
//                }
//            }
        }
    }
}

struct BrowseView: View {
    let manager = MyActorDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            Color.yellow.opacity(0.8)
                .ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onReceive(timer) { _ in
            Task {
                if let data = await manager.getRandomData() {
                   await MainActor.run {
                       self.text = data
                    }
                }
            }
//            DispatchQueue.global(qos: .default).async {
////                if let data = manager.getRandomData() {
////                    DispatchQueue.main.async {
////                        self.text = data
////                    }
////                }
//                manager.getRandomData { title in
//                    if let data = title {
//                        DispatchQueue.main.async {
//                            self.text = data
//                        }
//                    }
//                }
//            }
            
            
        }
    }
}

struct ActorsBootcamp: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("HomeScreen", systemImage: "house.fill")
                }
            
            Spacer()
            
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    ActorsBootcamp()
}
