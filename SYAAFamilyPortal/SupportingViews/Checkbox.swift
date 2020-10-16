//
//  Checkbox.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/14/20.
//

import SwiftUI

struct Checkbox: View {
    var isChecked:Bool
    var height: CGFloat = 30
    var activeColor: Color = Color.black
    var inactiveColor: Color = Color.darkGray
    
    var action: () -> Void = {}
        
    var body: some View {
        HStack{
            Image(systemName: isChecked ? "checkmark.circle": "circle")
                .resizable()
                .frame(width: height, height: height)
                .foregroundColor(isChecked ? activeColor : inactiveColor)
        }
    }
}

struct Checkbox_Previews: PreviewProvider {
    static var previews: some View {
        Checkbox(isChecked: true, action: {})
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
