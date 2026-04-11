//
//  StructClassActorBootcamp.swift
//  SwiftConcurrency
//
//  Created by Prakash Rajak on 23/02/26.
//


/*
 Links:
 https://blog.onewayfirst.com/ios/posts/2019-03-19-class-vs-struct/
 https://stackoverflow.com/questions/24217586/structure-vs-class-in-swift-language
 https://medium.com/@vinayakkini/swift-basics-struct-vs-class-31b44ade28ae
 https://stackoverflow.com/questions/24217586/structure-vs-class-in-swift-language/59219141#59219141
 https://stackoverflow.com/questions/27441456/swift-stack-and-heap-understanding
 https://stackoverflow.com/questions/24232799/why-choose-struct-over-class/24232845
 https://www.backblaze.com/blog/whats-the-diff-programs-processes-and-threads/
 https://medium.com/doyeona/automatic-reference-counting-in-swift-arc-weak-strong-unowned-925f802c1b99
 
 VALUE TYPES:
 - Struct, Enum, String, Int, etc
 - Stored in the Stack
 - Faster
 - Thread safe!, since each thread have its own Stack
 - When you assign or pass value type a new copy of data is created.
 
 REFERENCE TYPES:
 - class, Function, Actor
 - Stored in the Heap
 - Slower, but synchronized
 - NOT Thread safe
 - When you assign or pass reference type a new reference to original instance will be created (pointer)
 
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 
 STACK:
 - Stores Value types
 - Variables allocated on the stack are stored directly to the memory, and access
 - Each thread has it's own stack!
 
 HEAP:
 - Stores Reference types
 - Shared across threads!
 - Each thread doesnot have it's own heap!. There is only one HEAP shared across all the threads.
 
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 
 STRUCT:
 - Based on VALUES
 - Can me mutated
 - Stored in the Stack!
 - Thread safe
 
 CLASS:
 - Based on REFERENCES (INSTANCES)
 - Cannot be mutated, We can change values inside the reference.
 - Stored in the Heap!
 - Inherit from other classes
 - Not thread safe
 
 ACTOR:
 - Same as Class, but thread safe!
 
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 
 When to use which structs vs classes
 
 Note - Structs are great for data models specially if you make it immutable
 
 Structs: Data Models, Views
 Classes: ViewModels
 Actors: Shared 'Manager' and 'Data Store'
 
 

 */


import SwiftUI

actor StructClassActorBootcampDataManager { //this class is shared across multiple viewModels/threads.
    func getDataFromDatabase() {
        
    }
}

class StructClassActorBootcampViewModel: ObservableObject {
    @Published var title: String = ""
    
    init() {
        print("ViewModel INIT")
    }
}

struct StructClassActorBootcamp: View {
    
    @StateObject private var viewModel = StructClassActorBootcampViewModel()
    
    let isActive: Bool
    
    init(isActive: Bool) {
        self.isActive = isActive
        print("View INIT")
    }
    
    var body: some View {
        Text("Hello, World!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(isActive ? Color.red : Color.blue)
            .onAppear {
//                runTest()
            }
    }
}

struct StructClassActorBootcampHomeView: View {
    
    @State private var isActive: Bool = false
    
    var body: some View {
        StructClassActorBootcamp(isActive: isActive)
            .onTapGesture {
                isActive.toggle()
            }
    }
}



#Preview {
    StructClassActorBootcamp(isActive: true)
}

extension StructClassActorBootcamp {
    
    private func runTest() {
        print("Test Started!")
        structTest1()
        printDivider()
        classTest1()
        printDivider()
        actorTest1()
//        structTest2()
//        printDivider()
//        classTest2()
    }
    
    private func printDivider() {
        print("""
              --------------------------------------
              """)
    }
    
    private func structTest1() {
        print("structTest1")
        let objectA = MyStruct(title: "Starting title!")
        print("ObjectA: ", objectA.title)
        
        print("Pass the VALUES of objectA to ObjectB.")
        var objectB = objectA
        print("ObjectB: ", objectB.title)
        
        objectB.title = "Second title!"
        print("ObjectB title changed.")
        
        print("ObjectA: ", objectA.title)
        print("ObjectB: ", objectB.title)
        
        
    }
    
    private func classTest1() {
        print("classTest1")
        let objectA = MyClass(title: "Starting title!")
        print("ObjectA: ", objectA.title)
        
        print("Pass the REFERENCE of objectA to ObjectB.")
        let objectB = objectA
        print("ObjectB: ", objectB.title)
        
        objectB.title = "Second title!"
        print("ObjectB title changed.")
        
        print("ObjectA: ", objectA.title)
        print("ObjectB: ", objectB.title)
    }
    
    private func actorTest1() {
        Task {
            print("actorTest1")
            let objectA = MyActor(title: "Starting title!")
            await print("ObjectA: ", objectA.title)
            
            print("Pass the REFERENCE of objectA to ObjectB.")
            let objectB = objectA
            await print("ObjectB: ", objectB.title)
            
            await objectB.updateTitle(newTitle: "Second title!")
            print("ObjectB title changed.")
            
            await print("ObjectA: ", objectA.title)
            await print("ObjectB: ", objectB.title)
        }
    }
}

struct MyStruct {
    var title: String
}

//Immutable struct - Immutable means data inside this struct is not going to change anyway. It means everthing is constant inside the struct.
struct CustomStruct {
    let title: String
    
    func updateTitle(newTitle: String) -> CustomStruct {
        CustomStruct(title: newTitle)
    }
}

struct MutatingStruct {
    private(set) var title: String
    
    init(title: String) {
        self.title = title
    }
    
    mutating func updateTitle(newTitle: String) { //mutating means, take the current values, change them and create new object with new values.
        title = newTitle
    }
}

extension StructClassActorBootcamp {
    private func structTest2() {
        print("structTest2")
        
        var struct1 = MyStruct(title: "Title1")
        print("Struct1: ", struct1.title)
        struct1.title = "Title2" //we are not only changing title, we are creating a whole new object.
        print("Struct1: ", struct1.title)
        
        printDivider()
        
        var struct2 = CustomStruct(title: "Title1")
        print("Struct2: ", struct2.title)
        struct2 = CustomStruct(title: "Title2")
        print("Struct2: ", struct2.title)
        
        printDivider()
        
        var struct3 = CustomStruct(title: "Title1")
        print("Struct3: ", struct3.title)
        struct3 = struct3.updateTitle(newTitle: "Title2")
        print("Struct3: ", struct3.title)
        
        printDivider()
        
        var struct4 = MutatingStruct(title: "Title1")
        print("Struct4: ", struct4.title)
        struct4.updateTitle(newTitle: "Title2")
        print("Struct4: ", struct4.title)
    }
}

class MyClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}

actor MyActor {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}



extension StructClassActorBootcamp {
    private func classTest2() {
        print("classTest2")
        
        let class1 = MyClass(title: "Title1")
        print("Class1: ", class1.title)
        class1.title = "Title2"
        print("Class1: ", class1.title)
        
        printDivider()
        
        let class2 = MyClass(title: "Title1")
        print("Class2: ", class2.title)
        class2.updateTitle(newTitle: "Title2")
        print("Class2: ", class2.title)
    }
}
