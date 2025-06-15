#!/usr/bin/env bash
# ----------------------------------------
# init_mn.sh ── 初始化 MN-CSE 資源樹（user_John / user_Mary）
#              person 下改建 water・calories・medication
# ----------------------------------------

MN_HOST="http://localhost:8080"   # ← 若 MN-CSE 在 8282 請改
CSEBASE="mn-name"
ORIGIN="admin:admin"
AE_API="app.fitness.demo"

# ---- header 封裝 ----
HDR_AE=(-H "X-M2M-Origin: $ORIGIN" -H 'Content-Type: application/json;ty=2')
HDR_CT=(-H "X-M2M-Origin: $ORIGIN" -H 'Content-Type: application/json;ty=3')

# ---- 建立 AE ----
create_ae() {
  local ae_name="$1"
  echo "➤ 建立 AE  $ae_name"
  curl -s -o /dev/null -w "%{http_code}\n" "${HDR_AE[@]}" \
       -d "{\"m2m:ae\":{\"rn\":\"$ae_name\",\"api\":\"$AE_API\",\"rr\":false}}" \
       "$MN_HOST/~/mn-cse/$CSEBASE"
}

# ---- 建立 CNT ----
create_ct() {
  local parent="$1"   # e.g. user_John 或 user_John/person
  local cnt="$2"
  echo "   └ 建立 CNT  $parent/$cnt"
  curl -s -o /dev/null -w "%{http_code}\n" "${HDR_CT[@]}" \
       -d "{\"m2m:cnt\":{\"rn\":\"$cnt\"}}" \
       "$MN_HOST/~/mn-cse/$CSEBASE/$parent"
}

# -------------- Main ----------------
for USER in user_John user_Mary; do
  create_ae "$USER"

  # 第一層
  create_ct "$USER" "person"
  create_ct "$USER" "activity_calendar"

  # 第二層（原 food → calories）
  for SUB in water calories medication; do
      create_ct "$USER/person" "$SUB"
  done
done

echo "✅  MN-CSE 資源初始化完成（含 calories）"
