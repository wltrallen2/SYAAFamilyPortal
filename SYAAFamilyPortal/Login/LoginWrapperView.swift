//
//  LoginWrapperView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/3/20.
//

import SwiftUI

enum LoginViewType {
    case Verify
    case Create
}

struct LoginWrapperView: View {
    @State var currentView: LoginViewType = .Verify
    
    var body: some View {
        if currentView == .Verify {
            LoginView(currentView: $currentView)
        } else {
            CreateUserView(currentView: $currentView)
        }
    }
}

struct LoginWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        LoginWrapperView()
    }
}
