//
//  AddGoalView.swift
//  MoodJournal
//
//  Created by Brenda Pham on 12/1/24.
//

import SwiftUI


struct AddGoalView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var goalVM: GoalViewModel
    
    @State private var textFieldText: String = ""
    @State private var showAlert: Bool = false
    
    
    var body: some View {
        VStack (spacing: 20) {
            Button(action: {
                dismiss()
            } ) {
                Image(systemName: "x.circle.fill")
                    .foregroundStyle(Color.secondary.opacity(0.5))
                    .font(.system(size: 36))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
            }.padding(.bottom, -50)
                .padding(.top, 30)
            Text("New Goal")
                .font(.system(size: 36))
                .fontWidth(.expanded)
                .fontWeight(.heavy)
                .foregroundStyle(Color("Brown"))
                .padding(.top, 40)
            TextField("new goal here...", text: $textFieldText)
                .font(.headline)
                .padding(.leading)
                .frame(height: 55)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal)
            Button(action: {
                showAlert = textFieldText.isEmpty
                // Add goal if text field is filled
                if !textFieldText.isEmpty {
                    goalVM.addGoal(isCompleted: false, title: textFieldText)
                    textFieldText = ""
                    dismiss()
                }
            }) {
                Text("add goal")
            }.foregroundColor(.white)
                .fontWeight(.bold)
                .background(Color("Brown")
                    .frame(width: 100)
                    .frame(height: 40)
                    .cornerRadius(20))
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Cannot Add Goal"), message: Text("Please enter text."), dismissButton: .cancel())
            }
            Spacer()
        }.background(AngularGradient(colors: [Color("Pink3"), Color("Pink2"), Color("Pink1")], center: .topTrailing)
            .frame(width: 500, height: 1000))
    }
}

#Preview {
    AddGoalView()
}
