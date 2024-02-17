import SwiftUI
import AVFoundation

struct RankingView: View {
    @Environment(\.dismiss) var dismiss

    //Sound
    let CancelSound = CancelSoundClass()
    
    @State private var selectionValue: Int = 10
    @State var rankingmodel: [RankingModel] = []
    
    var body: some View {
        ZStack{
            Image("Tatami").resizable()
            VStack{
                Spacer()
                Text("👑").font(.system(size: 60))
                Text("Time Limit Ranking").font(Font.custom("ChalkboardSE-Bold", size: 35))
                Picker("", selection: $selectionValue) {
                    Text("10 Second").tag(10)
                    Text("20 Second").tag(20)
                    Text("30 Second").tag(30)
                }.frame(width: 400).background(Color.brown).pickerStyle(SegmentedPickerStyle())
                VStack{
                    HStack{
                        if selectionValue == 10{
                            Text("10 Second TimeLimit Ranking").font(Font.custom("ChalkboardSE-Bold", size: 20)).padding()
                        } else if selectionValue == 20{
                            Text("20 Second TimeLimit Ranking").font(Font.custom("ChalkboardSE-Bold", size: 20)).padding()
                        } else if selectionValue == 30{
                            Text("30 Second TimeLimit Ranking").font(Font.custom("ChalkboardSE-Bold", size: 20)).padding()
                        }
                        Spacer()
                    }
                    Spacer()
                    ScrollView{
                        //filteredRankingModel creates an array holding only 
                        //elements that meet the specified criteria
                        //sortedRankingModel sorts it
                        let filteredRankingModel = rankingmodel.filter { $0.TimeLimit == selectionValue }
                        let sortedRankingModel = filteredRankingModel.sorted {
                            if $0.TimeLimit == $1.TimeLimit {
                                return $0.GoalSecond < $1.GoalSecond
                            } else {
                                return $0.TimeLimit > $1.TimeLimit
                            }
                        }
                        ForEach(0..<sortedRankingModel.count, id: \.self) { index in
                            let item = sortedRankingModel[index]
                            VStack {
                                HStack {
                                    Text("\(index + 1)st").font(Font.custom("ChalkboardSE-Bold", size: 20)).frame(width: 60, height: 60).background(Color.white).foregroundColor(RankingColor(index: index)).cornerRadius(10).padding()
                                    Spacer()
                                    HStack{
                                        Text("Number of Seconds it \n took to reach the goal").font(Font.custom("ChalkboardSE-Bold", size: 13))
                                        Text("\(item.GoalSecond)/\(selectionValue)").font(Font.custom("ChalkboardSE-Bold", size: 22))
                                    }
                                    Spacer()
                                    VStack{
                                        Spacer()
                                        Button(action: {
                                            if let indexToRemove = rankingmodel.firstIndex(of: item) {
                                                rankingmodel.remove(at: indexToRemove)
                                                SaveRankingModel(Rankings: rankingmodel)
                                            }
                                        }){
                                            Image(systemName: "trash").foregroundColor(Color.red)
                                        }
                                    }
                                }
                            }.frame(width: 350, height: 70).background(RankingColor(index: index)).cornerRadius(8).padding()
                        }.background(Color.white)
                    }
                    Spacer()
                }.frame(width: 400, height: 500).background(Color.white).cornerRadius(10)
                Spacer()
                Button(action: {
                    CancelSound.play()
                    dismiss()
                }){
                    Image(systemName: "house").frame(width: 80, height: 80).background(Color.red).foregroundColor(Color.white).cornerRadius(50)
                }.padding()
            }.foregroundColor(Color.black)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{
            if let loadrankingModel = LoadRankingModel(){
                rankingmodel = loadrankingModel
            }
        }
    }
    //Ranking Color
    func RankingColor(index: Int) -> Color{
        if index == 0{
            return Color.yellow
        } else if index == 1{
            return Color.gray
        } else if index == 2{
            return Color.brown
        } else {
            return Color.green.opacity(0.3)
        }
    }
    //Function to store your seconds in the ranking
    private func SaveRankingModel(Rankings: [RankingModel]){
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(Rankings) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "RankingModelKey")
    }
    //Function to read the current ranking
    func LoadRankingModel() -> [RankingModel]? {
        let jsonDecoder = JSONDecoder()
        guard let data = UserDefaults.standard.data(forKey: "RankingModelKey"),
              let dataModel = try? jsonDecoder.decode([RankingModel].self, from: data) else {
            return nil
        }
        return dataModel
    }
}

struct RankingModel: Identifiable, Codable, Equatable{
    var id = UUID()
    var TimeLimit: Int
    var GoalSecond: Int
}

#Preview {
    RankingView()
}
