# 卷积运算示例(输入HW一致)
if(1):
     print("卷积运算")
     N = 3
     K = 3

     # 输入矩阵
     Input = [[1, 2, 3],
              [2, 3, 4],
              [3, 4, 5]]

     # 卷积核
     Kernal = [[1, 1, 1],
               [1, 2, 1],
               [1, 1, 1]]

     # stride=1, padding=0
     S = 2
     P = 2
     Output_Size = int((N - K + 2 * P) / S + 1)

     # 定义输出矩阵
     Output = [[0 for i in range(Output_Size)] for j in range(Output_Size)]
     print("Output_init:", Output)

     # 对输入进行padding
     Input_pad = [[0 for i in range(N + 2 * P)] for j in range(N + 2 * P)]
     for i in range(N):
          for j in range(N):
               Input_pad[i + P][j + P] = Input[i][j]
     print("Input_pad:", Input_pad)

     # 定义卷积操作
     def Conv(Input_pad_sub):
          Accumulation = 0
          for i in range(K):
               for j in range(K):
                    Accumulation += Input_pad_sub[i][j] * Kernal[i][j]
          return Accumulation

     # 以步长S在Input_pad上进行滑窗操作
     for i in range(Output_Size):
          for j in range(Output_Size):
               start_i = i * S
               start_j = j * S
               # 取KxK子矩阵
               Input_pad_sub = [row[start_j:start_j+K] for row in Input_pad[start_i:start_i+K]]
               # 进行卷积，并存储到Output
               Output[i][j] = Conv(Input_pad_sub)
     print("Output:", Output)

# 改进版卷积运算示例
elif(0):
     print("改进版卷积运算")
     H = 3
     W = 3
     K_H = 3
     K_W = 3

     # 输入矩阵
     Input = [[1, 2, 3],
              [4, 5, 6],
              [7, 8, 9]]

     # 卷积核
     Kernal = [[1, 0, 0],
               [0, 1, 0],
               [0, 0, 1]]

     # stride=1, padding=0
     S = 2
     P = 2
     Output_Size_H = int((H - K_W + 2 * P)/S + 1)
     Output_Size_W = int((W - K_H + 2 * P)/S + 1)

     # 定义输出矩阵
     Output = [[0 for i in range(Output_Size_W)] for j in range(Output_Size_H)]
     print("Output_init:", Output)

     # 对输入进行padding
     Input_pad = [[0 for i in range(W + 2 * P)] for j in range(H + 2 * P)]
     for i in range(H):
          for j in range(W):
               Input_pad[i + P][j + P] = Input[i][j]
     print("Input_pad:", Input_pad)

     # 定义卷积操作
     def Conv(Input_pad_sub):
          Accumulation = 0
          for i in range(K_H):
               for j in range(K_W):
                    Accumulation += Input_pad_sub[i][j] * Kernal[i][j]
          return Accumulation

     # 以步长S在Input_pad上进行滑窗操作
     for i in range(Output_Size_H):
          for j in range(Output_Size_W):
               start_i = i * S
               start_j = j * S
               # 取KxK子矩阵
               Input_pad_sub = [row[start_j:start_j+K_W] for row in Input_pad[start_i:start_i+K_H]]
               # 进行卷积，并存储到Output
               Output[i][j] = Conv(Input_pad_sub)
     print("Output:", Output)
