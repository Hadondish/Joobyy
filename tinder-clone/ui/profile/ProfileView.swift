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
import Firebase

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
    private var CurrentUserId: String {
        Auth.auth().currentUser?.uid ?? ""
        
    }
    private let dateFormat = "MMM d, yyyy"
    @State private var initialBio = ""
    @State private var initialGender = ""
    @State private var initialOrientation: Orientation = .both
    @State private var loading = true

    @State private var portfolio: String = ""
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
    @State private var userFristQ: String = ""
    @State private var userSecondQ: String = ""
    @State private var userThirdQ: String = ""
    @State private var personalityText: String = ""
    @State private var showError: Bool = false
    @State var showingDetail = false
    
    

    
  
    
    @State private var currentImageIndex: Int = 0
    
    var body: some View {
        //beginning Vstack
        ScrollView{
        VStack {
            Spacer().frame(height: 40)
            
            HStack{
                
                VStack(spacing: 0){
                    Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 175, height: 175)
                                        .cornerRadius(image.size.width/2)

                }
                
                VStack(alignment: .leading, spacing: 5){
                    
                    Text(userName)
                        .font(.title)
                    
                    Text(userMB).bold()
                        .padding(.top, 8)
                    
                    Text(userJob).bold()
                }
                .padding(.leading, 20)
                
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            if (!portfolio.isEmpty){ Button(action: {
                if let yourURL = URL(string: portfolio) {
                    UIApplication.shared.open(yourURL, options: [:], completionHandler: nil)
                }
            }) {
               Text("Check out my Portfolio!")
            }} else {
                Text("I am working on my portfolio!")

            }
           
            Spacer().frame(height: 40)
            HStack{
                Text(userBio)
               
            }
            .padding(.horizontal,8)
            .padding(.vertical,5)
            .background(Color("Color1"))
            .cornerRadius(8)
            .padding(.horizontal)
            .padding(.top,25)
            makeBottomView()
                .padding(.horizontal)
        }}
    }
    
    func makeBottomView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            
            VStack(alignment: .leading) {
//                Text(userName)
//                Text(userMB)
//                    .bold()
//                    .italic()
//                Text(userJob)
//                    .bold()
//                    .italic()
//                Text(userBio)
                Text("If you could compare yourself with any animal, which would it be and why? 🐶")
                    .bold()
                    .italic()
                Text(userFristQ)
                    .italic()
                Text("How many square feet of pizza are eaten in the U.S. each year? 🍕")
                    .bold()
                    .italic()
                Text(userSecondQ)
                    .italic()
                Text("Who would be your ideal coworker and why? 👨🏻‍💼")
                    .bold()
                    .italic()
                Text(userThirdQ)
                    .italic()
//                forEach(pictures.count)
//                Text("Talks about #swift, #swiftui, and #iosdevelopment")
//                    .font(.caption)
//                    .foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .leading) {
                Text("Hobbies")
                    .bold()
                    .italic()
                Text(userHobbies)
                    .italic()
//                Text(portfolio).bold().italic()
                

                // Set how links should appear: blue and underlined
//                self.textView.linkTextAttributes = [
//                    .foregroundColor: UIColor.blue,
//                    .underlineStyle: NSUnderlineStyle.single.rawValue
//                ]

               
            }
           

            ZStack(alignment: .bottom){
                if (loading){
                    ProgressView()
                }else{
                    GeometryReader{ geometry in
                        Image(uiImage: pictures[currentImageIndex])
                            .centerCropped()
                            .gesture(DragGesture(minimumDistance: 0).onEnded({ value in
                                if value.translation.equalTo(.zero){
                                    if(value.location.x <= geometry.size.width/2){
                                        showPrevPicture()
                                    } else { showNextPicture()}
                                }
                            }))
                    }
                }
                VStack{
                    if(pictures.count > 1){
                        HStack{
                            ForEach(0..<pictures.count, id: \.self){ index in
                                Rectangle().frame(height: 3).foregroundColor(index == currentImageIndex ? .white : .gray).opacity(index == currentImageIndex ? 1 : 0.5)
                            }
                        }
                        .padding(.top, 6)
                        .padding(.leading)
                        .padding(.trailing)
                    }
                    Spacer()
        
                }
                .frame(maxWidth: .infinity)
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(0.7, contentMode: .fit)
            .background(.white)
            .cornerRadius(10)
            .shadow(radius: 10)
        
        
//            makeButtonView()
//
//            ScrollView(.horizontal, showsIndicators: false) {
//                LazyHStack {
//                ForEach(items) { item in
//                    makeCell(for: item)
//                }
//                }
//            }
//            .frame(height: 100)
            
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
            
        }}
        firestoreViewModel.fetchProfilePictures(profileId: UID){ result in
            switch(result){
            case .success(let user):
                loading = false;
                pictures.append(contentsOf: user);
                return
            case .failure(_):
                userName = "Failed Lol Loser";
                return
                
            }}

            
    }
    
        
    
    private func populateData(_ user: FirestoreUser){
        userBio = user.bio
        if (user.portfolio.contains("https://")){
            portfolio = user.portfolio
        }
        else if(user.portfolio.isEmpty){}
        else{
            portfolio = "https://" + user.portfolio
        }
        userName = user.name
        userBirthdate = user.birthDate.getFormattedDate(format: dateFormat)
        userJob = user.job
        userMB = user.mb
        userHobbies = user.hobbies
        initialOrientation = user.orientation
        userFristQ = user.firstAnswer
        userSecondQ = user.secondAnswer
        userThirdQ = user.thirdAnswer
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
