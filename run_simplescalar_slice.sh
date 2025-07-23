#!/bin/bash

# ---------- 使用者可自訂參數 ----------
SIM_EXEC="./sim-outorder"
BINARY="./tests-alpha/bin/test-printf"
TOTAL_INST=1000000           # 要模擬的總指令數
CHUNK=100000                 # 每段模擬多少條指令
PTRACE_LIMIT=10000           # 每段最多 trace 幾條（0 表示不 trace）
OUTPUT_DIR="sim_output"      # 所有輸出都放到這裡
# -------------------------------------

# 檢查執行檔是否存在
if [ ! -f "$SIM_EXEC" ]; then
    echo "❌ 錯誤：找不到 $SIM_EXEC"
    exit 1
fi

if [ ! -f "$BINARY" ]; then
    echo "❌ 錯誤：找不到執行檔 $BINARY"
    exit 1
fi

# 建立輸出資料夾
mkdir -p "$OUTPUT_DIR"

# 開始分段模擬
i=0
while [ $(( i * CHUNK )) -lt $TOTAL_INST ]; do
    START=$(( i * CHUNK ))
    END=$(( START + CHUNK ))
    STAT_FILE="${OUTPUT_DIR}/stats${i}.out"
    TRACE_FILE="${OUTPUT_DIR}/trace${i}.trace"

    echo "▶️ 執行第 $START ~ $END 條指令..."
    $SIM_EXEC -fastfwd $START -max:inst $END \
              -ptrace $TRACE_FILE :$PTRACE_LIMIT \
              -redir:sim $STAT_FILE \
              $BINARY

    if [ $? -ne 0 ]; then
        echo "❌ 第 $i 段模擬失敗"
        exit 1
    fi

    i=$(( i + 1 ))
done

echo "✅ 所有模擬完成！結果已儲存在資料夾：$OUTPUT_DIR"

