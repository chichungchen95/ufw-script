#!/bin/bash

# 確保腳本以 root 用戶執行
if [ "$EUID" -ne 0 ]
  then echo "請以 root 權限執行此腳本."
  exit
fi

# 顯示幫助信息
function show_help() {
  echo "用法: ./ufw_manager.sh [選項]"
  echo "選項:"
  echo "  enable                   啟用 UFW"
  echo "  disable                  停用 UFW"
  echo "  status                   顯示 UFW 狀態和規則"
  echo "  allow <port/service>     允許指定埠或服務的入站流量"
  echo "  deny <port/service>      拒絕指定埠或服務的入站流量"
  echo "  delete <port/service>    刪除指定埠或服務的規則"
  echo "  reset                    重置 UFW 規則"
  echo "  show_log                 顯示 UFW 日誌"
}

# 啟用 UFW
function enable_ufw() {
  ufw enable
}

# 停用 UFW
function disable_ufw() {
  ufw disable
}

# 顯示 UFW 狀態
function ufw_status() {
  ufw status verbose
}

# 允許指定埠或服務
function allow_port() {
  ufw allow "$1"
}

# 拒絕指定埠或服務
function deny_port() {
  ufw deny "$1"
}

# 刪除指定埠或服務的規則
function delete_rule() {
  ufw delete "$1"
}

# 重置 UFW 規則
function reset_ufw() {
  echo "警告: 這將刪除所有現有的 UFW 規則！"
  read -p "你確定要重置 UFW 嗎？[y/N]: " confirm
  if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    ufw reset
    echo "UFW 已重置."
  else
    echo "操作已取消."
  fi
}

# 顯示 UFW 日誌
function show_log() {
  tail -f /var/log/ufw.log
}

# 根據使用者輸入執行對應的功能
case "$1" in
  enable)
    enable_ufw
    ;;
  disable)
    disable_ufw
    ;;
  status)
    ufw_status
    ;;
  allow)
    if [ -n "$2" ]; then
      allow_port "$2"
    else
      echo "請指定埠或服務名稱."
    fi
    ;;
  deny)
    if [ -n "$2" ]; then
      deny_port "$2"
    else
      echo "請指定埠或服務名稱."
    fi
    ;;
  delete)
    if [ -n "$2" ]; then
      delete_rule "$2"
    else
      echo "請指定要刪除的埠或服務名稱."
    fi
    ;;
  reset)
    reset_ufw
    ;;
  show_log)
    show_log
    ;;
  *)
    show_help
    ;;
esac
