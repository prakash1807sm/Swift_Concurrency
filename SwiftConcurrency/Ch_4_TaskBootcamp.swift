//
//  TaskBootcamp.swift
//  SwiftConcurrency
//
//  Created by Prakash Rajak on 21/02/26.
//

import SwiftUI

class TaskBootcampViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fetchImage() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        
//        Task.checkCancellation()
//        for x in 1...100000{
//            //Suppose you are looping here and Task has been cancelled than you will get error.
//            //To avoid this use Task.checkCancellation()
//            do {
//                try Task.checkCancellation()
//            } catch {
//                print("Task cancelled error: \(error)")
//            }
//        }
        do {
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                self.image = UIImage(data: data)
                print("IMAGE RETURNED SUCCESSFULLY")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                self.image2 = UIImage(data: data)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

struct TaskBootcampHomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("CLICK ME!😎") {
                    TaskBootcamp()
                }
            }
        }
    }
}

struct TaskBootcamp: View {
    
    @StateObject private var viewModel = TaskBootcampViewModel()
    @State private var fetchImageTask : Task<(), Never>? = nil
    
    var body: some View {
        VStack (spacing: 40){
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task { //creates Async enviroment before view appears. will cancel all scheduled task if not completed yet  if view disappears.
            await viewModel.fetchImage()
        }
//        .onDisappear {
//            fetchImageTask?.cancel()
//        }
//        .onAppear {
//            fetchImageTask = Task{
//                print(Thread.current)
//                print(Task.currentPriority)
//                await viewModel.fetchImage()
//            }
////            Task {
////                print(Thread.current)
////                print(Task.currentPriority)
////                await viewModel.fetchImage2()
////            }
//            //Priorities doesn't guarantee that which will be finished first. It just submit the task based on given priority. low priority task may FINISH before high priority task. but high priority will always be submitted before low priority task.
//            
////            Task(priority: .high) { //25
//////                try? await Task.sleep(nanoseconds: 2_000_000_000)
////                await Task.yield()
////                print("high: \(Thread.current) : \(Task.currentPriority.rawValue)")
////            }
////            Task(priority: .userInitiated) {//25
////                print("userInitiated: \(Thread.current) : \(Task.currentPriority.rawValue)")
////            }
////            
////            Task(priority: .medium) {//21
////                print("medium: \(Thread.current) : \(Task.currentPriority.rawValue)")
////            }
////            
////            Task(priority: .low) {//17
////                print("low: \(Thread.current) : \(Task.currentPriority.rawValue)")
////            }
////            Task(priority: .utility) {//17
////                print("utility: \(Thread.current) : \(Task.currentPriority.rawValue)")
////            }
////            
////            Task(priority: .background) {//9
////                print("background: \(Thread.current) : \(Task.currentPriority.rawValue)")
////            }
//            
//            //Detached
////            Task(priority: .low) {
////                print("low: \(Thread.current) : \(Task.currentPriority.rawValue)")
////
////                Task { //child task inherit priorities and inherent data from parent task
////                    print("low2: \(Thread.current) : \(Task.currentPriority.rawValue)")
////                }
////                
////                Task.detached { //detach from the parent task. you should avoid using detached as per apple.
////                    print("detached: \(Thread.current) : \(Task.currentPriority.rawValue)")
////                }
////            }
//        }
    }
}

#Preview {
    TaskBootcamp()
}
