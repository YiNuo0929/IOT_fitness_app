#!/usr/bin/env bash
# ---------------------------------------------
# init_in.sh  ―  初始化 IN-CSE 資源樹（含 in-name）
# ---------------------------------------------
IN_HOST="http://localhost:8080"          # ⇐ 修改為你的伺服器位址
CSEBASE="in-name"                        # ⇐ IN-CSE 的容器名稱（如 in-name）
ORIGIN="admin:admin"                     # ⇐ 預設帳密
AE_API="group_activity"                 # ⇐ AE 的 app-id 改為簡化名稱
POA="http://127.0.0.1:1880/group_activity"  # ⇐ 新增 Point of Access

HDR_AE=(-H "X-M2M-Origin: $ORIGIN" -H "Content-Type: application/json;ty=2")
HDR_CT=(-H "X-M2M-Origin: $ORIGIN" -H "Content-Type: application/json;ty=3")

create_ae() {
  local ae_name=$1
  echo "➤ 建立 AE  $ae_name"
  curl -s -o /dev/null -w "%{http_code}\n" "${HDR_AE[@]}" \
       -d "{\"m2m:ae\":{
              \"rn\":\"$ae_name\",
              \"api\":\"$AE_API\",
              \"poa\":[\"$POA\"],
              \"rr\":true
           }}" \
       "$IN_HOST/~/in-cse/$CSEBASE"
}

create_ct() {
  local parent=$1
  local ct_name=$2
  echo "    └─ 建立 CNT  $parent/$ct_name"
  curl -s -o /dev/null -w "%{http_code}\n" "${HDR_CT[@]}" \
       -d "{\"m2m:cnt\":{\"rn\":\"$ct_name\"}}" \
       "$IN_HOST/~/in-cse/$CSEBASE/$parent"
}

# ---------------- Main ----------------
GROUP_AE="group_activity"
create_ae "$GROUP_AE"
create_ct "$GROUP_AE" "activity_calendar"

echo "✅  IN-CSE 資源初始化完成"
