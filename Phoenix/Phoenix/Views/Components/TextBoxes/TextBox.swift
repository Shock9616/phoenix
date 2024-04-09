//
//  TextBox.swift
//  Phoenix
//
//  Created by James Hughes on 9/23/23.
//

import SwiftUI

struct TextBox: View {
    var textBoxName: String
    var placeholder: String
    @Binding var input: String
    
    var body: some View {
        HStack {
            Text(textBoxName)
                .frame(width: 70, alignment: .leading)
            RoundTextEditor(text: $input)
                .accessibility(label: Text("\(textBoxName) Input"))
        }
        .padding()
    }
}
