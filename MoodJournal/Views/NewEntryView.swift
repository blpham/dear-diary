//
//  NewEntryView.swift
//  MoodJournal
//
//  Created by Brenda Pham on 11/18/24.
//

import SwiftUI
import RichTextKit


struct NewEntryView: View {
    
    @EnvironmentObject var journalVM: JournalViewModel
    @EnvironmentObject var journalEntryVM: JournalEntryViewModel
    
    @State private var journalText: String = ""
    @State private var selectedDate = Date.now
    @State private var selectedJournal: JournalEntity?
    @StateObject var context = RichTextContext()
    @State var text: NSAttributedString = .empty
    @State private var showAlert: Bool = false
    
    // Image Picker variables
    @State private var isConfirmationDialogPresented: Bool = false
    @State private var isShowingImagePicker: Bool = false
    @State private var imageSourceType: ImageSourceType = .photoLibrary
    @State private var inputImage: UIImage?
    
    // Drawing variables
    @State private var isShowingDrawingCanvas: Bool = false
    @State private var drawingImage: UIImage?
    
    let prompt: String = " Type here..."
    
    var body: some View {
        VStack {
            Spacer()
            Text("New Journal Entry")
                .font(.title)
                .fontWidth(.expanded)
                .fontWeight(.heavy)
                .foregroundStyle(Color("Brown"))
                .padding(.top, 20)
            
            HStack {
                // Journal picker
                Picker("Journal", selection: $selectedJournal) {
                    Text("Select a journal").tag(Optional<JournalEntity>(nil)) // placeholder
                    ForEach(journalVM.savedEntities) { journal in
                        Text(journal.name)
                            .tag(Optional(journal))
                    }
                }.accentColor(.black)
                    .background(Color.secondary
                        .opacity(0.15)
                        .cornerRadius(8))
                // Date picker
                DatePicker(selection: $selectedDate, in: ...Date.now, displayedComponents: .date) {}
            }.padding(.horizontal)
            
            ScrollView {
                VStack {
                    // Text Editor
                    RichTextEditor(
                        text: $text,
                        context: context) {
                            $0.textContentInset = CGSize(width: 20, height: 20)
                        }.focusedValue(\.richTextContext, context)
                        .background(Color.white)
                        .overlay {
                            if text.string.isEmpty {
                                VStack {
                                    HStack {
                                        Text(prompt)
                                            .font(.headline)
                                            .foregroundStyle(Color.secondary)
                                            .padding(20)
                                        Spacer()
                                    }
                                    Spacer()
                                }.allowsHitTesting(false)
                            }
                        }.frame(minHeight: 400)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .shadow(color: .gray, radius: 3, x: 0, y: 0)
                    
                    // Text Editor Toolbar
                    RichTextKeyboardToolbar(
                        context: context,
                        leadingButtons: { $0 },
                        trailingButtons: {_ in
                            // Add Image
                            Button(action: {
                                isConfirmationDialogPresented = true
                            }, label: {
                                Image(systemName: "photo.badge.plus")
                            })
                            // Add Drawing
                            Button(action: {
                                isShowingDrawingCanvas = true
                            }, label: {
                                Image(systemName: "lasso.badge.sparkles")
                            })
                        },
                        formatSheet: { $0 }
                    ).cornerRadius(10)
                        .padding(.horizontal)
                }
                
                // Save Button
                Button(action: {
                    guard let journal = selectedJournal else {
                        showAlert = true
                        print("No journal selected")
                        return
                    }
                    // save journal entry
                    journalEntryVM.addJournalEntry(journal: journal, text: text, context: context, date: selectedDate)
                    // clear text field
                    text = .empty
                    context.stopEditingText()
                    context.resetAttributedString()
                    // navigate to journal entry view with newly created entry
                }) {
                    Text("Save")
                        .font(.title2)
                        .fontWeight(.bold)
                }.foregroundColor(.white)
                    .background(Color("Brown")
                        .frame(width: 100)
                        .frame(height: 55)
                        .cornerRadius(30))
                    .padding()
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Please Select a Journal."), dismissButton: .cancel())
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            Spacer()
        }.background(AngularGradient(colors: [Color("Pink3"), Color("Pink2"), Color("Pink1")], center: .topTrailing)
            .frame(width: 500, height: 1000))
        .confirmationDialog("Select source", isPresented: $isConfirmationDialogPresented, actions: {
            Button("Camera") {
                self.imageSourceType = .camera
                self.isShowingImagePicker = true
            }
            Button("Photo Library") {
                self.imageSourceType = .photoLibrary
                self.isShowingImagePicker = true
            }
        })
        // Image Selector
        .sheet(isPresented: $isShowingImagePicker, onDismiss: {
            if let inputImage = inputImage {
                let cursorLocation = context.selectedRange.location // get cursor location
                let insertion = RichTextInsertion<UIImage>.image(inputImage, at: cursorLocation, moveCursor: true)
                let action = RichTextAction.pasteImage(insertion)
                context.handle(action)
                self.inputImage = nil
            }
        }, content: {
            switch imageSourceType {
            case .camera:
                CameraImagePicker(image: $inputImage, sourceType: .camera)
            case .photoLibrary:
                PhotoLibraryPicker(selectedImage: $inputImage)
            }
        })
        // Drawing sheet
        .sheet(isPresented: $isShowingDrawingCanvas, onDismiss: {
            if let drawingImage = drawingImage {
                let cursorLocation = context.selectedRange.location // Get cursor location
                let insertion = RichTextInsertion<UIImage>.image(drawingImage, at: cursorLocation, moveCursor: true)
                let action = RichTextAction.pasteImage(insertion)
                context.handle(action)
                self.drawingImage = nil
            }
        }, content: {
            DrawingCanvasView(drawingImage: $drawingImage)
        })
    }
}

#Preview {
    NewEntryView()
        .environmentObject(JournalViewModel(container: PersistenceController.shared.container))
        .environmentObject(JournalEntryViewModel(container: PersistenceController.shared.container))
}
