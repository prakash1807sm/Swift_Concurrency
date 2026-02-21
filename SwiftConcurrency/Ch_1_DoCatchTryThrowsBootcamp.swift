//
//  DoCatchTryThrowsBootcamp.swift
//  SwiftConcurrency
//
//  Created by Prakash Rajak on 21/02/26.
//

import SwiftUI

//do-catch
//try
//throws

class DoCatchTryThrowsBootcampDataManager {
    let isActive: Bool = true
    
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return ("NEW TEXT!", nil)
        } else {
            return (nil, URLError(.badURL))
        }
    }
    
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("NEW TEXT!")
        } else {
            return .failure(URLError(.appTransportSecurityRequiresSecureConnection))
        }
    }
    
    func getTitle3() throws -> String {
        if false {
            return "NEW TEXT!"
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    func getTitle4() throws -> String {
        if isActive {
            return "FINAL TEXT!"
        } else {
            throw URLError(.badServerResponse)
        }
    }
}

class DoCatchTryThrowsBootcampViewModel: ObservableObject {
    @Published var text = "Starting text."
    
    let manager = DoCatchTryThrowsBootcampDataManager()
    
    func fetchTitle() {
        //Tuple
        /*
        let returnedValue = manager.getTitle()
        if let newTitle = returnedValue.title {
            self.text = newTitle
        } else if let error = returnedValue.error {
            self.text = error.localizedDescription
        }
         */
        
        //Result enum
        /*
        let result = manager.getTitle2()
        switch result {
        case .success(let newTitle):
            self.text = newTitle
        case .failure(let error):
            self.text = error.localizedDescription
        }
         */
        
        //throws
        
        //try?
//        let newTitle = try? manager.getTitle3()
//        if let newTitle = newTitle {
//            self.text = newTitle
//        }
        
        //try!
//        let newTitle = try! manager.getTitle3()
//        self.text = newTitle
        
        do { // can be written multiple try statement inside a do block. as soon as we get an error in try statement, execution goes to catch block immediatly.
//            let newTitle = try? manager.getTitle3()
//            if let newTitle = newTitle {
//                self.text = newTitle
//            }
            let newTitle = try! manager.getTitle3()
            self.text = newTitle
            
            let finalTitle = try manager.getTitle4()
            self.text = finalTitle
        } catch {
            self.text = error.localizedDescription
        }
        
        
        //try vs try? vs try!
        //1.try - we need to perform this inside a do catch. we use this when we want to handle error throws by the try statement.
        
        //2.try? - we use this when we don't want to handle error and if it fails returns nil. stored var is optional in this case. don't need catch block in this case, i.e do-catch is optinal. One more thing, if it will throw an error and we are using do catch block, execution will not go to catch block for this.
        
        //3.try! - we forcefully execute the try statement and if it fails, it will crash. we generally use only if it's guaranteed if we will get success response. In this case stored var is  not optinal. don't need catch block in this case, i.e do-catch is optinal. One more thing, if it will throw an error and we are using do catch block, execution will not go to catch block for this. Do not use this i.e explicitly unwrap.
        
        
        
    }
}

struct DoCatchTryThrowsBootcamp: View {
    
    @StateObject private var viewModel =  DoCatchTryThrowsBootcampViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(Color.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

#Preview {
    DoCatchTryThrowsBootcamp()
}
