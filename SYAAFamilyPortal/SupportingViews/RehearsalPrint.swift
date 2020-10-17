//
//  RehearsalPrint.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/16/20.
//

import Foundation

class RehearsalPrint {
    var html: String = ""
    
    required init(forStudents students: [Student], andRehearsals rehearsals: [Rehearsal], usingPortal portal: Portal) {
        var studentNames: String = ""
        var studentTabs: [String] = []
        for student in students {
            if students.count > 1 && student == students.last {
                studentNames += "and "
            }
            
            studentNames += student.person.firstName
            
            if student != students.last && students.count > 2 {
                studentNames += ", "
            }
            
            studentTabs.append(getStudentTabForStudent(student, withConflictType: .Conflict))
        }
        
        html += """
<html>
    <head>
        <title>Rehearsal Schedule: \(studentNames)</title>
    </head>
    <body style="margin:0;padding:0;style="transform: scale(0.7);">
        <header style="background-color: #BCBCBC; padding: 16px">
            <h3 style="margin:0;padding:0;">Strauss Youth Academy for the Arts</h3>
            <h1 style="margin:0;padding:0;">Rehearsal Schedule</h1>
            <h3 style="margin:0;padding:0;">for \(studentNames)</h3>
            <h5 style="margin:16px 0 0;padding:0;">&bull; Printed on DATE &bull;</h5>
        </header>

        <main style="padding: 16px">
            <p style="margin:8px 0 8px;padding:0;color: red;"><em><strong>Please remember that rehearsal schedules are subject to change and you should check the Facebook group and/or the SYAA Family Portal often.</strong></em></p>
            <hr/>
"""
        
        for rehearsal in rehearsals {
            let myStudents = portal.getMyStudentsForRehearsal(rehearsal)
            html += getRehearsalHTMLForRehearsal(rehearsal, withStudents: myStudents, usingPortal: portal)
        }
        
        html += """
        </main>
    </body>
</html>
"""
    }
    
    func getRehearsalHTMLForRehearsal(_ rehearsal: Rehearsal, withStudents students: [Student], usingPortal portal: Portal) -> String {
        let production = portal.getProductionForRehearsal(rehearsal)
        let timeString = rehearsal.start.toStringWithFormat("h:m a") + "&ndash;"
            + rehearsal.end.toStringWithFormat("h:m a")
        
        let topHalf = """
            <div style="font-family: sans-serif; page-break-inside: avoid;">
                <p style="font-size: 0.6em;font-weight: bold;margin: 4px 0;">\(production!.title)</p>
                <div style="display: flex; flex-direction: horizontal;">
"""
                
        var studentTabs = ""
        for student in students {
            let conflictType = portal.getConflictForStudent(student, atRehearsal: rehearsal)
            studentTabs += getStudentTabForStudent(student, withConflictType: conflictType)
        }
        
        let bottomHalf = """
                </div>
                <h3 style="margin:8px 0 0;padding:0;">\(rehearsal.start.toStringWithFormat("EEEE, MMMM d, y"))</h3>
                <h4 style="margin:2px 0;font-weight: normal;">\(timeString)</h4>
                <p style="margin:-2px 0 8px; padding-bottom: 8px;font-size: 0.9em;font-weight:lighter;border-bottom: 1px solid #cdcdcd">\(rehearsal.description)</p>
            </div>
"""
        
        return topHalf + studentTabs + bottomHalf
    }
    
    func getStudentTabForStudent(_ student: Student, withConflictType type: ConflictType?) -> String {
        let name = student.person.firstName
        let hexColor = student.profileColor.hexValue(withHash: true)
        let textColor = student.profileColor.getBrightness() > 0.7 ? "#000000" : "#FFFFFF"
        
        var dot = ""
        switch type {
        case .Conflict:
            dot = """
                        <div style="background-color: #FFFFFF;border-radius: 25px;width: 12px; height: 12px; margin-right: 18px;box-shadow: 1px 1px 4px black;">
                        </div>
"""
            break;
        case .ArriveLate:
            dot = """
                        <div style="position:relative; width: 12px; height: 12px;margin-right: 18px">
                            <div style="background-color: #FFFFFF; border-radius: 25px 25px 0 0;width: 12px; height: 6px; margin-right: 18px;box-shadow: -1px 1px 4px black;position: absolute; z-index: 1;transform: rotate(90deg);top: 3px;left: 3px;">
                            </div>
                            <div style="background-color: #rgba(0, 0, 0, 0); border: solid 1px #FFFFFF; border-radius: 25px; width: 10px; height: 10px; margin-right: 18px;box-shadow: 1px 1px 4px black;position: absolute; z-index: 2;">
                            </div>
                        </div>
"""
            break;
        case .LeaveEarly:
            dot = """
                        <div style="position:relative; width: 12px; height: 12px;margin-right: 18px">
                            <div style="background-color: #FFFFFF; border-radius: 25px 25px 0 0;width: 12px; height: 6px; margin-right: 18px;box-shadow: -1px 1px 4px black;position: absolute; z-index: 1;transform: rotate(-90deg);top: 3px;left: -3px;">
                            </div>
                            <div style="background-color: #rgba(0, 0, 0, 0); border: solid 1px #FFFFFF; border-radius: 25px; width: 10px; height: 10px; margin-right: 18px;box-shadow: 1px 1px 4px black;position: absolute; z-index: 2;">
                            </div>
                        </div>
"""
            break;
        default:
            dot = ""
        }
        
        return """
                    <div style="background-color: \(hexColor); color: \(textColor);border-radius: 25px; display: flex; flex-direction: horizontal;align-items: center;margin-right: 8px;box-shadow: 3px 3px 5px black;">
                        <p style="padding: 4px 12px 4px 18px;margin: 0px;text-shadow: 1px 1px 2px black;">\(name)</p>
                        \(dot)
                    </div>
"""
    }
    
}
