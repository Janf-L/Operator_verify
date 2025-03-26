# Makefile

# 默认目标
all: run wave

# 变量定义（可被命令行覆盖）
TB = .\\output\\tb
FILE_LIST = .\\output\\filelist.f
TOP_TB ?= Average_pooling_tb
VCD = .\\output\\$(TOP_TB).vcd

# 生成文件列表的目标
filelist.f:
	powershell -Command "Get-ChildItem -Recurse -Include *.*v | Resolve-Path -Relative > $(FILE_LIST)"

# 编译目标
tb: filelist.f
	iverilog -o $(TB) -s $(TOP_TB) $(shell powershell -Command "Get-Content $(FILE_LIST)")

# 运行仿真
run: tb
	vvp -n $(TB) -lxt2

# 查看波形
wave: 
	gtkwave $(VCD)

# 清理生成的文件
clean:
	rm -f $(FILE_LIST) $(TB) $(VCD)
.PHONY: all run wave clean