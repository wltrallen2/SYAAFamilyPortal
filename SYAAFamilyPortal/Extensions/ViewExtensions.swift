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
    
    func portalFieldStyle(fillColor: Color) -> some View {
        self.modifier(
            PortalFieldStyle(fillColor: fillColor))
    }
    
    func portalPickerStyle() -> some View {
        self.modifier(PortalPickerStyle())
    }
    
    func portalPickerStyle(height: CGFloat) -> some View {
        self.modifier(PortalPickerStyle(height: height))
    }
}

extension UIView {
    func toImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)

        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

       let image = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()
       return image
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
    var fillColor: Color = Color.white
    
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .padding(8.5)
            .background(
                RoundedRectangle(cornerRadius: 5.0)
                    .stroke(Color.gray)
                    .background(
                        RoundedRectangle(cornerRadius: 5.0)
                            .fill(fillColor)
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

struct PortalPickerStyle: ViewModifier {
    var height: CGFloat = 240.0
    
    func body(content: Content) -> some View {
        content
            .frame(height: height)
            .padding()
            .background(Rectangle()
                            .fill(Color.white)
                            .shadow(color: Color.gray, radius: 10.0)
                        )
    }
}

struct ViewExtensions_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
        }
    }
}
