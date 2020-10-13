//
//  StudentTab.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/8/20.
//

import SwiftUI

struct StudentTab: View {
    var name: String
    var color: Color
    
    var body: some View {
        Text(name)
            .font(.title3)
            .bold()
            .shadow(color: getShadowColor(forColor: self.color),
                    radius: 3, x: 1.0, y: 1.0)
            .foregroundColor(getForegroundColor(forColor: self.color))
            .padding(.vertical, 4)
            .padding(.horizontal, 12)
            .frame(minWidth: 150)
            .background(RoundedRectangle(cornerRadius: 25.0)
                            .fill(color)
                            .shadow(color: Color.black,
                                    radius: 3, x: 1.0, y: 1.0)
                        )
    }
    
}

func getForegroundColor(forColor color: Color) -> Color {
    let brightness = color.getBrightness()
    return brightness > 0.75 ? Color.black : Color.white
}

func getShadowColor(forColor color: Color) -> Color {
    let brightness = color.getBrightness()
    return brightness > 0.75 ? Color.white: Color.black
}


struct StudentTab_Previews: PreviewProvider {
    @State static var student: Student = Student.default
    
    static var previews: some View {
        StudentTab(name: student.person.firstName,
                   color: student.profileColor)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}