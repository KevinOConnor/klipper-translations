# 渦電流電感式探針

本文件介紹如何在 Klipper 中使用[渦電流電感式探針](https://zh.wikipedia.org/zh-tw/%E6%B8%A6%E9%9B%BB%E6%B5%81)。

渦電流探針目前只能用於 Z 軸探高，無法用於 Z 軸歸零。

首先在 printer.cfg 配置檔案中宣告 [probe\_eddy\_current 配置部分](https://www.klipper3d.org/zh-Hant/Config_Reference.html#probe_eddy_current)。建議將 `z_offset` 設定為 0.5mm。感測器通常會需要 `x_offset` 與 `y_offset`；若不知道這些數值，須在初始校準時估算。

校準的第一步驟是為感測器找出合適的 `DRIVE_CURRENT`。將列印機歸零，並移動工具頭，使感測器位於列印床中央上方約 20mm 處；然後輸入指令 `LDC_CALIBRATE_DRIVE_CURRENT CHIP=<配置名稱>` 。舉例來說，若配置部分名為 `[probe_eddy_current my_eddy_probe]`，那則應輸入 `LDC_CALIBRATE_DRIVE_CURRENT CHIP=my_eddy_probe`。此指令應該會在幾秒內完成，然後輸入指令 `SAVE_CONFIG` 以將結果儲存到 printer.cfg 中並重新啟動。

第二步驟是連結感測器測量值與對應的 Z 高度。將列印機歸零，並移動工具頭，使感測器位於列印床中央；然後輸入指令 `PROBE_EDDY_CURRENT_CALIBRATE CHIP=my_eddy_probe`。在程序開始後，按照[「A4紙測試法」](https://www.klipper3d.org/zh-Hant/Bed_Level.html#a4)找出在固定位置下，噴嘴與列印床中的確切距離。在測試完成後，輸入指令 `ACCEPT` 確定該位置。接下來，該程序將會移動工具頭來使感測器位於噴嘴原本的位置上方，並透過一些移動以連結感測器與 Z 位置，這會需要幾分鐘時間。程序完成之後，輸入指令 `SAVE_CONFIG` 以將結果儲存到 printer.cfg 中並重新啟動。

在初始校準完成後，最好依照[探針X/Y偏移校準](https://www.klipper3d.org/zh-Hant/Probe_Calibrate.html#xy)確認 `x_offset` 與 `y_offset` 是否準確。若要修改 `x_offset` 與 `y_offset` 數值，則須在變更後再次輸入指令 `PROBE_EDDY_CURRENT_CALIBRATE`（如上一段落所述）。

校準完成之後，則可使用 Klipper 中所有 Z 探針相關功能。

請留意渦電流感測器（與各種電感式探針）容易發生「熱飄移」現象，即為溫度變化會影響 Z 測高值。列印床或感測器硬體的溫度變化會使結果產生偏差，因此校準與測高必須在列印機溫度穩定後才能進行。

## 熱飄移校準

就如所有電感式探針一樣，渦電流探針有顯著的熱飄移狀況。若渦電流探針的線圈上有溫度感測器，便能透過設定 `[temperature_probe]` 以取得線圈溫度並開啟軟體飄移補償。若要將溫度感測器與渦電流探針連結，`[temperature_probe]` 與 `[probe_eddy_current]` 部分必須使用相同的名稱，例如：

```
[probe_eddy_current my_probe]
# 渦電流探針設定...

[temperature_probe my_probe]
# 溫度感測器設定...
```

更多關於設定 `temperature_probe` 相關細節請見[配置參考](https://www.klipper3d.org/zh-Hant/Config_Reference.html#_18)。建議先行設定 `calibration_position`、`calibration_extruder_temp`、`extruder_heating_z`、`calibration_bed_temp` 部分，便能自動化下述一些步驟。若要校準的列印機是封閉式的，強烈建議將 `max_validation_temp` 設定在 100\~120 之間。

渦電流探針的製造商可能會提供預設的飄移補償，可以將它手動添加到 `[probe_eddy_current]` 部分中的 `drift_calibration` 設定。若是沒有、或預設補償效果不佳，可以輸入 `TEMPERATURE_PROBE_CALIBRATE` 指令以使用 `[temperature_probe]` 功能中的手動校準流程。

在開始校準之前，使用者必須知道探針線圈可能達到的最高溫度，這個溫度會在 `TEMPERATURE_PROBE_CALIBRATE` 指令中作為 `TARGET` 。校準的目標是涵蓋最大的溫度範圍，因此應在列印機冷卻後開始；並在線圈達到最高溫度時結束。

在 `[temperature_probe]` 設定完成後，按照下列步驟執行熱飄移校準：

- 當 `[temperature_probe]` 設定且連結完成後，使用 `PROBE_EDDY_CURRENT_CALIBRATE` 指令開始校準探針，這會記錄熱飄移校準所需的過程溫度變化。
- 確保噴嘴乾淨且沒有耗材。
- 列印床、噴嘴、探針線圈在開始前應為冷卻狀態。
- 若**沒有**設定 `[temperature_probe]` 部分中的 `calibration_position`、`calibration_extruder_temp`、`extruder_heating_z`，則須執行下列步驟：
   - 將工具頭移動至列印床中央。Z 軸須距離列印床 30mm 以上。
   - 將噴頭加熱至熱床最大安全溫度以上，多數情況下 150\~170 度即可。加熱噴頭是為了避免在噴嘴在校準時發生熱膨脹。
   - 當噴頭達到穩定溫度之後，將 Z 軸移動至距離列印床約 1mm。
- 開始偏移校準。如果探針的名稱為 `my_probe`，且探針最高可達溫度為 80 度，那麼指令應為 `TEMPERATURE_PROBE_CALIBRATE PROBE=my_probe TARGET=80`。若有設定 `calibration_position` 與 `extruder_heating_z`，那工具頭會移動到指定的 XY 位置，並在到達指定溫度後移動到相應 Z 高度。
- 此流程需要手動探高。按照 A4 紙測試法執行手動探高再輸入 `ACCEPT` 指令。校準流程會取第一組樣本，然後將探針停在加熱位置。
- **沒有**設定 `calibration_bed_temp`，請設定列印床加熱至最高安全溫度。反之，這步驟將會自動執行。
- 預設校準流程中，每 2 度會需執行一次手動探高，直至到達設定之 `TARGET` 。此溫度變化量可以在 `TEMPERATURE_PROBE_CALIBRATE` 中的 `STEP` 自訂。請小心設定 `STEP` 數值，太高的數值會導致樣本數量不足而使校準結果不佳。
- 校準過程中可使用下列額外指令：
   - `TEMPERATURE_PROBE_NEXT` 可在溫度到達設定差值前強制取樣。
   - `TEMPERATURE_PROBE_COMPLETE` 可在到達 `TARGET` 前提前結束校準。
   - `ABORT` 可停止校準並拋棄結果。
- 校準完成後，輸入 `SAVE_CONFIG` 指令以儲存飄移校準。

總而言之，上述的校準過程要比其它流程更複雜且耗時，需多次練習與嘗試才能取得最佳校準結果。
