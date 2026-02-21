//
//  AsyncLetBootcamp.swift
//  SwiftConcurrency
//
//  Created by Prakash Rajak on 22/02/26.
//

import SwiftUI

struct AsyncLetBootcamp: View {
    @State private var images: [UIImage] = []
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let url: URL = URL(string: "https://picsum.photos/200")!
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Async Let ✌️")
        }
        .onAppear {
            Task {
                do {
                    
                    async let fetchImage1 = fetchImage()
                    async let fetchTitle1 = fetchTitle()
                    
                    let (image, title) =  await(try fetchImage1, fetchTitle1)
                    
                    self.images.append(image)
                    //But for 100, will we write 100 async let, offcourse not, we will use TaskGroup.
                    
//                    async let fetchImage1 = fetchImage()
//                    async let fetchImage2 = fetchImage()
//                    async let fetchImage3 = fetchImage()
//                    async let fetchImage4 = fetchImage()
//                    async let fetchImage5 = fetchImage()
//                    async let fetchImage6 = fetchImage()
//                    async let fetchImage7 = fetchImage()
//                    async let fetchImage8 = fetchImage()
//                    
//                    let (image1, image2, image3, image4, image5, image6, image7, image8) = await(try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4, try fetchImage5, try fetchImage6, try fetchImage7, try fetchImage8)
//
//                    self.images.append(contentsOf: [image1, image2, image3, image4, image5, image6, image7, image8])
                    
                    //Note: in async let, use try?. since if we are using try, and if it fails, execution will directly go to catch block but with try?, it will set that particular value as nil and will try all other one.
                    
//                    let image1 = try await fetchImage()
//                    self.images.append(image1)
//                    
//                    let image2 = try await fetchImage()
//                    self.images.append(image2)
//                    
//                    let image3 = try await fetchImage()
//                    self.images.append(image3)
//                    
//                    let image4 = try await fetchImage()
//                    self.images.append(image4)
//                    
//                    let image5 = try await fetchImage()
//                    self.images.append(image5)
//                    
//                    let image6 = try await fetchImage()
//                    self.images.append(image6)
//                    
//                    let image7 = try await fetchImage()
//                    self.images.append(image7)
//                    
//                    let image8 = try await fetchImage()
//                    self.images.append(image8)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchTitle() async -> String {
        return "NEW TITLE"
    }
    
    func fetchImage() async throws -> UIImage {
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

#Preview {
    AsyncLetBootcamp()
}
