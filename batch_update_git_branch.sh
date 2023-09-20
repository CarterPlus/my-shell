#!/bin/bash

function process_directory() {
    local directory="$1"
    local subdirectories=($(ls "$directory"))

    for subdirectory in "${subdirectories[@]}"; do
        local full_path="$directory/$subdirectory"

        if [ -d "$full_path" ]; then
            (
                cd "$full_path"
                pwd
                git -c credential.helper= -c core.quotepath=false -c log.showSignature=false checkout -B release origin/release --
                git -c credential.helper= -c core.quotepath=false -c log.showSignature=false fetch origin --recurse-submodules=no --progress --prune
            ) &
        fi
    done
}

process_directory "./"

# 等待所有后台任务完成
wait

echo '完美的运行！'
