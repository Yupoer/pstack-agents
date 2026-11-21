# 在 Codex 使用 pstack

這個 fork 的 Codex 安裝獨立管理技能、模型設定與更新。基底是上游 pstack v0.15.42。原始 `pstack/` 與上游 Git 歷史保留，方便之後合併新版。

## 安裝與更新

在 Windows PowerShell 於這個 checkout 根目錄執行：

```powershell
& .\codex\sync-pstack.ps1 -SourceRoot $PWD.Path
```

需要 Windows PowerShell 5.1 的啟動方式時，可執行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\codex\sync-pstack.ps1 -SourceRoot .
```

安裝會把來源複製到 `~/.codex/pstack/versions/`，用 `runtime` junction 指向這一版，再把技能連到 `~/.agents/skills/`。`codex/skills/` 的 Codex 專用入口覆蓋同名上游技能。每個安裝的技能都會先載入 [Codex runtime](runtime.md)。

模型設定存於 `~/.codex/pstack/pstack-models.md`。首次安裝使用 repo 裡的角色設定，判斷和專業角色使用 `gpt-6.1-sol max`，panel 保留兩個 agent。重跑安裝會保留現有設定。所有模型只能選各供應商同系列、同級別的最新版；不可因不可用、配額或速度退回舊版。2026-11-06 的 OpenAI 版本為 Luna 6、Terra 6.1、Sol 6.1、Astra 6。確認更新版本後取代舊版，不把這份日期清單當永久上限。

安裝程式只取代自己管理的 junction，遇到同名的其他技能會在安裝前停止。原本指向官方 pstack 快取的舊 junction 會移除，目標檔案保留。舊 adapter、herdr 委派腳本與共用教學會移到備份。這些舊整合不再參與 Codex 執行。

`~/.codex/AGENTS.md` 只更新 pstack 區塊，其餘個人指示保留。開啟新的 Codex chat 以載入新指示；若技能清單仍未刷新，再重新啟動 Codex。

需要檢查原始上游、修改來源、推送 fork 並更新本機時，使用 [maintain-pstack](../pstack/skills/maintain-pstack/SKILL.md)。它會分別確認上游、本機驗證、直接 push 預設分支與本機安裝，保留既有模型設定和個人指示。這個 fork 不使用 PR 或 CI/CD。可直接要求「用 maintain-pstack 檢查上游並同步 fork 和本機，本機驗證後直接推送」。

只要安裝 fork 已發布的版本時，從乾淨的 checkout 更新來源並安裝：

```powershell
git pull --ff-only origin main
& .\codex\sync-pstack.ps1 -SourceRoot $PWD.Path
```

已安裝的同步腳本也可搭配明確的 checkout 路徑使用：

```powershell
& "$HOME/.codex/pstack/sync-pstack.ps1" -SourceRoot 'C:\repos\pstack-agents'
```

## 同步到各台主機

在維護用的 checkout 把原版 `cursor/plugins` 更新和自訂改動合在一起。先在本機驗證，再推到 fork 的 `main`。各台主機只從 fork 快進拉取已發布版本。拉取後，用各自的同步腳本更新 Codex runtime：Windows 用上面的 PowerShell 腳本，已配置的 Mac 用本機的 `sync-pstack-macos.py`。逐台確認 checkout 指向同一個 fork commit，並確認已安裝的 runtime 來自該 checkout。既有模型檔由各台保留，需要更改的角色另行更新。

## 並行工作與機械操作

依照 [Codex 的並行規則](runtime.md#work-in-parallel)，可以馬上開始的獨立工作一起跑。主代理在其他工作進行時繼續處理自己的部分，等到下一步需要某個結果才等它。同一個可寫目標只交給一個操作者；需要新版本或前一步產物的檢查等輸入就緒。

只須跑指定指令或照步驟操作工具時，交給 `mechanical execution`。預設為 `gpt-6.1-terra high`，舊有模型設定缺少這一列也適用。如果最新版 Luna 支援所需工具，可在模型檔設定 `mechanical execution: gpt-6-luna low`，版本依上面的模型政策更新。操作代理回傳原始輸出、操作紀錄或截圖，主代理負責解讀。

## 非同步熱路徑掃描

可重用的 [async hot-path prompt](../pstack/skills/poteto-mode/references/async-hot-paths.md) 會盤點非同步入口、確認依賴、修正多餘的循序等待並驗證行為。安裝後可從 `~/.agents/skills/poteto-mode/references/async-hot-paths.md` 讀取。完整 prompt 包含完成後建立 GitHub issue；只做本機掃描時移除該段。

## 視覺設計指引

共用指引位於 [`pstack/skills/poteto-mode/references/visual-design.md`](../pstack/skills/poteto-mode/references/visual-design.md)。Poteto mode、Feature、Prototype 與 Experience First 已接入。來源貼文的字型、token、API 與 iframe 限制只在實際宿主支援時適用。

## 檢查與復原

專案初始設定會先沿用既有驗證，再評估缺少的實際操作驗證或形式驗證。重要狀態轉換、並行事件、重試、取消與一致性問題可接到既有 formal verification 技能。只調整模型或 effort 時維持原本範圍。模型、程式碼對應、假設和實際 lint 設定留在各專案。

`interrogate` 保留執行與重跑證據的要求。只有明確要求，或既有檢查後仍有具體且重要的未解問題時才啟動。註解檢視保留授權、公開 API 契約、必要工具指示，以及程式碼無法表達的限制原因。

這個 fork 只使用本機驗證，不設定 GitHub Actions 或其他 CI/CD。先安裝檢查所需依賴：

```powershell
npm install --no-save ajv ajv-formats fast-check@4.5.3
node scripts/verify-pstack.mjs quick
```

`quick` 執行 plugin 定義、文件一致性與 generated harness freshness 檢查。修改共享來源後，先執行 `node scripts/generate-pstack-harness-trees.mjs` 更新產物。`full` 再執行既有 Node skill scripts 與驗證入口本身的行為測試；修改這些腳本或整合行為時在本機使用。Windows 安裝檢查仍在隔離目錄執行。

編輯期間跑受影響檢查，推送前跑 `quick` 並確認最終 diff。相同內容、依賴、設定與相關環境未變時沿用有效證據。確認遠端預設分支仍是祖先後，以一般 fast-forward push 發布，重讀遠端 SHA，再由已發布的乾淨來源安裝。遠端已前進時先整合並重跑受影響檢查，不 force-push，也不改用 PR。

其他使用 CI/CD 的專案可使用共用流程 [CI recovery](../pstack/skills/poteto-mode/references/ci-recovery.md)，已接入 Poteto mode、Bug fix、Babysit、PR 與 Shipping。它區分 workflow 綠燈、原失敗關卡通過與修正歸因。歷史統計保留取樣方式、逐筆證據與未解決項目，不把專案個案寫成全域規則。

修復收尾會記錄防再犯決策。先判斷既有檢查是否足夠或需要修正，再決定是否補一個有價值的約束；重複錯誤類型接到 `correct`。基礎設施故障不會自動產生新 lint。

CI 效能的共用流程位於 [`CI performance diagnosis`](../pstack/skills/benchmark-checklist/references/ci-performance.md)，已接入 Poteto mode、Perf issue、Benchmark checklist 與 PR 流程。純審核先交付報告；實作依既有授權處理。付費資源與檢查覆蓋範圍的變更會明確列出供決策。

```powershell
& .\codex\test-sync-pstack.ps1 -SourceRoot $PWD.Path -TestRoot 'C:\temp\pstack-check'
node scripts/verify-pstack.mjs quick
```

第一個命令在獨立測試目錄檢查安裝、舊 junction 遷移、衝突保護與重跑。第二個命令執行共享快檢，其中保留的上游 harness 產物不是 Codex 的安裝來源。修改 `pstack/` 後，先執行 `node scripts/generate-pstack-harness-trees.mjs` 再提交。

每次安裝都保留上一版 runtime 與 `~/.codex/pstack/backups/<安裝編號>/`。備份中的 `junctions.json` 保存舊連結目標，`AGENTS.md` 保存修改前指示。`install.json` 記錄目前來源、runtime 與備份路徑。復原時先確認目標，再重建對應 junction 並還原備份檔案。

本機驗證證明安裝內容與檔案路由，不代表已逐一執行全部技能。上游 MIT 授權保留於 `pstack/LICENSE`。
