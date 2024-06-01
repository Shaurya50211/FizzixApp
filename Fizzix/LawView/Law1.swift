// Created by Shaurya Gupta

import SwiftUI
import SpriteKit

struct Law1: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var counter = 0
    @State var biggerCard = false
    @State private var moveRight = false
    @State var instructionNum = 0
    @State var pickLawOfMotionView = PickLawOfMotionView()
    @State var instructions: [String] = [
        "Hey! In this interactive simulation you will learn about the first law of motion.",
        "The first law of motion says \"An object at rest remains at rest, or if in motion, remains in motion at a constant velocity unless acted on by a net external force.\" 📖",
        "Let's say that our object at rest is the crate. 📦",
        "Drag the car to the crate to move it. 🚗",
        "👏 Awesome! The crate was at rest 𝘶𝘯𝘵𝘪𝘭 it was acted upon by a net external force (which was the car 🚗). Now you know Newton's 1st law of motion!"
    ]
    @State var rightButtonDisabled = false
    @State var leftButtonDisabled = true
    @State var checkForCompletion = false
    @State var navigationButtonsVisible = true
    init() {
        // Register the first custom font
        if let fontURL = Bundle.main.url(forResource: "RubikDoodleShadow-Regular", withExtension: "ttf"),
           let fontData = try? Data(contentsOf: fontURL) as CFData,
           let provider = CGDataProvider(data: fontData),
           let font = CGFont(provider) {
            
            CTFontManagerRegisterGraphicsFont(font, nil)
            //            print("Custom font 'titleFont' registered successfully.")
        } else {
            print("Failed to register custom font 'titleFont'.")
        }
        
        
        if let anotherFontURL = Bundle.main.url(forResource: "KleeOne-Regular", withExtension: "ttf"),
           let anotherFontData = try? Data(contentsOf: anotherFontURL) as CFData,
           let anotherFontProvider = CGDataProvider(data: anotherFontData),
           let anotherFont = CGFont(anotherFontProvider) {
            
            CTFontManagerRegisterGraphicsFont(anotherFont, nil)
            //            print("Custom font 'anotherFont' registered successfully.")
        } else {
            print("Failed to register custom font 'anotherFont'.")
        }
    }
    var body: some View {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            ZStack {
                Color.white
                    .ignoresSafeArea(.all)
                Image("law1bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)
                    .opacity(0.8)
                VStack(spacing: 30) {
                        Text("Law 1")
                            .foregroundStyle(.black)
                            .font(.custom("RubikDoodleShadow-Regular", size: 65))
                    
                    SpriteView(scene: GameScene1(size: CGSize(width: 500, height: 400), law1View: self))
                        .frame(width: 500, height: 400)
                        .edgesIgnoringSafeArea(.all)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .overlay {
                            Image(systemName: "hand.tap")
                                .shadow(radius: 10)
                                .font(.custom("", size: 50))
                                .foregroundStyle(.yellow)
                                .padding(.trailing, moveRight ? 290 : 0)
                                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: moveRight)
                                .onAppear {
                                    withAnimation {
                                        self.moveRight.toggle()
                                    }
                                }
        
                                .opacity(checkForCompletion ? 1 : 0)
                            
                        }
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.black.opacity(0.4))
                        .frame(width: 500, height: self.biggerCard ? 190 : 100)
                        .animation(.bouncy, value: biggerCard)
                        .confettiCannon(counter: $counter, num: 25, radius: 500)
                        .overlay {
                            Text(instructions[instructionNum])
                                .foregroundColor(.white)
                                .font(.custom("KleeOne-Regular", size: 23))
                                .padding(.horizontal, 10)
                                .padding(7)
                                .padding(.bottom, biggerCard ? 30 : 10)
                                .padding(.bottom, instructionNum == 3 ? 30 : 0)
                            
                            Button {
                                if instructionNum == 0 {
                                    leftButtonDisabled = true
                                } else {
                                    leftButtonDisabled = false
                                    instructionNum -= 1
                                }
                                
                                if instructionNum == 1 || instructionNum == 4 {
                                    biggerCard = true
                                } else {
                                    biggerCard = false
                                }
                                
                            } label: {
                                Image(systemName: "arrow.backward.circle")
                                    .font(.custom("KleeOne-Regular", size: 25))
                                    .foregroundStyle(checkForCompletion || leftButtonDisabled ? .yellow.opacity(0.5) : .yellow)
                            }
                            .padding(.leading, 350)
                            .padding(.top, biggerCard ? 140 : 40)
                            .disabled(checkForCompletion)
                            .opacity(navigationButtonsVisible ? 1 : 0)
                            .disabled(!navigationButtonsVisible)
                            .disabled(leftButtonDisabled)
                            
                            Button{
                                if instructionNum == 2 {
                                    checkForCompletion = true
                                }
                                
                                if instructionNum == 4 {
                                    instructionNum = 0
                                } else {
                                    leftButtonDisabled = false
                                    instructionNum += 1
                                }
                                
                                if instructionNum == 1 || instructionNum == 4 {
                                    biggerCard = true
                                } else {
                                    biggerCard = false
                                }
                            } label: {
                                Image(systemName: "arrow.forward.circle")
                                    .font(.custom("KleeOne-Regular", size: 25))
                                    .foregroundStyle(rightButtonDisabled || checkForCompletion ? .yellow.opacity(0.5) : .yellow)
                            }
                            .onChange(of: instructionNum, { oldValue, newValue in
                                
                                if instructionNum != 3 && newValue == oldValue + 1 {
                                    rightButtonDisabled.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                        rightButtonDisabled.toggle()
                                    }
                                }
                                
                            })
                            .disabled(rightButtonDisabled || checkForCompletion)
                            .padding(.leading, 440)
                            .padding(.top, biggerCard ? 140 : 40)
                            .opacity(navigationButtonsVisible ? 1 : 0)
                            .disabled(!navigationButtonsVisible)
                            
                            
                            Button {
                                presentationMode.wrappedValue.dismiss()
                                    pickLawOfMotionView.currentIndex = 1
                            } label: {
                                Text("Keep Learning 📚")
                                    .font(.custom("KleeOne-Regular", size: 17))
                            }
                            .frame(width: 200)
                            .buttonStyle(.borderedProminent)
                            .opacity(!navigationButtonsVisible ? 1 : 0)
                            .disabled(navigationButtonsVisible)
                            .padding(.top, 120)
                            .padding(.leading, 318)
                            
                        }
                }
            }
            
            
            
            
        case .phone:
            ZStack {
                Color.white
                    .ignoresSafeArea(.all)
                Image("law1bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)
                    .opacity(0.8)
                VStack(spacing: 30) {
                        Text("Law 1")
                            .foregroundStyle(.black)
                            .font(.custom("RubikDoodleShadow-Regular", size: 50))
                    
                    SpriteView(scene: GameScene1(size: CGSize(width: 350, height: 320), law1View: self))
                        .frame(width: 350, height: 320)
                        .edgesIgnoringSafeArea(.all)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .overlay {
                            Image(systemName: "hand.tap")
                                .shadow(radius: 10)
                                .font(.custom("", size: 50))
                                .foregroundStyle(.yellow)
                                .padding(.leading, 50)
                                .padding(.trailing, moveRight ? 200 : 0)
                                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: moveRight)
                                .onAppear {
                                    withAnimation {
                                        self.moveRight.toggle()
                                    }
                                }
                                .opacity(checkForCompletion ? 1 : 0)
                            
                        }
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.black.opacity(0.4))
                        .frame(width: 350, height: self.biggerCard ? 300 : 200)
                        .animation(.bouncy, value: biggerCard)
                        .confettiCannon(counter: $counter, num: 25, radius: 500)
                        .overlay {
                            Text(instructions[instructionNum])
                                .frame(width: 300)
                                .foregroundColor(.white)
                                .font(.custom("KleeOne-Regular", size: 23))
                                .padding(.horizontal, 10)
                                .padding(7)
                                .padding(.bottom, biggerCard ? 30 : 10)
                                .padding(.bottom, instructionNum == 3 ? 30 : 0)
                            
                            Button {
                                if instructionNum == 0 {
                                    leftButtonDisabled = true
                                } else {
                                    leftButtonDisabled = false
                                    instructionNum -= 1
                                }
                                
                                if instructionNum == 1 || instructionNum == 4 {
                                    biggerCard = true
                                } else {
                                    biggerCard = false
                                }
                                
                            } label: {
                                Image(systemName: "arrow.backward.circle")
                                    .font(.custom("KleeOne-Regular", size: 25))
                                    .foregroundStyle(checkForCompletion || leftButtonDisabled ? .yellow.opacity(0.5) : .yellow)
                            }
                            .padding(.leading, 200)
                            .padding(.top, biggerCard ? 240 : 150)
                            .disabled(checkForCompletion)
                            .opacity(navigationButtonsVisible ? 1 : 0)
                            .disabled(!navigationButtonsVisible)
                            .disabled(leftButtonDisabled)
                            
                            Button{
                                if instructionNum == 2 {
                                    checkForCompletion = true
                                }
                                
                                if instructionNum == 4 {
                                    instructionNum = 0
                                } else {
                                    leftButtonDisabled = false
                                    instructionNum += 1
                                }
                                
                                if instructionNum == 1 || instructionNum == 4 {
                                    biggerCard = true
                                } else {
                                    biggerCard = false
                                }
                            } label: {
                                Image(systemName: "arrow.forward.circle")
                                    .font(.custom("KleeOne-Regular", size: 25))
                                    .foregroundStyle(rightButtonDisabled || checkForCompletion ? .yellow.opacity(0.5) : .yellow)
                            }
                            .onChange(of: instructionNum, { oldValue, newValue in
                                
                                if instructionNum != 3 && newValue == oldValue + 1 {
                                    rightButtonDisabled.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                        rightButtonDisabled.toggle()
                                    }
                                }
                                
                            })
                            .disabled(rightButtonDisabled || checkForCompletion)
                            .padding(.leading, 300)
                            .padding(.top, biggerCard ? 240 : 150)
                            .opacity(navigationButtonsVisible ? 1 : 0)
                            .disabled(!navigationButtonsVisible)
                            
                            
                            Button {
                                presentationMode.wrappedValue.dismiss()
                                    pickLawOfMotionView.currentIndex = 1
                            } label: {
                                Text("Keep Learning 📚")
                                    .font(.custom("KleeOne-Regular", size: 17))
                            }
                            .frame(width: 200)
                            .buttonStyle(.borderedProminent)
                            .opacity(!navigationButtonsVisible ? 1 : 0)
                            .disabled(navigationButtonsVisible)
                            .padding(.top, 200)
                            .padding(.leading, 100)
                            
                        }
                }
                .padding(.trailing, biggerCard ? 30 : 0)
            }

            
        default:
            VStack {
                Image(systemName: "xmark.circle")
                Text("Device Not Supported")
                    .foregroundStyle(.red)
            }
        }
    }
}
#Preview {
    Law1()
}
