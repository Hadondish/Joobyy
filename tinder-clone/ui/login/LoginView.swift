//
//  LoginView.swift
//  Tinder 2
//
//  Created by Kevin and Kyle Tran on 31/12/21.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    struct PopUpWindow: View {
        var title: String
        var message: String
        var buttonText: String
        @Binding var show: Bool

        var body: some View {
            ZStack {
                if show {
                    // PopUp background color
                    Color.black.opacity(show ? 0.3 : 0).edgesIgnoringSafeArea(.all)

                    // PopUp Window
                    VStack(alignment: .center, spacing: 0) {
                        Text(title)
                            .frame(maxWidth: .infinity)
                            .frame(height: 100, alignment: .center)
                            .font(Font.system(size: 23, weight: .semibold))
                            .foregroundColor(Color.white)
                            .background(LinearGradient(colors: AppColor.appColors, startPoint: .leading, endPoint: .trailing))

                        Text(message)
                            .multilineTextAlignment(.center)
                            .font(Font.system(size: 16, weight: .semibold))
                            .padding(EdgeInsets(top: 20, leading: 25, bottom: 20, trailing: 25))
                            .foregroundColor(Color.white)

                        Button(action: {
                            // Dismiss the PopUp
                            withAnimation(.linear(duration: 0.3)) {
                                show = false
                            }
                        }, label: {
                            Text(buttonText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54, alignment: .center)
                                .foregroundColor(Color.white)
                                .background(LinearGradient(colors: AppColor.appColors, startPoint: .leading, endPoint: .trailing))
                                .font(Font.system(size: 23, weight: .semibold))
                        }).buttonStyle(PlainButtonStyle())
                    }
                    .frame(maxWidth: 300)
                    .border(Color.white, width: 2)
                    .background(LinearGradient(colors: AppColor.appColors, startPoint: .leading, endPoint: .trailing))
                }
            }
        }
    }
    @State private var showPopUp: Bool = true

    var body: some View {
        VStack{
            Spacer()
            Image("logoWhite").resizable()
                .scaledToFit()
                .frame(width: 150).padding(40).aspectRatio( contentMode: .fit)
            
            Button{
                authViewModel.signInWithGoogle(controller: getRootViewController())
            } label: {
                HStack{
                    Image("icons8-google-48")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("Sign In with Google")
                        .foregroundColor(.gray)
                }
                .padding(.top, 10)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.bottom, 10)
                
            }.background(.white).cornerRadius(22)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(LinearGradient(colors: AppColor.appColors, startPoint: .leading, endPoint: .trailing)).ignoresSafeArea()
//        PopUpWindow(title: "Welcome", message: "One Job. Many Personalities. One Match", buttonText: "OK", show: $showPopUp)

    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

extension View{
    func getRootViewController() -> UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else{
            return .init()
        }
        
        return root
    }
    
}
