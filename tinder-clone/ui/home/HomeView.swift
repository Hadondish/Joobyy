//
//  HomeView.swift
//  Tinder 2
//
//  Created by Kevin and Kyle Tran on 31/12/21.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    @State private var profiles: [UserProfile] = []
    @State private var swipeViewLoading = true
    @State private var anim = false
    @State private var showMatchView = false
    @State private var matchName = ""
    @State private var matchID = ""

    @State private var matchImage: UIImage = UIImage()
   

    var body: some View {
        ZStack{
            NavigationView{
                VStack{
                    if(swipeViewLoading){
                        FilledLoadingView()
                    } else {
                        SwipeView(profiles: $profiles, onSwiped: { userModel, hasLiked in
                            firestoreViewModel.swipeUser(swipedUserId: userModel.userId, hasLiked: hasLiked, onMatch: {
                                matchID = userModel.userId
                                matchName = userModel.name
                                matchImage = userModel.pictures.first!
                                withAnimation{
                                    showMatchView.toggle()
                                }
                            })
                        })
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading){
                        NavigationLink(destination: EditProfileView(), label: {
                            Image(systemName: "person.crop.circle").foregroundGradient(colors: AppColor.appColors).frame(maxWidth: .infinity)
                        })
                    }

                    ToolbarItem(placement: .principal){
                        Image("logo").resizable().scaledToFit().frame(height: 35)
                            .foregroundGradient(colors: AppColor.appColors)
                            .frame(maxWidth: .infinity)
                    }

                    ToolbarItem(placement: .navigationBarTrailing){
                        NavigationLink(destination: MatchListView(), label: {
                            Image(systemName: "bubble.left.and.bubble.right.fill").foregroundGradient(colors: AppColor.appColors).frame(maxWidth: .infinity)
                        })
                    }
                }
            }
            .onAppear(perform: performOnAppear)
            
            if(showMatchView){
                MatchView(matchName: matchName, matchImage:matchImage,matchID: matchID, onSendMessageButtonClicked: {
                    withAnimation{
                        showMatchView.toggle()
                    }
                }, onKeepSwipingClicked: {
                    withAnimation{
                        showMatchView.toggle()
                    }
                })
            }
        }
    }
    
    private func performOnAppear(){
        var userId: String? {
            Auth.auth().currentUser?.uid
        }
        let pushManager = PushNotificationManager(userID: userId ?? "");
        pushManager.registerForPushNotifications()
        swipeViewLoading = true
        firestoreViewModel.fetchProfiles(onCompletion: {result in
            swipeViewLoading = false
            switch(result){
            case .success(let profiles):
                self.profiles = profiles
                return
            case .failure(_):
                return
            }
        })
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
