#include<iostream>
using namespace std;

#define H 3 
#define W 4
#define S 1
#define Pool_size 2
#define output_h  ((H - Pool_size) / S + 1) 
#define output_w  ((W - Pool_size) / S + 1)


void max_pooling(int input[], int output[]) {
    //输出矩阵遍历
    for (int oh = 0; oh < output_h; oh++) {
        for (int ow = 0; ow < output_w; ow++) {
            //确定池化窗口起始位置
            int h_start = oh * S;
            int w_start = ow * S;
            //初始化最大值
            int max_val = INT_MIN;//设为可能的最小整数值
            
            // 在池化窗口中寻找最大值
            for (int i = 0; i < Pool_size; i++) {
                for (int j = 0; j < Pool_size; j++) {
                    int h_pos = h_start + i;//池化窗口内的位置
                    int w_pos = w_start + j;//池化窗口内的位置
                    //判断是否越界
                    if (h_pos < H && w_pos < W) {
                        int idx = h_pos * W + w_pos;
                        if (input[idx] > max_val) {
                            max_val = input[idx];
                        }
                    }
                }
            }  
            output[oh * output_w + ow] = max_val;
        }
    }
}


// 打印矩阵
void PrintArray(int *In_Array, int size_h, int size_w){
    for(int i = 0; i < size_h; i++){
        for(int j = 0; j < size_w; j++){
            cout << In_Array[i * size_w + j] << " ";
        }
        cout << endl;
    }
}

int main()
{
    int Input[H*W] = {1, 2, 3, 4,
                      4, 5, 6, 5,
                      7, 8, 9, 3};

    int Output[output_h * output_w] = {};

    cout<<"Input:"<<endl;
    PrintArray(Input, H, W);

    max_pooling(Input, Output);

    cout << "Output:" << endl;
    PrintArray(Output, output_h, output_w);

    return 0;
}