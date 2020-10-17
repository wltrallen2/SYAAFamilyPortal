//
//  ForgotPasswordParentView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/3/20.
//

import SwiftUI

struct ForgotPasswordParentView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var emailSent: Bool = false
    
    var body: some View {
        VStack (spacing: 0){
            if emailSent {
                CustomViewHeader(viewTitle: "Email Sent!",
                                 rightButtonTitle: "Done",
                                 rightButtonAction: {
                                    self.presentationMode.wrappedValue.dismiss()
                                    }
                                )
                
                SentPwdResetView()
                
            } else {
                CustomViewHeader(viewTitle: "Forgot Password?",
                                 leftButtonTitle: "Cancel",
                                 leftButtonAction: {
                                    self.presentationMode.wrappedValue.dismiss()
                                    }
                                )
                
                RequestPwdResetView(emailSent: $emailSent)
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordParentView()
            .environmentObject(Portal())
    }
}
