import SwiftUI
import AVFoundation
import AVKit

struct HowToPlayView: View {
    @Environment(\.dismiss) var dismiss
    
    //Sound
    let CancelSound = CancelSoundClass()
    
    //PageMoveButton
    @State private var isAnimating: Bool = false
    var buttonWidth: CGFloat
    var numberOfOuterCircles: Int
    var animationDuration: Double
    var circleArray = [CircleData]()
    
    init(buttonWidth: CGFloat = 60, numberOfOuterCircles: Int = 2, animationDuration: Double = 1) {
        self.buttonWidth = buttonWidth
        self.numberOfOuterCircles = numberOfOuterCircles
        self.animationDuration = animationDuration
        
        var circleWidth = self.buttonWidth
        var opacity = (numberOfOuterCircles > 4) ? 0.40 : 0.20
        
        for _ in 0..<numberOfOuterCircles{
            circleWidth += 30
            self.circleArray.append(CircleData(width: circleWidth, opacity: opacity))
            opacity -= 0.05
        }
    }
    
    //HowToPlayTab
    @State var BookTitleList: [String] = ["What is This game?", "How to play", "Other Settings", "Trial game"]
    @State var OpenPage: Int = 1
    
    var body: some View {
        ZStack{
            Image("Tatami2").resizable()
            VStack{
                VStack{
                    Text("How to play 🎮").font(Font.custom("ChalkboardSE-Bold", size: 40)).fontWeight(.black).foregroundColor(Color.white)
                }.frame(maxWidth: .infinity, maxHeight: 70).background(Color.red.opacity(0.9))
                Spacer()
                //Playing Book
                VStack(spacing: 0){
                    HStack{
                        ForEach(0..<BookTitleList.count, id: \.self) { index in
                            VStack {
                                Text(BookTitleList[index])
                                    .font(Font.custom("ChalkboardSE-Bold", size: OpenPage == index + 1 ? 25 : 13))
                                    .foregroundColor(Color.white)
                            }
                            .frame(width: OpenPage == index + 1 ? 150 : 125, height: OpenPage == 0 ? 50 : 90)
                            .background(OpenPage == index + 1 ? Color.blue : Color.gray)
                            .clipShape(.rect(topLeadingRadius: 20, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 20))
                        }
                    }
                    VStack{
                        Spacer()
                        if OpenPage == 1{
                            Page1()
                        } else if OpenPage == 2{
                            Page2()
                        } else if OpenPage == 3{
                            Page3()
                        } else if OpenPage == 4{
                            Page4()
                        }
                        Spacer()
                        HStack{
                            ZStack {
                                Group {
                                    ForEach(circleArray, id: \.self) { cirlce in
                                        Circle()
                                            .fill(Color.red)
                                            .opacity(self.isAnimating ? cirlce.opacity : 0)
                                            .frame(width: cirlce.width, height: cirlce.width, alignment: .center)
                                            .scaleEffect(self.isAnimating && OpenPage != 1 ? 1 : 0)
                                    }
                                    .animation(Animation.easeInOut(duration: animationDuration).repeatForever(autoreverses: true),
                                               value: self.isAnimating)
                                }
                                Button(action: {  
                                    if OpenPage != 1{
                                        OpenPage -= 1
                                    }
                                }){
                                    Image(systemName: "arrowshape.left.fill").frame(width: self.buttonWidth, height: self.buttonWidth, alignment: .center).background(OpenPage == 1 ? Color.gray : Color.red).foregroundColor(Color.white).cornerRadius(50)
                                }.padding()
                            }
                            Spacer()
                            ZStack {
                                Group {
                                    ForEach(circleArray, id: \.self) { cirlce in
                                        Circle()
                                            .fill(Color.red)
                                            .opacity(self.isAnimating ? cirlce.opacity : 0)
                                            .frame(width: cirlce.width, height: cirlce.width, alignment: .center)
                                            .scaleEffect(self.isAnimating && OpenPage != 4 ? 1 : 0)
                                    }
                                    .animation(Animation.easeInOut(duration: animationDuration).repeatForever(autoreverses: true),
                                               value: self.isAnimating)
                                }
                                Button(action: {
                                    if OpenPage != 4{
                                        OpenPage += 1
                                    }
                                }){
                                    Image(systemName: "arrowshape.right.fill").frame(width: self.buttonWidth, height: self.buttonWidth, alignment: .center).background(OpenPage == 4 ? Color.gray : Color.red).foregroundColor(Color.white).cornerRadius(50)
                                }.padding()
                            }
                        }
                        .onAppear{
                            self.isAnimating.toggle()
                        }
                    }.frame(width: 550, height: 650).background(Color.brown).clipShape(.rect(topLeadingRadius: 0,bottomLeadingRadius: 20,bottomTrailingRadius: 20,topTrailingRadius: 0))
                }
                Spacer()
                Text("Credit title").font(Font.custom("ChalkboardSE-Bold", size: 20)).foregroundColor(Color.black)
                Text("Source of BGM・Sound・Image").foregroundColor(Color.black)
                Text("BGM : DOVA-SYNDROME").foregroundColor(Color.black)
                Text("Sound : OtoLogic").foregroundColor(Color.black)
                Text("Sound : 効果音ラボ").foregroundColor(Color.black)
                Text("Image : いらすとや").foregroundColor(Color.black)
                Button(action: {
                    CancelSound.play()
                    dismiss()
                }){
                    Image(systemName: "house").frame(width: 60, height: 60).background(Color.red).foregroundColor(Color.white).cornerRadius(50)
                }.padding()
            }
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HowToPlayView()
}

//What is This game?
struct Page1: View{
    var body: some View{
        VStack{
            Text("Daruma-san ga Koronda is a traditional Japanese children's game")
            Image("Japan").resizable().scaledToFit().frame(width: 80, height: 80)
            Text("The oni says \"Daruma-san ga koronda\" (Daruma-san fell down)\n and then turns to look at the child.")
            Text("The children can move only when the oni is not facing them.")
            Text("If a child moves while the oni is facing them,that child is out.")
            Text("This continues until a child touches the oni.")
        }.font(Font.custom("ChalkboardSE-Bold", size: 18)).foregroundColor(Color.black)
    }
}

//How to play
struct Page2: View{
    var body: some View{
        VStack{
            Text("While Daruma-san is facing away from you,\npress the up-arrow button to approach Daruma-san.")
            Text("When you get to the end,touch Daruma-san to win.")
            Text("Daruma-san turns around within 0.5 to 5 seconds.")
            HStack{
                VStack{
                    Text("Facing forward")
                    Image("DarumaFacingForward").resizable().scaledToFit().frame(width: 180, height: 180)
                }
                VStack{
                    Text("Facing backward")
                    Image("DarumaFacingBackward").resizable().scaledToFit().frame(width: 180, height: 180)
                }
                VStack{
                    Text("Up-Arrow Button")
                    Image("UpArrowButton").resizable().scaledToFit().frame(width: 180, height: 180)
                }
            }.padding()
        }.font(Font.custom("ChalkboardSE-Bold", size: 18)).foregroundColor(Color.black)
    }
}

//Other Settings
struct Page3: View{
    @State private var selectionValue: Int = 0
    
    var body: some View{
        VStack{
            Text("Rules can be changed to set a Time limit and a \nBuffer when facing Daruma. ").font(Font.custom("ChalkboardSE-Bold", size: 18)).foregroundColor(Color.black)
            Image("Rule Settings").resizable().scaledToFit().frame(width: 400, height: 100)
            Picker("", selection: $selectionValue) {
                Text("Buffer").tag(0)
                Text("Time limit").tag(1)
                Text("Ranking").tag(2)
            }.pickerStyle(SegmentedPickerStyle())
            Spacer()
            if selectionValue == 0{
                HStack{
                    VStack{
                        Image(systemName: "stopwatch").resizable().scaledToFit().frame(width: 60, height: 60)
                        Text("What is Buffer?").padding()
                        Text("The time buffer it the amount of time you and Daruma can face each other with no punishment.")
                        Text("Even if you move during the buffer, you are safe.")
                    }
                    .font(Font.custom("ChalkboardSE-Bold", size: 14)).foregroundColor(Color.black)
                    .frame(width: 420, height: 200).background(Color.white).shadow(radius: 10).cornerRadius(20)
                }
            } else if selectionValue == 1{
                HStack{
                    VStack{
                        Image(systemName: "timer").resizable().scaledToFit().frame(width: 60, height: 60)
                        Text("What is Time limit?").padding()
                        Text("The time limit can be set from 10 to 30 secands. This is the total game time.")
                    }
                    .font(Font.custom("ChalkboardSE-Bold", size: 14)).foregroundColor(Color.black)
                    .frame(width: 420, height: 200).background(Color.white).shadow(radius: 10).cornerRadius(20)
                }
            } else {
                HStack{
                    VStack{
                        Image(systemName: "trophy").resizable().scaledToFit().frame(width: 60, height: 60)
                        Text("What is Ranking?").padding()
                        Text("You can save \"Ranking\" that are cleared within the time limit.")
                    }
                    .font(Font.custom("ChalkboardSE-Bold", size: 14)).foregroundColor(Color.black)
                    .frame(width: 420, height: 200).background(Color.white).shadow(radius: 10).cornerRadius(20)
                }
            }
        }.font(Font.custom("ChalkboardSE-Bold", size: 18)).foregroundColor(Color.black)
    }
}

//Trial game
struct Page4: View{
    @State var DarumaPlace: CGPoint = CGPoint(x: 0, y: 180)
    @State var HumanPlace: CGPoint = CGPoint(x: 0, y: 200)
    
    var body: some View{
        GeometryReader { geometry in
            ZStack{
                VStack{
                    Image("Daruma").resizable().scaledToFit().frame(width: 100, height: 100).position(DarumaPlace).rotationEffect(.degrees(180))
                    Spacer()
                    Image("Human").resizable().scaledToFit().frame(width: 80, height: 80).position(HumanPlace)
                }
                VStack{
                    Spacer()
                    Button(action: {
                        if -DarumaPlace.y + 100 >= HumanPlace.y {
                            HumanPlace.x = geometry.size.width / 2
                            HumanPlace.y = geometry.size.height - 400
                        }
                        HumanPlace.y -= 15
                    }){
                        Image(systemName: "arrowshape.up.fill").frame(width: 60, height: 60, alignment: .center).background(Color.red).foregroundColor(Color.white).cornerRadius(50)
                    }
                    Text("You can advance your speed by repeatedly pressing the up arrow button.").font(Font.custom("ChalkboardSE-Bold", size: 15)).foregroundColor(Color.black)
                }
            }
            .onAppear{
                HumanPlace.x = geometry.size.width / 2
                HumanPlace.y = geometry.size.height - 400
                DarumaPlace.x = geometry.size.width / 2
            }
        }
    }
}

class CancelSoundClass {
    private var cancelSound: AVAudioPlayer!
    
    init() {
        guard let soundURL = Bundle.main.url(forResource: "SE-Cancel", withExtension: "mp3") else {
            fatalError("Noting Sound")
        }
        cancelSound = try! AVAudioPlayer(contentsOf: soundURL)
        cancelSound.prepareToPlay()
    }
    
    func play() {
        cancelSound.play()
    }
}
