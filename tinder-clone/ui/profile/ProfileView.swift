//
//  ProfileView.swift
//  tinder-clone
//
//  Created by Kyle Tran on 3/3/22.
//

//import SwiftUI
//
//struct ProfileView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}

//
//  ProfileView.swift
//  TestOne
//
//  Created by Stebin Alex on 04/12/21.
//

import SwiftUI

struct Item: Identifiable {
    var id = UUID()
    var name: String
    var details: String
}

struct ProfileView: View {
    let UID: String
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    private let dateFormat = "MMM d, yyyy"
    @State private var initialBio = ""
    @State private var initialGender = ""
    @State private var initialOrientation: Orientation = .both
    
    @State private var isLoading: Bool = false
    @State private var userName: String = ""
    @State private var userBirthdate: String = ""
    @State private var userBio: String = ""
    @State private var showError: Bool = false

    
    @State private var items: [Item] = [.init(name: "Open to work", details: "iOS Developer roles"), .init(name: "Providing Services", details: "iOS Development and Mobile Application Development")]
    
    @State private var currentImageIndex: Int = 0

    var body: some View {
        VStack {
            
            ZStack {
                GeometryReader { proxy in
                    Image("cover")
                        .resizable()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                    
                    Button {} label: {
                        Image(systemName: "pencil")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .font(.title)
                            .background(
                                Circle()
                                    .foregroundColor(.white)
                                    .frame(width: 30, height: 30)
                            )
                    }
                    .offset(x: proxy.size.width - 35, y: 25)
                    
                }
            }
            Spacer(minLength: 50)
            makeBottomView()
                .padding(.horizontal)
        }
    }
    
    func makeBottomView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                ZStack{
                    Image("56")
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                        .overlay(Circle().stroke(Color.white,lineWidth:2))
                    Button {} label: {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                            .background(
                                Circle()
                                    .foregroundColor(.white)
                                    .frame(width: 30, height: 30)
                                    .overlay(Circle().stroke(Color.gray,lineWidth: 0.5))
                            )
                    }
                    .offset(x: 30, y: 30)
                }
                Spacer()
                Button {} label: {
                    Image(systemName: "pencil")
                        .font(.title)
                        .foregroundColor(.black)
                }
                .offset(y: 20)
                
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(userName)
                        .font(.title2)
                    Image(systemName: "speaker.wave.2.fill")
                }
                Text(userName)
                    .font(.subheadline)
                Text("Talks about #swift, #swiftui, and #iosdevelopment")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading) {
                Text("LEAN TRANSITION SOLUTIONS - LTS")
                    .font(.subheadline)
                Text("Thiruvananthapuram, Kerala, India")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            HStack {
                Text(UID)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                Circle()
                    .frame(width: 2, height: 2)
                Text("500+ connections")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            
            
            makeButtonView()
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                ForEach(items) { item in
                    makeCell(for: item)
                }
                }
            }
            .frame(height: 100)
            
        }
        
    }
    private func performOnAppear(){
    firestoreViewModel.fetchUserProfile(fetchedUserId: UID){ result in
        switch(result){
        case .success(let user):
            populateData(user)
            return
        case .failure(_):
            self.showError = true
            return
            
        }
    }}
    private func populateData(_ user: FirestoreUser){
        userBio = user.bio
        userName = user.name
        userBirthdate = user.birthDate.getFormattedDate(format: dateFormat)
        
        initialOrientation = user.orientation
        self.initialBio = userBio
        self.initialOrientation = user.orientation
    }
    
    func makeCell(for item: Item) -> some View {
        VStack(alignment: .leading,spacing: 5) {
            HStack {
                Text(item.name)
                    .font(.subheadline)
                Spacer()
                Button {} label: {
                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .font(.title)
                        .foregroundColor(.black)
                    
                }
            }
            Text(item.details)
                .font(.caption)
            Text("See all details")
                .font(.caption)
                .foregroundColor(.blue)
        }
        .frame(idealWidth: 300, maxHeight: .infinity)
        .padding()
        .background(Color.gray)
        .cornerRadius(15)
    }
    
    func makeButtonView() -> some View {
        HStack {
            Button{} label: {
                ZStack {
                    Capsule()
                    Text("Open to")
                        .foregroundColor(.white)
                }
            }
            
            Button {} label: {
                ZStack {
                    Capsule()
                        .foregroundColor(.white)
                        .overlay(Capsule().stroke(Color.gray,lineWidth: 1.0))
                    Text("Add section")
                        .foregroundColor(.gray)
                }
            }
            
            Button {} label: {
                ZStack {
                    Capsule()
                        .foregroundColor(.white)
                        .overlay(Circle().stroke(Color.gray,lineWidth: 1.0))
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 30)
        }
        .frame(height: 30)
    }
}

struct RealProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(UID: "")
    }
}
