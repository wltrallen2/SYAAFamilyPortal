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
    var conflict: ConflictType?
    
    var body: some View {
        HStack (spacing: 0){
            
            Text(name)
                .font(.body)
                .bold()
                .padding(.horizontal, 8)
                .lineLimit(1)
                .frame(minWidth: 80)
                .shadow(color: getShadowColor(forColor: self.color),
                        radius: 3, x: 1.0, y: 1.0)
                .foregroundColor(getForegroundColor(forColor: self.color))
                .padding(.vertical, 4)

            if(conflict != nil) {
                let halfShape =
                    conflict == .ArriveLate ? "lefthalf." :
                    conflict == .LeaveEarly ? "righthalf." :
                    ""
                ZStack {
                    Image(systemName: "circle." + halfShape + "fill")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundColor(.white)
                        .shadow(color: Color.black,
                                radius: 3, x: 1.0, y: 1.0)
                }
                .frame(width: 14, height: 14)
            }
        }
        .padding(.horizontal, 12)
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
        Group {
            StudentTab(name: student.person.firstName,
                       color: student.profileColor)
                .padding()
                .previewLayout(.sizeThatFits)
            
            StudentTab(name: "Sarah Katherine",
                       color: student.profileColor,
                       conflict: .Conflict)
                .padding()
                .previewLayout(.sizeThatFits)

            StudentTab(name: "Anna-Kate",
                       color: student.profileColor,
                       conflict: .LeaveEarly)
                .padding()
                .previewLayout(.sizeThatFits)

            StudentTab(name: student.person.firstName,
                       color: student.profileColor,
                       conflict: .ArriveLate)
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}
