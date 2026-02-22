//
//  TaskGroupBootcamp.swift
//  SwiftConcurrency
//
//  Created by Prakash Rajak on 22/02/26.
//

import SwiftUI

class TaskGroupBootcampDataManager {
    let picSumURLStr = "https://picsum.photos/200"
    
    func fetchImagesWithAsyncLet() async throws -> [UIImage] {
        async let fetchImage1 = fetchImage(urlString: picSumURLStr)
        async let fetchImage2 = fetchImage(urlString: picSumURLStr)
        async let fetchImage3 = fetchImage(urlString: picSumURLStr)
        async let fetchImage4 = fetchImage(urlString: picSumURLStr)
        
        let (image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
        
        return [image1, image2, image3, image4]
    }
    
    func fetchImagesWithTaskGroup() async throws -> [UIImage] {
        //1. manually adding task to the group
//        return try await withThrowingTaskGroup(of: UIImage.self) { group in
//            var images: [UIImage] = []
//            
//            //We are adding manually four tasks here.
//            //But for a lot of last, it will be very tedious to add like this manually.
              //we have written below to avoid this
//            group.addTask {
//                try await self.fetchImage(urlString: self.picSumURLStr)
//            }
//            group.addTask {
//                try await self.fetchImage(urlString: self.picSumURLStr)
//            }
//            group.addTask {
//                try await self.fetchImage(urlString: self.picSumURLStr)
//            }
//            group.addTask {
//                try await self.fetchImage(urlString: self.picSumURLStr)
//            }
//            
//            //this is not a normal for loop. it won't loop through immediatly. it will await for all the tasks to come back. as soon as each tasks get completed, it will append results of that tasks into our images array.
//            //If one of them never come back or throw an error, we will wait forever.
//            for try await image in group {
//                images.append(image)
//            }
//            
//            return images
//        }
        
        //1. adding tasks to the group using loop.
        let urlStrings = [
            picSumURLStr,
            picSumURLStr,
            picSumURLStr,
            picSumURLStr,
            picSumURLStr
        ]
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            var images: [UIImage] = []
            images.reserveCapacity(urlStrings.count) //performant boost. tell the compiler that this is going to be the images arr size.
            
            for urlString in urlStrings {
                group.addTask { //inherits metadata like priority from parent Task.
                    try? await self.fetchImage(urlString: urlString) //making try?, since if one fails, entire group doesn't stop or throw an error
                }
            }
            for try await image in group {
                if let image = image {
                    images.append(image)
                }
            }
            
            return images
        }
    }
    
    private func fetchImage(urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
}

class TaskGroupBootcampViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    let manager =  TaskGroupBootcampDataManager()
    
    func getImages() async  {
        //Async-Let
//        if let images = try? await manager.fetchImagesWithAsyncLet() {
//            await MainActor.run {
//                self.images.append(contentsOf: images)
//            }
//        }
        
        //TaskGroup
        if let images = try? await manager.fetchImagesWithTaskGroup() {
            await MainActor.run {
                self.images.append(contentsOf: images)
            }
        }
    }
}

struct TaskGroupBootcamp: View {
    
    @StateObject private var viewModel = TaskGroupBootcampViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Task Group ✌️")
            .task {
                await viewModel.getImages()
            }
        }
    }
}

#Preview {
    TaskGroupBootcamp()
}
