//
//  CustomErrorArea.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/7/20.
//  Copyright © 2020 Forty Something Nerd. All rights reserved.
//

import SwiftUI

struct CustomErrorArea: View {
    var message: String?
    
    var body: some View {
        Text(self.message ?? "")
            .font(.system(size: 16))
            .italic()
            .lineSpacing(0)
            .foregroundColor(Color.red)
            .allowsTightening(true)
            .frame(width: 300, height: 80, alignment: .topLeading)
            .multilineTextAlignment(.center)
    }
    
}

struct CustomErrorArea_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomErrorArea(message: Constants.Content.ServerAccessError)
                .previewLayout(.sizeThatFits)
            
            CustomErrorArea(message: Constants.Content.ForgotPwdInfoString)
                    .previewLayout(.sizeThatFits)

        }
    }
}
