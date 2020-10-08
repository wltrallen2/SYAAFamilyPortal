//
//  ViewExtensions.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/8/20.
//

import SwiftUI

extension View {
    func portalFieldStyle() -> some View {
        self.modifier(PortalFieldStyle())
    }
    
}

extension Text {
    func portalLabelStyle() -> some View {
        self.bold()
            .modifier(PortalLabelStyle())
    }
    
    func portalLabelStyle(opacity: Double) -> some View {
        self.bold()
            .modifier(PortalLabelStyle(opacity: opacity))
    }
}

struct PortalFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .padding(8.5)
            .background(
                RoundedRectangle(cornerRadius: 5.0)
                    .stroke(Color.gray)
                    .background(
                        RoundedRectangle(cornerRadius: 5.0)
                            .fill(Color.white)
                    )
            )
    }
}

struct PortalLabelStyle: ViewModifier {
    var opacity: Double = 1.0
    
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .opacity(opacity)
    }
}

struct ViewExtensions_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
        }
    }
}
