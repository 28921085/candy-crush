import SwiftUI
struct Square_mn: View {
    @Binding var m:Int
    @Binding var n:Int
    @Binding var board:[[Int]]//0=邊界或無效的格子
    @State private var xmove:[[Int]]=Array(repeating: Array(repeating: 0, count: 11), count: 11)
    @State private var ymove:[[Int]]=Array(repeating: Array(repeating: 0, count: 11), count: 11)
    @State private var xoffset:Int=0
    @State private var yoffset:Int=0
    @State private var totalCombo:Int=0
    @State private var score:Int=0
    @State private var eliminateSum:Int=0
    @State private var lock:Int=0
    func moveFinish()->Int{//判斷是否移動結束
        for i in(0..<15){
            for j in(0..<15){
                if board[i][j] < 0{
                    return 0
                }
            }
        }
        return 1
    }
    func eliminate(){//消除
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true){
            t in
            for i in(0..<14){//最上層不做
                for j in(0..<15){
                    if board[10-i][j] < 0 && board[10-i-1][j] != 0{
                        var k:Int=1
                        while board[10-i-k][j] == 0 && 10-i-k >= 0{
                            k += 1
                        }
                        if 10-i-k >= 0{
                            sw(x1: 10-i, y1: j, x2: 10-i-k, y2: j)
                        }
                    }
                }
            }
            for i in(0..<15){
                var k:Int=0
                while board[k][i] == 0 && k < 10{//找從上往下數第一格合法的格子
                    k += 1
                }
                if board[k][i] < 0{
                    board[k][i] = Int.random(in: 1..<5)
                    eliminateSum += 1
                }
            }
            if moveFinish() == 1{
                score += totalCombo * eliminateSum
                eliminateSum = 0
                if check() != 0{
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false){
                        t in
                        eliminate()
                    }
                }
                else{
                    totalCombo=0
                }
                t.invalidate()
            }
        }
    }
    func dfs(x:Int,y:Int,tar:Int){//標記２
        board[x][y] *= -1 // 待消去
        if board[x][y+1] == tar{
            dfs(x:x,y:y+1,tar:tar)
        }
        if board[x][y-1] == tar{
            dfs(x:x,y:y-1,tar:tar)
        }
        if board[x+1][y] == tar{
            dfs(x:x+1,y:y,tar:tar)
        }
        if board[x-1][y] == tar{
            dfs(x:x-1,y:y,tar:tar)
        }
    }
    func check() -> Int {//1,2,3,4 11,12,13,14(1,2,3,4消除） 標記１
        for i in(0..<15){
            for j in(0..<15){
                if board[i][j] != 0{
                    var k=0,p=0
                    while j+k < 11 && board[i][j+k]%10 == board[i][j]%10 {
                        k += 1
                    }
                    while i+p < 11 && board[i+p][j]%10 == board[i][j]%10 {
                        p += 1
                    }
                    if k>=3 { //0 1 2三消
                        for q in(0..<k){
                            board[i][j+q] = board[i][j+q]%10 + 10
                        }
                    }
                    if p>=3 { //0 1 2三消
                        for q in(0..<p){
                            board[i+q][j] = board[i+q][j]%10 + 10
                        }
                    }
                }
            }
        }
        var combo:Int=0
        for i in(0..<15){
            for j in(0..<15){
                if board[i][j]>10{
                    dfs(x:i,y:j,tar:board[i][j])
                    combo += 1
                }
            }
        }
        totalCombo += combo
        return combo
    }
    func sw(x1:Int,y1:Int,x2:Int,y2:Int){//swap
        (board[x1][y1],board[x2][y2])=(board[x2][y2],board[x1][y1])
    }
    var body: some View {
        VStack(spacing:0){
            Text("Score :\(score) Combo :\(totalCombo)").onAppear{
                for i in(1..<m+2){
                    for j in(1..<n+2){
                        if board[i][j] == 1{//init
                            board[i][j]=Int.random(in: (1..<5))
                        }
                    }
                }
            }
            ForEach (1..<m+1){
                i in
                HStack(spacing:0){
                    ForEach(1..<n+1){
                        j in
                        ZStack{
                            if board[i][j] != 0{
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.gray).frame(width: 50, height: 50)
                                    .gesture(
                                        DragGesture()
                                            .onChanged({value in
                                                xoffset += Int(value.translation.width)
                                                yoffset += Int(value.translation.height)
                                            })
                                            .onEnded({value in 
                                                if abs(xoffset)>abs(yoffset){
                                                    if xoffset>0 && board[i][j+1] != 0{
                                                        sw(x1:i,y1:j,x2:i,y2:j+1)
                                                        if check() == 0{
                                                            sw(x1:i,y1:j,x2:i,y2:j+1)
                                                            xmove[i][j] += 50
                                                            xmove[i][j+1] -= 50
                                                            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false){
                                                                t in
                                                                xmove[i][j] -= 50
                                                                xmove[i][j+1] += 50
                                                            }
                                                        }
                                                        else{
                                                            sw(x1:i,y1:j,x2:i,y2:j+1)
                                                            xmove[i][j] += 50
                                                            xmove[i][j+1] -= 50
                                                            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false){
                                                                t in
                                                                eliminate()
                                                                xmove[i][j] -= 50
                                                                xmove[i][j+1] += 50
                                                                sw(x1:i,y1:j,x2:i,y2:j+1)
                                                            }
                                                        }
                                                    }
                                                    else if board[i][j-1] != 0{
                                                        sw(x1:i,y1:j,x2:i,y2:j-1)
                                                        if check() == 0{
                                                            sw(x1:i,y1:j,x2:i,y2:j-1)
                                                            xmove[i][j] -= 50
                                                            xmove[i][j-1] += 50
                                                            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false){
                                                                t in
                                                                xmove[i][j] += 50
                                                                xmove[i][j-1] -= 50
                                                            }
                                                        }
                                                        else{
                                                            sw(x1:i,y1:j,x2:i,y2:j-1)
                                                            xmove[i][j] -= 50
                                                            xmove[i][j-1] += 50
                                                            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false){
                                                                t in
                                                                eliminate()
                                                                xmove[i][j] += 50
                                                                xmove[i][j-1] -= 50
                                                                sw(x1:i,y1:j,x2:i,y2:j-1)
                                                            }
                                                        }
                                                    }
                                                }
                                                else{
                                                    if yoffset>0{
                                                        sw(x1:i,y1:j,x2:i+1,y2:j)
                                                        if check() == 0{
                                                            sw(x1:i,y1:j,x2:i+1,y2:j)
                                                            ymove[i][j] += 50
                                                            ymove[i+1][j] -= 50
                                                            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false){
                                                                t in
                                                                ymove[i][j] -= 50
                                                                ymove[i+1][j] += 50
                                                            }
                                                        }
                                                        else{
                                                            sw(x1:i,y1:j,x2:i+1,y2:j)
                                                            ymove[i][j] += 50
                                                            ymove[i+1][j] -= 50
                                                            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false){
                                                                t in
                                                                eliminate()
                                                                ymove[i][j] -= 50
                                                                ymove[i+1][j] += 50
                                                                sw(x1:i,y1:j,x2:i+1,y2:j)
                                                            }
                                                        }
                                                    }
                                                    else if board[i-1][j] != 0{
                                                        sw(x1:i,y1:j,x2:i-1,y2:j)
                                                        if check() == 0{
                                                            sw(x1:i,y1:j,x2:i-1,y2:j)
                                                            ymove[i][j] -= 50
                                                            ymove[i-1][j] += 50
                                                            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false){
                                                                t in
                                                                ymove[i][j] += 50
                                                                ymove[i-1][j] -= 50
                                                            }
                                                        }
                                                        else{
                                                            sw(x1:i,y1:j,x2:i-1,y2:j)
                                                            ymove[i][j] -= 50
                                                            ymove[i-1][j] += 50
                                                            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false){
                                                                t in
                                                                eliminate()
                                                                ymove[i][j] += 50
                                                                ymove[i-1][j] -= 50
                                                                sw(x1:i,y1:j,x2:i-1,y2:j)
                                                            }
                                                        }
                                                    }
                                                }
                                                xoffset = 0
                                                yoffset = 0
                                            })
                                    )
                                Image((board[i][j] < 0 ? "\(-board[i][j])" : "\(board[i][j] % 10)"))
                                    .resizable()
                                    .frame(width:40,height:40)
                                    .opacity((board[i][j] < 0 ? 0 : 1))
                                    .offset(x:CGFloat(xmove[i][j]),y:CGFloat(ymove[i][j]))
                                    .animation(.default)
                                //.animation(.easeIn,value:CGFloat(xmove[i][j]))
                                //.animation(.easeIn,value:CGFloat(ymove[i][j]))
                            
                            } 
                            else {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.gray).frame(width: 50, height: 50)
                                    .hidden()
                            }
                        }
                    }
                }
            }
        }
    }
}
