//
//  CheckedContinuationBootcamp.swift
//  SwiftConcurrency
//
//  Created by Prakash Rajak on 22/02/26.
//

import SwiftUI

class CheckedContinuationBootcampNetworkManager {
    func getData(url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate:  nil)
            return data
        } catch {
            throw error
        }
    }
    
    func getData2(url: URL) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    continuation.resume(returning: data)// resume should be exactly once, not zero or more than once. Overall, continuation.resume should not be executed for more than once whether it is for returning result or throwing error.
                } else if let error = error {
                    continuation.resume(throwing: error) //in error case, we are throwing error using resume.
                } else {
                    continuation.resume(throwing: URLError(.badURL)) //to resume continuation and throwing error.
                }
            }
            .resume()
        }
        
        //checkedContinuation -
//        try await withCheckedThrowingContinuation { continuation in
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                if let data = data {
//                    continuation.resume(returning: data)
//                }
//            }.resume()
//        }
//
        
        //UnsafeContinuation
        //It avoids run time check. so it's a little be faster compared to checkedContinuation. But never use this in production code unless you understand it very well.
//        try await withUnsafeThrowingContinuation { continuation in
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                if let data = data {
//                    continuation.resume(returning: data)
//                }
//            }.resume()
//        }
    }
    
    func getHeartImageFromDatabase(completionHandler: @escaping (_ image: UIImage) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            completionHandler(UIImage(systemName: "heart.fill")!)
        }
    }
    
    func getHeartImageFromDatabase() async -> UIImage {
        return await withCheckedContinuation { continuation in
            getHeartImageFromDatabase { image in
                continuation.resume(returning: image)
            }
        }
    }
}

class CheckedContinuationBootcampViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let networkManager = CheckedContinuationBootcampNetworkManager()
    
    func getImage() async {
        guard let url = URL(string: "https://picsum.photos/200") else {
            return
        }
        do {
            let data = try await networkManager.getData2(url: url)
            if let image = UIImage(data: data) {
                await MainActor.run {
                    self.image = image
                }
            }
        } catch {
            print(error)
        }
    }
    
    func getHeartImage() {
        networkManager.getHeartImageFromDatabase { [weak self] image in
            self?.image = image
        }
    }
    
    func getHeartImageAsync() async {
        let image = await networkManager.getHeartImageFromDatabase()
        await MainActor.run {
            self.image = image
        }
    }
}

struct CheckedContinuationBootcamp: View {
    @StateObject private var viewModel = CheckedContinuationBootcampViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
//            await viewModel.getImage()
//            await viewModel.getHeartImage()
            await viewModel.getHeartImageAsync()
        }
    }
}

#Preview {
    CheckedContinuationBootcamp()
}
