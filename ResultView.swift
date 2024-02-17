import SwiftUI
import AVFoundation

struct ResultView: View {
    @State private var Showshould_ContentView = false
    @State var PlayResult: String
    
    //Ranking
    @State var GoalSecond: Int
    @State var TimeLimit: Int
    
    //ranking
    @State private var Saved = false
    @State private var SaveSuccessAlert = false
    @State private var rankingModel: [RankingModel] = []
    
    //Word
    let GameClearWordList: [String] = ["You got Moves!! 🧑‍🎓", "Amazing! ⭐️", "That's great!! \n How did you do it? 😏", "Even the developers are surprised 😳", "Respect 😍", "Fantastic!✨", "Wonderful!❤️"]
    let GameOverWordList: [String] = ["One more time! 👍", "Never give up! 🏃‍♂️", "Are you giving up? 😏\nTRY AGAIN!!", "You can do it 👊", "Go slowly and carefully 🚶"]
    @State var ResultWord: String = ""
    
    //Sound
    let GameClearSound = GameClearSoundClass()
    let GameOverSound = GameOverSoundClass()
    
    var body: some View {
        ZStack{
            NavigationLink(destination: ContentView(), isActive: $Showshould_ContentView){
                EmptyView()
            }
            Image("Tatami2").resizable()
            VStack{
                Spacer()
                if PlayResult == "Clear"{
                    HStack{
                        Text("🎉").font(.system(size: 80)).rotationEffect(.degrees(270))
                        Image("Daruma").resizable().scaledToFit().frame(width: 200, height: 200).padding()
                        Text("🎉").font(.system(size: 80))
                    }
                    Text("GameClear").font(Font.custom("ChalkboardSE-Bold", size: 70)).foregroundColor(Color.red)
                } else if PlayResult == "Over" {
                    HStack{
                        Text("😭").font(.system(size: 80))
                        Image("Daruma").resizable().scaledToFit().frame(width: 200, height: 200).padding()
                        Text("😭").font(.system(size: 80))
                    }
                    Text("GameOver").font(Font.custom("ChalkboardSE-Bold", size: 70)).foregroundColor(Color.red)
                } else if PlayResult == "TimeOver" {
                    HStack{
                        Text("🕰️").font(.system(size: 80))
                        Image("Daruma").resizable().scaledToFit().frame(width: 200, height: 200).padding()
                        Text("😭").font(.system(size: 80))
                    }
                    Text("TimeOver").font(Font.custom("ChalkboardSE-Bold", size: 70)).foregroundColor(Color.red)
                }
                Spacer()
                Text(ResultWord).font(Font.custom("ChalkboardSE-Bold", size: 50)).foregroundColor(Color.black)
                Spacer()
                HStack{
                    Button(action: {
                        if PlayResult == "Clear"{
                            GameClearSound.stop()
                        } else if PlayResult == "Over" || PlayResult == "TimeOver" {
                            GameOverSound.stop()
                        }
                        Showshould_ContentView = true
                    }){
                        Image(systemName: "house").frame(width: 80, height: 80).background(Color.red).foregroundColor(Color.white).cornerRadius(10)
                    }
                    if TimeLimit != -1 && PlayResult == "Clear"{
                        Button(action: {
                            rankingModel.append(RankingModel(TimeLimit: TimeLimit, GoalSecond: GoalSecond))
                            SaveRankingModel(Rankings: rankingModel)
                        }){
                            HStack{
                                Text("Save Rank").font(Font.custom("ChalkboardSE-Bold", size: 20))
                                Image(systemName: "trophy")
                            }.frame(width: 200, height: 80).background(Saved ? Color.gray : Color.red).foregroundColor(Color.white).cornerRadius(10)
                        }.disabled(Saved)
                    }
                }
                Spacer()
            }
        }
        .alert(isPresented: $SaveSuccessAlert) {
            Alert(title: Text("🙌 Save Rank Success 💾"),
                  message: Text("Save rank."),
                  dismissButton: .default(Text("Ok"),
                                          action: {Saved = true}))
        }
        .onAppear{
            if PlayResult == "Clear"{
                GameClearSound.play()
            } else if PlayResult == "Over" || PlayResult == "TimeOver" {
                GameOverSound.play()
            }
            if let loadrankingModel = LoadRankingModel(){
                rankingModel = loadrankingModel
            }
            RandomWord()
        }
        .navigationBarBackButtonHidden(true)
    }
    //Function to store your seconds in the ranking
    private func SaveRankingModel(Rankings: [RankingModel]){
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(Rankings) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "RankingModelKey")
        SaveSuccessAlert = true
    }
    //Function to read the current ranking
    private func LoadRankingModel() -> [RankingModel]? {
        let jsonDecoder = JSONDecoder()
        guard let data = UserDefaults.standard.data(forKey: "RankingModelKey"),
              let dataModel = try? jsonDecoder.decode([RankingModel].self, from: data) else {
            return nil
        }
        return dataModel
    }
    // Random words according to game results
    private func RandomWord(){
        if PlayResult == "Clear"{
            let gameclearrandomwordresult = GameClearWordList.randomElement()
            ResultWord = gameclearrandomwordresult!
        } else if PlayResult == "Over"{
            let gameoverrandomwordresult = GameOverWordList.randomElement()
            ResultWord = gameoverrandomwordresult!
        }
    }
}

class GameClearSoundClass {
    private var gameclearSound: AVAudioPlayer!
    
    init() {
        guard let soundURL = Bundle.main.url(forResource: "Sound-GameClear", withExtension: "mp3") else {
            fatalError("Noting Sound")
        }
        gameclearSound = try! AVAudioPlayer(contentsOf: soundURL)
        gameclearSound.prepareToPlay()
    }
    
    func play() {
        gameclearSound.play()
    }
    func stop() {
        gameclearSound.stop()
    }
}

class GameOverSoundClass {
    private var gameoverSound: AVAudioPlayer!
    
    init() {
        guard let soundURL = Bundle.main.url(forResource: "Sound-GameOver", withExtension: "mp3") else {
            fatalError("Noting Sound")
        }
        gameoverSound = try! AVAudioPlayer(contentsOf: soundURL)
        gameoverSound.prepareToPlay()
    }
    
    func play() {
        gameoverSound.play()
    }
    func stop(){
        gameoverSound.stop()
    }
}
