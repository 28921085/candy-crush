import SwiftUI

struct ContentView: View {
    @State private var m:Int=9
    @State private var n:Int=9
    @State private var level:Int=0
    @State private var customBoard:[[Int]]=Array(repeating: Array(repeating: 0, count: 15), count: 15)
    @State private var card:[String]=["🂡","🂢","🂣","🂤","🂥","🂦","🂧","🂨","🂩","🂪"]
    @State private var highScore:[Int]=Array(repeating: 0, count: 10)
    func reset(x:Int,y:Int){
        m=x
        n=y
        for i in(0..<15){
            for j in(0..<15){
                customBoard[i][j]=0
            }
        }
        for i in(1..<m+1){
            for j in(1..<n+1){
                customBoard[i][j]=1
            }
        }
    }
    var body: some View {
        if level == 0{
            VStack{
                ForEach(0..<2){i in
                    HStack(spacing:5){
                        ForEach(0..<5){j in
                            VStack{
                                Button{
                                    level=i*5+j+1
                                    switch level{
                                    case 1://square
                                        reset(x:9,y:9)
                                    case 2://square has hole
                                        reset(x:10,y:10)
                                        for i in(0..<4){
                                            for j in(0..<4){
                                                customBoard[i+4][j+4]=0
                                            }
                                        }
                                    case 3://rectangle
                                        reset(x:10,y:3)
                                    case 4://diamond
                                        reset(x:9,y:9)
                                        for i in(1..<5){
                                            for j in(0..<i){
                                                customBoard[5-i][j+1]=0
                                                customBoard[5-i][9-j]=0
                                                customBoard[5+i][j+1]=0
                                                customBoard[5+i][9-j]=0
                                            }
                                        }
                                    case 5://tiny square
                                        reset(x:5,y:5)
                                    case 6://circle
                                        reset(x:9,y:9)
                                        for i in(1..<3){
                                            for j in(0..<i){
                                                customBoard[3-i][j+1]=0
                                                customBoard[3-i][9-j]=0
                                                customBoard[7+i][j+1]=0
                                                customBoard[7+i][9-j]=0
                                            }
                                        }
                                    case 7://沙漏
                                        reset(x:9,y:9)
                                        for i in(1..<5){
                                            for j in(0..<i){
                                                customBoard[9-i][j+1]=0
                                                customBoard[9-i][9-j]=0
                                                customBoard[1+i][j+1]=0
                                                customBoard[1+i][9-j]=0
                                            }
                                        }
                                    case 8://H
                                        reset(x:10,y:10)
                                        for i in(0..<4){
                                            for j in(0..<4){
                                                customBoard[1+i][j+4]=0
                                                customBoard[10-i][j+4]=0
                                            }
                                        }
                                    case 9://multi rectangle
                                        reset(x:10,y:10)
                                        for i in(0..<10){
                                            customBoard[3][i+1]=0
                                            customBoard[4][i+1]=0
                                            customBoard[7][i+1]=0
                                            customBoard[8][i+1]=0
                                        }
                                    case 10://line
                                        reset(x:1,y:10)
                                    default:
                                        Text("Error")
                                    }
                                }label:{
                                    Text("\(card[i*5+j])")
                                        .font(.system(size:70))
                                        .foregroundColor(.black)
                                }
                                Text("Score")
                                Text("\(highScore[i*5+j])")
                            }
                        }
                    }
                }
            }
        }
        else{
            Square_mn(m:$m,n:$n,board: $customBoard,level:$level,highScore:$highScore[level-1])
        }
    }
}
