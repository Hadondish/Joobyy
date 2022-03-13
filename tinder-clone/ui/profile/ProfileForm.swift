//
//  ProfileScrollView.swift
//  tinder-clone
//
//  Created by Kevin and Kyle Tran on 13/1/22.
//

import SwiftUI

struct ProfileForm<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    var content: () -> Content
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    var body: some View {
        ScrollView(content: content)
            .background(colorScheme == .dark ? .black : AppColor.lighterGray)
    }
}

struct ProfileScrollView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileForm{
            
        }
    }
}


