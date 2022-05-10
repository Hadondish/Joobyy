//
//  SwipeCardView.swift
//  tinder-clone
//
//  Created by Kevin and Kyle Tran on 1/1/22.
//

import SwiftUI
import Firebase

struct SwipeCardView: View {
    let model: UserProfile
    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    
    @State private var currentImageIndex: Int = 0
    @State var showingDetail = false
    @State private var loading = true
    @State private var isLoading: Bool = false
    @State private var userName: String = ""
    @State private var userBirthdate: String = ""
    @State private var userBio: String = ""
    @State private var userHobbies: String = ""
    @State private var userJob: String = ""
    @State private var userMB: String = ""
    @State private var showError: Bool = false
    private var CurrentUserId: String {
        Auth.auth().currentUser?.uid ?? ""
        
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
            GeometryReader{ geometry in
                Image(uiImage: model.pictures[currentImageIndex])
                    .centerCropped()
                    .gesture(DragGesture(minimumDistance: 0).onEnded({ value in
                        if value.translation.equalTo(.zero){
                            if(value.location.x <= geometry.size.width/2){
                                showPrevPicture()
                            } else { showNextPicture()}
                        }
                    }))
            }
            
            VStack{
                if(model.pictures.count > 1){
                    HStack{
                        ForEach(0..<model.pictures.count, id: \.self){ index in
                            Rectangle().frame(height: 3).foregroundColor(index == currentImageIndex ? .white : .gray).opacity(index == currentImageIndex ? 1 : 0.5)
                        }
                    }
                    .padding(.top, 6)
                    .padding(.leading)
                    .padding(.trailing)
                }
                Spacer()
                VStack{
                    HStack(alignment: .firstTextBaseline){
                        Text(model.name).font(.largeTitle).fontWeight(.semibold)
                        Text(String(firestoreViewModel.fetchMutuals(fetchedUserId: CurrentUserId, fetchedUserId2: model.userId))).font(.title).fontWeight(.medium)
                        Text("Mutuals")
                        Spacer()
                        Button(action: {
                                    self.showingDetail.toggle()
                                }) {
                                    Image(systemName: "person.circle").font(.system(size: 24, weight: .bold)).foregroundColor(.blue)
                                }.sheet(isPresented: $showingDetail) {
                                    ProfileView(UID: model.userId)
                                };
                        Spacer()
                    }
                    HStack(alignment: .firstTextBaseline){
                        Text(userMB).bold()
                        Spacer()

                    }
                    HStack(alignment: .firstTextBaseline){
                        Text(userJob).bold()
                        Spacer()

                    }
                    
                   
                }
                .padding()
                .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(0.7, contentMode: .fit)
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        .onAppear(perform: performOnAppear)
    }
    
    private func performOnAppear(){
       

        firestoreViewModel.fetchUserProfile(fetchedUserId: model.userId){ result in
        switch(result){
        case .success(let user):
            populateData(user)
            return
        case .failure(_):
            userName = "Failed Lol Loser";
            return
            
        }}
            
    }
    
        
    private func populateData(_ user: FirestoreUser){
        userBio = user.bio
        userName = user.name
        userJob = user.job
        userMB = user.mb
    }
    
    private func showNextPicture(){
        if currentImageIndex < model.pictures.count - 1 {
            currentImageIndex += 1
        }
    }
    
    private func showPrevPicture(){
        if currentImageIndex > 0 {
            currentImageIndex -= 1
        }
    }
}

struct SwipeCardView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeCardView(model: UserProfile(userId: "defdwsfewfes", name: "Michael Jackson", age: 50, pictures: [UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!]))
    }
}
