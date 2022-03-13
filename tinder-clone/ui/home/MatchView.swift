//
//  MatchView.swift
//  tinder-clone


import SwiftUI
import Firebase

struct MatchView: View {
    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    let matchName: String
    let matchImage: UIImage
    let matchID: String
    @State private var typingMessage: String = "Nice to meet you. Would you be interested in an interview?🗣"
    let onSendMessageButtonClicked: () -> ()
    let onKeepSwipingClicked: () -> ()
    private var userId: String {
        Auth.auth().currentUser?.uid ?? ""
        
    }
    var body: some View {
        
        VStack{
            Spacer()
            Image("its-a-match").resizable().scaledToFit()
            Text(String(format: NSLocalizedString("its-a-match-text", comment: "Text for when two users match"), matchName)).font(.subheadline).fontWeight(.bold).foregroundColor(.white).padding()
            
            Image(uiImage: matchImage)
                .centerCropped().aspectRatio(0.7, contentMode: .fit)
                .cornerRadius(10)
            Button(action:sendMessage, label: {
                Text("send-message").padding([.leading,.trailing], 25).padding([.top, .bottom], 15)
            }).background(.white).cornerRadius(25).padding(.top)
           
            
            
            Button(action: onKeepSwipingClicked, label: {
                Text("keep-swiping").foregroundColor(.white)
            }).padding(12)
            Spacer()
        }
        .padding()
        .background(LinearGradient(colors: AppColor.appColors.map{$0.opacity(0.8)}, startPoint: .leading, endPoint: .trailing))
    }
//    if(isPresent) { // <-- Here
//                   sendMessage()
//               }
    func sendMessage(){
        firestoreViewModel.sendMessage(matchId: userId > matchID ? userId + matchID : matchID + userId, message: typingMessage)
       
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView(matchName: "Elon", matchImage: UIImage(named: "elon_musk")!, matchID: "", onSendMessageButtonClicked: {}, onKeepSwipingClicked: {})
    }
}

//Personality Matches

//introversion/extraversion(antisocial)

//sensing/intuition,

//thinking/feeling,

//judging/perceiving





