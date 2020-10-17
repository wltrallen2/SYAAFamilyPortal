//
//  CustomText.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 9/20/20.
//  Copyright © 2020 Forty Something Nerd. All rights reserved.
//

import SwiftUI

enum TextType {
    case Italic
    case Bold
}

struct CustomText: View {
    var text: String
    var textType: TextType
    
    var body: some View {
        VStack {
            if textType == .Bold {
                Text(text)
                    .bold()
                    .padding(8)
                    .font(.system(size: 16))
            } else if textType == .Italic {
                Text(text)
                    .italic()
                    .padding(8)
                    .font(.system(size: 16))
            }
        }
    }
}

struct CustomText_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomText(text: "Here's a message", textType: .Bold)
                .previewLayout(.sizeThatFits)
            
            CustomText(text: "Here's a message", textType: .Italic)
                .previewLayout(.sizeThatFits)
        }
    }
}
