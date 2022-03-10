//
//  SwipeCardView.swift
//  tinder-clone
//
//  Created by Alejandro Piguave on 1/1/22.
//

import SwiftUI
import Firebase

struct SwipeCardView: View {
    let model: UserProfile
    @EnvironmentObject var firestoreViewModel: FirestoreViewModel

    @State private var currentImageIndex: Int = 0
    @State var showingDetail = false
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
                        Button(action: {
                                    self.showingDetail.toggle()
                                }) {
                                    Image(systemName: "person.circle").font(.system(size: 24, weight: .bold)).foregroundColor(.blue)
                                }.sheet(isPresented: $showingDetail) {
                                    ProfileView(UID: model.userId)
                                };
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
