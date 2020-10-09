//
//  AdultTab.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/9/20.
//

import SwiftUI

struct AdultTab: View {
    var name: String
    
    var body: some View {
        HStack {
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .padding(.leading, 16)
                .padding(.trailing, 8)
            
            Text(name)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .resizable()
                .frame(width: 8, height: 15)
                .padding(.trailing, 16)
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
    }
}

struct AdultTab_Previews: PreviewProvider {
    static var previews: some View {
        AdultTab(name: "Adult")
            .previewLayout(.sizeThatFits)
    }
}
