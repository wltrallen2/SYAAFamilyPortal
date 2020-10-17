//
//  ForgotPasswordView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/8/20.
//  Copyright © 2020 Forty Something Nerd. All rights reserved.
//

import SwiftUI

struct SentPwdResetView: View {
    
    var body: some View {        
        VStack (spacing: 0){
            Group {
                VStack {
                    Spacer()
                    
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .foregroundColor(Color.myGreen)
                        .frame(width: 200, height: 200, alignment: .center)
                    
                    Text(Constants.Content.SentPwdResetString)
                        .multilineTextAlignment(.center)
                        .padding(8)
                        .padding(.top, 24)
                    
                    Spacer()
                    

                }
                .padding(24)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .background(Color.lightGray)
        }
    }
}

struct SentPwdResetView_Previews: PreviewProvider {
    static var previews: some View {
        SentPwdResetView()
            .statusBar(hidden: false)
    }
}
