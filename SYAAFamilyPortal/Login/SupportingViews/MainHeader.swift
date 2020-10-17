//
//  MainHeader.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/7/20.
//  Copyright © 2020 Forty Something Nerd. All rights reserved.
//

import SwiftUI

struct MainHeader: View {
    var subHeadImageString: String?
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(minHeight: 150, maxHeight: 215)
            Image("Text-FamilyPortal")
                .resizable()
                .scaledToFit()
                .padding(.top, -15)
                .padding(.bottom, -10)
            if subHeadImageString != nil {
                Divider()
                    .frame(height: 2)
                    .background(Color.black)
                    .cornerRadius(10)
                Image(subHeadImageString!)
                    .resizable()
                    .scaledToFit()
                    .padding(.top, -15)
            }
        }
        .frame(maxWidth: 500)
    }
}

struct MainHeader_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainHeader()
                .previewLayout(.sizeThatFits)
            
            MainHeader(subHeadImageString: "Text-CreateAccount")
                    .previewLayout(.sizeThatFits)

            MainHeader(subHeadImageString: "Text-LinkAccount")
                    .previewLayout(.sizeThatFits)

        }
    }
}
