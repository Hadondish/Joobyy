//
//  ContentView.swift
//  tinder-clone





/*
struct Home: View {
    @State private var authState: AuthState? = .loading
    @EnvironmentObject var loginViewModel: AuthViewModel
    
    @ViewBuilder
    func contentBuilder() -> some View {
        switch(loginViewModel.authState){
        case .loading:
            LoadingView()
        case .logged:
            HomeView()
        case .unlogged:
            LoginView()
        case .pendingInformation:
            CreateProfileView()
        }
    }
    
    var body: some View {
        contentBuilder()
            .onAppear(perform: {
                loginViewModel.updateAuthState()
            })
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/


import SwiftUI

struct ContentView: View {
    @AppStorage("currentPage") var currentPage = 1
    var body: some View {
     Home()
        
        //Onboard screens
//        if currentPage > totalPages{
//            Home()
//        }
//        else{
//            WalkthroughScreen()
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// little Home Page....
/*  struct Home: View {
    
    var body: some View{
        
        Text("Welcome To Home !!!")
            .font(.title)
            .fontWeight(.heavy)
    }
}
*/
 
//home Page

struct Home: View {
    @State private var authState: AuthState? = .loading
    @EnvironmentObject var loginViewModel: AuthViewModel
    
    @ViewBuilder
    func contentBuilder() -> some View {
        switch(loginViewModel.authState){
        case .loading:
            LoadingView()
        case .logged:
            HomeView()
        case .unlogged:
            LoginView()
        case .pendingInformation:
            CreateProfileView()
        }
    }
    
    var body: some View {
        contentBuilder()
            .onAppear(perform: {
                loginViewModel.updateAuthState()
            })
    }
}
 

// WalkThrough SCreen....

struct WalkthroughScreen: View {
    
    @AppStorage("currentPage") var currentPage = 1
    
    
    //Variables for the Answers to the Onboard
    @State  var firstAnswer: String = ""
    @State  var secondAnswer: String = ""
    @State  var thirdAnswer: String = ""
    
    
    
    var body: some View{
        
        // For Slide Animation...
        
        ZStack{
            
            // Changing Between Views....
            
            if currentPage == 1{
                ScreenView(image: "image1", title: "Step 1", detail: "", bgColor: Color("color1"), question: "If you could compare yourself with any animal, which would it be and why? 🐶", answer: firstAnswer)
                    .transition(.scale)
            }
            if currentPage == 2{
            
                ScreenView(image: "image2", title: "Step 2", detail: "", bgColor: Color("color2"), question: "How many square feet of pizza are eaten in the U.S. each year? 🍕", answer: secondAnswer)
                    .transition(.scale)
            }
            
            if currentPage == 3{
                
                ScreenView(image: "image3", title: "Step 3", detail: "", bgColor: Color("color3"), question: "Who would be your ideal coworker and why? 👨🏻‍💼", answer: thirdAnswer)
                    .transition(.scale)
            }
            
        }
        .overlay(
        
            // Button...
            Button(action: {
                // changing views...
                withAnimation(.easeInOut){
                    
                    // checking....
                    if currentPage <= totalPages{
                        currentPage += 1
                    }
                }
            }, label: {
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 60, height: 60)
                    .background(Color.white)
                    .clipShape(Circle())
                // Circlular Slider...
                    .overlay(
                    
                        ZStack{
                            
                            Circle()
                                .stroke(Color.black.opacity(0.04),lineWidth: 4)
                                
                            
                            Circle()
                                .trim(from: 0, to: CGFloat(currentPage) / CGFloat(totalPages))
                                .stroke(Color.white,lineWidth: 4)
                                .rotationEffect(.init(degrees: -90))
                        }
                        .padding(-15)
                    )
            })
            .padding(.bottom,20)
            
            ,alignment: .bottom
        )
    }
}

struct ScreenView: View {
    
    var image: String
    var title: String
    var detail: String
    var bgColor: Color
    
    //Questions and Answers
    var question: String
    var answer: String
    
    @AppStorage("currentPage") var currentPage = 1
    @State private var goodAnswer: String = ""
    
    var body: some View {
        VStack(spacing: 20){
            
            HStack{
                
                // Showing it only for first Page...
                if currentPage == 1{
                    Text("Hello!👋")
                        .font(.title)
                        .fontWeight(.semibold)
                        // Letter Spacing...
                        .kerning(1.4)
                }
                else{
                    // Back Button...
                    Button(action: {
                        withAnimation(.easeInOut){
                            currentPage -= 1
                        }
                    }, label: {
                        
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding(.vertical,10)
                            .padding(.horizontal)
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(10)
                    })
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut){
                        currentPage = 4
                    }
                }, label: {
                    Text("Skip")
                        .fontWeight(.semibold)
                        .kerning(1.2)
                })
            }
            .foregroundColor(.black)
            .padding()
            
            Spacer(minLength: 0)
            
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top)
            
            // Change with your Own Thing....
            Text(question)
                .fontWeight(.semibold)
                .kerning(1.3)
                .multilineTextAlignment(.center)
            
            TextField("Enter your answer", text: $goodAnswer)
            
            
            //If you could compare you
            
            //Letting User text an answer
           
                
            
            
            // Minimum Spacing When Phone is reducing...
            
            Spacer(minLength: 120)
        }
        .background(bgColor.cornerRadius(10).ignoresSafeArea())
    }
}

// total Pages...
var totalPages = 3




