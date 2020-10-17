//
//  CustomViewHeader.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/9/20.
//  Copyright © 2020 Forty Something Nerd. All rights reserved.
//

import SwiftUI

struct CustomViewHeader: View {
    var viewTitle: String?
    var leftButtonTitle: String?
    var leftButtonAction: (() -> Void)?
    var rightButtonTitle: String?
    var rightButtonAction: (() -> Void)?

    
    var body: some View {
        
        ZStack {
            if self.viewTitle != nil {
                HStack {
                    Spacer()
                    Text(self.viewTitle!)
                        .font(.headline)
                    Spacer()
                }
            }
            
            HStack {
                if self.leftButtonTitle != nil
                    && self.leftButtonAction != nil {
                    Button(action: self.leftButtonAction!) {
                        Text(self.leftButtonTitle!)
                    }
                }
                
                Spacer()
                
                if self.rightButtonTitle != nil
                    && self.rightButtonAction != nil {
                    Button(action: self.rightButtonAction!) {
                        Text(self.rightButtonTitle!)
                    }
                }
            }
        }
        .background(Color.white)
        .padding(16)
    }
}

struct CustomViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        CustomViewHeader(viewTitle: "Custom View")
            .previewLayout(.sizeThatFits)
    }
}
