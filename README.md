# IoT Fitness App 平台 README

## 專案概覽
- **行動打卡**：使用者透過 Android App（`final_project.apk`）輸入每日運動紀錄。  
- **即時同步**：資料 POST 至 **mn-cse**，並透過訂閱機制自動轉發到 **in-cse**，確保群組端能擁有完整歷史資料。  
- **資料查詢**  
  - `person` container：僅保留「最新一筆」個人紀錄，方便快速 GET。  
  - `activity_calendar` container：保留「所有歷史紀錄」，供後續統計或視覺化。  
- **API 代理／轉換**：`Node-RED` 透過兩支 flow 將 HTTP 請求轉為 OM2M 需要的 XML／JSON，接收通知時再轉回 JSON，方便前端或其他服務使用。  

> 🔎 **目標**：最小化手動操作 ── 只需四條指令即可完成環境建置並開始打卡。

## 資料夾結構
```text
.
├── node-red/           # Node-RED flows（flow.json, flow-2.json）
├── app_proposal.pptx   # 提案簡報
├── final_project.apk   # Android App
├── final_project.pptx  # 期末簡報
├── init_mn.sh          # 建立 mn-cse 容器
├── init_in.sh          # 建立 in-cse 容器
├── postman.json        # 建立 mn ➜ in 訂閱
└── README.md           # 本文件

# 1️⃣ 建立資源樹（mn / in）
bash init_mn.sh   # mn-cse：建立 user_X/person & activity_calendar
bash init_in.sh   # in-cse：建立 group_activity 等容器

# 2️⃣ 建立訂閱（mn ➜ in）
#    Postman → 匯入 postman.json → Run collection
#    （或使用 curl 執行內含 HTTP POST 指令）

# 3️⃣ 部署 Node-RED 並載入流程
cd node-red
node-red -u .      # 以當前資料夾作為 userDir
# 瀏覽器開啟 http://<IP>:1880 → Import → flow.json & flow-2.json → Deploy

# 4️⃣ 安裝並啟動 Android App
adb install -r ../final_project.apk   # 或手動安裝
# App 設定頁輸入 mn-cse IP，立即開始打卡