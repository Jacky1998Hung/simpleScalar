#!/bin/bash

# 使用方式提示
if [ $# -lt 1 ]; then
    echo "用法：$0 <輸出統計檔名>"
    echo "範例：$0 stats_run1.out"
    exit 1
fi

# 取得使用者輸入的 stats 檔案名稱
STATS_FILE="$1"

# 其他設定
SIM_EXEC="./sim-outorder"
BINARY="./tests-alpha/bin/test-printf"
TRACE_FILE="test.trace"
PTRACE_LIMIT=10000

# 檢查執行檔是否存在
if [ ! -f "$SIM_EXEC" ]; then
    echo "錯誤：找不到 sim-outorder"
    exit 1
fi

if [ ! -f "$BINARY" ]; then
    echo "錯誤：找不到 $BINARY"
    exit 1
fi

# 執行模擬
echo "開始模擬 $BINARY，輸出檔名為 $STATS_FILE"
$SIM_EXEC -ptrace $TRACE_FILE :$PTRACE_LIMIT -redir:sim $STATS_FILE $BINARY

# 成功提示
if [ $? -eq 0 ]; then
    echo "模擬完成！"
    echo "- Pipeline trace: $TRACE_FILE"
    echo "- 統計輸出檔: $STATS_FILE"
else
    echo "模擬失敗"
fi

