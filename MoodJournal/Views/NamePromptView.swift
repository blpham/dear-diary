//
//  NamePromptView.swift
//  MoodJournal
//
//  Created by Brenda Pham on 12/14/24.
//

import SwiftUI


struct NamePromptView: View {
    @Binding var userName: String
    @Environment(\.dismiss) var dismiss

    @State private var tempName: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome!")
                .foregroundStyle(Color("Tan"))
                .font(.system(size: 36))
                .fontWidth(.expanded)
                .fontWeight(.heavy)
            Text("What's your name?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Color("Tan"))

            TextField("Enter your name", text: $tempName)
                .font(.headline)
                .padding(.leading)
                .frame(height: 55)
                .background(Color("Pink3"))
                .cornerRadius(10)
                .padding(.horizontal)

            Button("Save") {
                saveName()
                dismiss()
            }
            .padding()
            .foregroundColor(Color("Brown"))
                .fontWeight(.bold)
                .background(Color("Pink2")
                    .frame(width: 100)
                    .frame(height: 50)
                    .cornerRadius(30))
        }.background(Color("Brown")
            .frame(width: 500, height: 1000))
        .padding()
    }

    private func saveName() {
        userName = tempName
        UserDefaults.standard.set(tempName, forKey: userNameKey)
    }
}

#Preview {
    @State var name = "Brenda"
    return NamePromptView(userName: $name)
}
