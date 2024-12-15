//
//  DrawingCanvasView.swift
//  MoodJournal
//
//  Created by Brenda Pham on 12/5/24.
//

import SwiftUI
import PencilKit


struct CanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
    }
}


struct DrawingCanvasView: View {
    
    @Environment(\.undoManager) private var undoManager
    @Environment(\.dismiss) private var dismiss
    @State private var canvasView = PKCanvasView()
    @State private var toolPicker = PKToolPicker()
    @Binding var drawingImage: UIImage?
    
    var body: some View {
        VStack {
            // Top Toolbar
            HStack {
                // Close Button
                Button(action: {
                    dismiss()
                } ) {
                    Image(systemName: "x.circle.fill")
                        .foregroundStyle(Color.secondary.opacity(0.5))
                        .font(.system(size: 36))
                }
                Spacer()
                
                // Undo/Clear/Redo Buttons
                HStack (spacing: 10) {
                    Button(action: {
                        undoManager?.undo()
                    }, label: {
                        Image(systemName: "arrow.uturn.backward.circle.fill")
                            .font(.title)
                            .foregroundStyle(Color("Pink0"))
                    })
                    // Clear Canvas Button
                    Button(action: {
                        clearCanvas()
                    }, label: {
                        Image(systemName: "trash.fill")
                            .font(.title)
                            .foregroundStyle(Color("Pink0"))
                    })
                    Button(action: {
                        undoManager?.redo()
                    }, label: {
                        Image(systemName: "arrow.uturn.forward.circle.fill")
                            .font(.title)
                            .foregroundStyle(Color("Pink0"))
                    })
                }.padding(.leading, 16)
                Spacer()
                
                // Add Button
                Button(action: {
                    // add drawing
                    drawingImage = captureDrawingAsImage()
                    dismiss()
                }, label: {
                    Text("Add")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("WhiteSmoke"))
                        .background(Color("Brown")
                            .frame(width: 80, height: 40)
                            .cornerRadius(30))
                        .padding(.trailing, 20)
                })
            }.padding(.bottom, -40)
                .padding(.top, 30)
                .padding(.horizontal, 20)
            
            // Drawing Canvas
            CanvasView(canvasView: $canvasView)
                .onAppear {
                    toolPicker.setVisible(true, forFirstResponder: canvasView)
                    toolPicker.addObserver(canvasView)
                    canvasView.becomeFirstResponder()
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding()
                .padding(.top, 30)
        }.background(AngularGradient(colors: [Color("Pink3"), Color("Pink2"), Color("Pink1")], center: .topTrailing)
            .frame(width: 500, height: 1000))
    }
    
    // Save drawing as UIImage
    private func captureDrawingAsImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: canvasView.bounds)
        return renderer.image { context in
            canvasView.drawHierarchy(in: canvasView.bounds, afterScreenUpdates: true)
        }
    }
    
    // Replace canvas with brand new canvas
    func clearCanvas() {
        canvasView.drawing = PKDrawing()
    }
}
