//
//  ActorListView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/12/20.
//

import SwiftUI

// Struct representing the elements in an ActorCell object
struct ActorCellElements: Hashable, Equatable {
    var id: Int
    var name: String
    var image: Image?
    var roles: [String]
    var color: Color
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

//**********************************************************************
// MARK: - ACTOR LIST VIEW
//**********************************************************************
struct ActorListView: View {
    var otherCast: [Cast] = []
    var myCast: [Cast] = []
    
    var body: some View {
        ScrollView {
            ActorCellCollectionView(cells: getCellSet())
        }
    }
    
    // Returns an Array of ActorCells for display in the ActorList
    func getCellSet() -> [ActorCell] {
        var cells = [ActorCell]()
        for element in getActorSet() {
            cells.append(ActorCell(elements: element))
        }
        
        return cells
    }
    
    /* Returns an Array of ActorCellElements used to set the elements of a collection of ActorCell objects. This method uses the following logic:
     * Combines the actors in myCast with the actors in the rest of the cast (otherCast), which are sorted by first names
     * If an actor does not exist in the ActorCellElements, then it creates the elements for that actor's ActorCell
     * If an actor does exist in the ActorCellElements... if the character name for the given casting item already exists in the elements, no further action is taken, but if the character name does not exist, the current Elements struct is replaced by a new Elements struct which addes the new role into the array of roles for this actor
     * Returns the list of ActorCellElements
 */
    func getActorSet() -> [ActorCellElements] {
        var actors = [ActorCellElements]()
        
        var allCast = [Cast]()
        allCast.append(contentsOf: myCast)
        allCast.append(contentsOf: otherCast.sorted(by: {(a, b) in
            return a.student.person.firstName < b.student.person.firstName
        }))
        
        for cast in allCast {
            if !actors.contains(where: { elements in
                return elements.id == cast.student.id
            }) {
                let student = cast.student
                actors.append(ActorCellElements(
                                    id: student.id,
                                    name: getFullNameFor(student),
                                    image: getImageFor(student),
                                    roles: [cast.character.name],
                    color: myCast.contains(cast) ? student.profileColor : Color(hex: "E8E8E8")
                            )
                )
            } else {
                let actor = actors.first(where: { actor in
                    return actor.id == cast.student.id
                })
                
                if !actor!.roles.contains(cast.character.name) {
                
                    var roles = [String]()
                    roles.append(contentsOf: actor!.roles)
                    roles.append(cast.character.name)
                    
                    let newElements = ActorCellElements(
                        id: actor!.id,
                        name: actor!.name,
                        image: actor!.image,
                        roles: roles,
                        color: actor!.color)
                    
                    let index = actors.firstIndex(of: actor!)
                    actors.replaceSubrange(index!...index!, with: [newElements])
                }
            }
        }
                
        return actors
    }
    
    // Returns the full name of the student
    func getFullNameFor(_ student: Student) -> String {
        return student.person.firstName + " " + student.person.lastName
    }
    
    // Returns the image for the student
    func getImageFor(_ student: Student) -> Image? {
        // FIXME: To be implemented in future development
        return nil
    }
}

//**********************************************************************
// MARK: - ActorCellCollectionView
//**********************************************************************
// FIXME: Currently numCols is hardcoded. Find a way to calculate in future iteration.
struct ActorCellCollectionView: View {
    var cells: [ActorCell]
    var numCols: Int = 3
    
    var body: some View {
        VStack {
            ForEach((0...getNumRows()), id: \.self) { i in
                HStack {
                    ForEach(getViewsForRow(i), id:\.self) { cell in
                        cell
                    }
                }
            }
        }
    }
    
    func getNumRows() -> Int {
        return cells.count / numCols
    }
    
    func getViewsForRow(_ rowNum: Int) -> [ActorCell] {
        var views = [ActorCell]()
        let start = rowNum * numCols
        for index in start...(start + 2) {
            if index < cells.count {
                views.append(cells[index])
            }
        }
        
        return views
    }
}

//**********************************************************************
// MARK: - ACTOR CELL
//**********************************************************************
struct ActorCell: View, Hashable {
    var elements: ActorCellElements
    
    var body: some View {
        VStack {
            Text(elements.name)
                .foregroundColor(getTextColorWithBackgroundColor(elements.color))
                .font(.body).fontWeight(.bold)
                .minimumScaleFactor(0.5)
                .frame(height: 50)
                .multilineTextAlignment(.center)
            
            if elements.image != nil {
                // TODO: Insert image on future iteration
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(Color.gray)
                        .frame(width: 75, height: 100)
                    
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 50, height: 60)
                }
            }
            
            VStack (spacing: 4){
                ForEach(elements.roles, id:\.self) { role in
                    Text(role)
                        .foregroundColor(getTextColorWithBackgroundColor(elements.color))
                        .font(.callout).fontWeight(.semibold)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                    
                    if elements.roles.last != role {
                        Divider()
                            .padding(.horizontal, 4)
                    }
                }
            }
            .frame(height: 75)
            .frame(maxWidth: 135)
            
            Spacer(minLength: 1)
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 5.0)
                        .fill(elements.color))
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(elements.id)
    }
}

func getTextColorWithBackgroundColor(_ color: Color) -> Color {
    let brightness = color.getBrightness()
    return brightness > 0.75 ? Color.black : Color.white
}

struct ActorViewList_Previews: PreviewProvider {
    static var previews: some View {
        ActorListView(otherCast: [], myCast: [])
            .environmentObject(Portal())
    }
}
