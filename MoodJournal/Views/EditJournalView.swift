//
//  EditJournalView.swift
//  MoodJournal
//
//  Created by Brenda Pham on 12/5/24.
//

import SwiftUI


struct EditJournalView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var journalVM: JournalViewModel
    

    @State private var textFieldText: String = ""
    @State private var selectedColor: Color = Color("Brown")
    @State private var showAlert: Bool = false
    
    var journal: JournalEntity
    
    init(journal: JournalEntity) {
        self.journal = journal
        _textFieldText = State(initialValue: journal.name)
        _selectedColor = State(initialValue: selectedColor)
    }
    
    var body: some View {
        VStack (spacing: 20) {
            
            // Dismiss Button
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
            
            Text("Edit Journal")
                .font(.system(size: 36))
                .fontWidth(.expanded)
                .fontWeight(.heavy)
                .foregroundStyle(Color("Brown"))
                .padding(.top, 40)
            
            VStack {
                Image(systemName: "book.closed.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(selectedColor)
                    .padding(.bottom, 5)
                Text(textFieldText)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("Brown"))
                    .frame(maxWidth: 140)
            }.background(Color("WhiteSmoke")
                .frame(width: 150, height: 150)
                .cornerRadius(20)
                .shadow(color: .gray, radius: 3, x: 0, y: 0))
            .padding(.vertical, 50)
            
            // Journal Name Text Prompt
            TextField("give it a name...", text: $textFieldText)
                .font(.headline)
                .padding(.leading)
                .frame(height: 55)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal)
            
            // Color Picker
            HStack {
                Spacer()
                ColorPicker(selection: $selectedColor, supportsOpacity: false, label: {
                    Text("choose a color!")
                        .font(.title3)
                        .fontWeight(.bold)
                }).padding(.bottom, 50)
                    .frame(width: 190)
            }.padding(.horizontal, 30)
            
            Button(action: {
                showAlert = textFieldText.isEmpty
                // If text field is filled, add new journal
                if !textFieldText.isEmpty {
                    journalVM.updateJournal(entity: journal, newName: textFieldText, newColor: UIColor(from: selectedColor)!)
                    textFieldText = ""
                    dismiss()
                }
            }) {
                Text("Save Changes")
                    .font(.title2)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
            .background(Color("Brown")
                .frame(width: 190)
                .frame(height: 55)
                .cornerRadius(30))
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Cannot Edit Journal"), message: Text("Please enter a name."), dismissButton: .cancel())
            }
            Spacer()
        }.background(AngularGradient(colors: [Color("Pink3"), Color("Pink2"), Color("Pink1")], center: .topTrailing)
            .frame(width: 500, height: 1000))
    }
}

#Preview {
    let journalVM = JournalViewModel(container: PersistenceController.shared.container)
    let journalEntryVM = JournalEntryViewModel(container: PersistenceController.shared.container)
    let mockJournal = JournalEntity(context: journalVM.container.viewContext)
    mockJournal.name = "Mock Journal"
    mockJournal.color = UIColor.purple
    
    return EditJournalView(journal: mockJournal)
        .environmentObject(JournalViewModel(container: PersistenceController.shared.container))
}
