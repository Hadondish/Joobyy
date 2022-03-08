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
    @State private var pictures: [UIImage] = []
    @State private var image = UIImage()
    @State private var previousPicCount: Int = 0
    @State private var userName: String = ""
    @State private var userBirthdate: String = ""
    @State private var userBio: String = ""
    @State private var userHobbies: String = ""
    @State private var userJob: String = ""
    @State private var userMB: String = ""
    @State private var showError: Bool = false

    
    @State private var items: [Item] = [.init(name: "Favorite Songs", details: "Hot or Cold"), .init(name: "Providing Services", details: "iOS Development and Mobile Application Development")]
    
    @State private var currentImageIndex: Int = 0
    
    var body: some View {
        //beginning Vstack
        ScrollView{
        VStack {
            
//            ZStack {
//                GeometryReader { proxy in
//                    Image(uiImage: pictures[0])
//                        .resizable()
//                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 100)
//
//                    Button {} label: {
//                        Image(systemName: "pencil")
//                            .resizable()
//                            .frame(width: 15, height: 15)
//                            .font(.title)
//                            .background(
//                                Circle()
//                                    .foregroundColor(.white)
//                                    .frame(width: 30, height: 30)
//                            )
//                    }
//                    .offset(x: proxy.size.width - 35, y: 25)
//
//                }
//            }
            ZStack(alignment: .bottom){
                GeometryReader{ geometry in
                    Image(uiImage: image)
                        .centerCropped()
//                        .gesture(DragGesture(minimumDistance: 0).onEnded({ value in
//                            if value.translation.equalTo(.zero){
//                                if(value.location.x <= geometry.size.width/2){
//                                    showPrevPicture()
//                                } else { showNextPicture()}
//                            }
//                        }))
                }
                
                
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(0.7, contentMode: .fit)
            .background(.white)
            .cornerRadius(10)
            .shadow(radius: 10)
            Spacer(minLength: 20)
            makeBottomView()
                .padding(.horizontal)
        }}
    }
    
    func makeBottomView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            
            VStack(alignment: .leading) {
                HStack {
                    Text(userName)
                        .font(.system(size: 70))
                        .bold()
                }
                Text(userMB)
                    .font(.largeTitle)
                    .bold()
                    .italic()
                Text(userHobbies)
                    .font(.largeTitle)
                    .bold()
                    .italic()
                Text(userJob)
                    .font(.largeTitle)
                    .bold()
                    .italic()
                Text(userBirthdate)
                    .font(.largeTitle)
                    .bold()
                    .italic()

//                Text("Talks about #swift, #swiftui, and #iosdevelopment")
//                    .font(.caption)
//                    .foregroundColor(.gray)
            }
            Spacer()
            Spacer()
            VStack(alignment: .leading) {
                Text(userBio)
                    .font(.title)
                Text("")
                    .font(.caption)
                    .foregroundColor(.gray)
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
            
        }.onAppear(perform: performOnAppear)
        
    }
    
    private func performOnAppear(){
        firestoreViewModel.fetchMainPicture(profileId: UID){
            result in
                switch(result){
                case .success(let user):
                    image = user
                    return
                case .failure(_):
                    userName = "Failed Lol Loser";
                    return
                }}

    firestoreViewModel.fetchUserProfile(fetchedUserId: UID){ result in
        switch(result){
        case .success(let user):
            populateData(user)
            return
        case .failure(_):
            userName = "Failed Lol Loser";
            return
            
        }

            
    }
    
        firestoreViewModel.fetchUserPictures(onCompletion: { result in
            switch result{
            case .success(let pictureList):
                pictures = pictureList
                previousPicCount = pictureList.count
                return
            case .failure(_):
                return
            }
        }, onUpdate: {result in
            switch result{
            case .success(let pictureList):
                pictures = pictureList
                previousPicCount = pictureList.count
                return
            case .failure(_):
                return
            }
        })
    }
    private func populateData(_ user: FirestoreUser){
        userBio = user.bio
        userName = user.name
        userBirthdate = user.birthDate.getFormattedDate(format: dateFormat)
        userJob = user.job
        userMB = user.mb
        userHobbies = user.hobbies
        initialOrientation = user.orientation
        self.initialBio = userBio
        self.initialOrientation = user.orientation
    }
    private func showNextPicture(){
        if currentImageIndex < pictures.count - 1 {
            currentImageIndex += 1
        }
    }
    
    private func showPrevPicture(){
        if currentImageIndex > 0 {
            currentImageIndex -= 1
        }
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
