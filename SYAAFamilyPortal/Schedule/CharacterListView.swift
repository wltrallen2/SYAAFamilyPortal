//
//  CharacterListView.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/12/20.
//

import SwiftUI

struct CharacterListView: View {
    var otherCharacters: [Character]
    var myCharacters: [Character]
        
    var body: some View {
        ScrollView {
            VStack (spacing: 0){
                ForEach(myCharacters, id:\.id) {character in
                    HStack {
                        CharacterTab(character: character, withTint: true)
                    }
                }
                ForEach(otherCharacters, id:\.id) { character in
                    HStack {
                        CharacterTab(character: character)
                    }
                }
            }
        }
    }
}

// TODO: In future iteration, highlight roles with myStudent's profile colors.
struct CharacterTab: View {
    var character: Character
    var withTint: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text(character.name)
                    .font(.title2)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
                        
            Divider()
        }
        .background(withTint ? Color.yellow.opacity(0.3) : Color.white)
    }
}

struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView(otherCharacters: Portal().getCharactersForRehearsal(Production.default.rehearsals[0]), myCharacters: [Production.default.cast[Production.default.rehearsals[0].characterIds[0]].character, Production.default.cast[Production.default.rehearsals[0].characterIds[2]].character])
            .environmentObject(Portal())
    }
}
