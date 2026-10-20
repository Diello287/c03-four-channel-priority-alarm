
## 1. Mục tiêu dự án

Thiết kế **Bộ cảnh báo bốn kênh có mức ưu tiên** (*Four-Channel Priority
Alarm*), viết RTL Verilog, mô phỏng bằng testbench, chạy CI trên GitHub
Actions và hướng tới tổng hợp/đặt tuyến vật lý để tạo GDSII bằng
LibreLane.

### Đặc tả chức năng đã được người học cung cấp

-   Có 4 kênh, mỗi kênh có mức nghiêm trọng 2 bit, giá trị từ 0 đến 3.
-   Đầu ra cho biết chỉ số kênh có mức nghiêm trọng cao nhất và mức
    nghiêm trọng tương ứng.
-   Nếu nhiều kênh có cùng mức cao nhất, chọn kênh có chỉ số nhỏ hơn.
-   `ui_in[7:0`: chứa 4 kênh × 2 bit.
    -   Kênh 0: `ui_in[1:0]`
    -   Kênh 1: `ui_in[3:2]`
    -   Kênh 2: `ui_in[5:4]`
    -   Kênh 3: `ui_in[7:6]`
-   `uo_out[1:0]`: chỉ số kênh được chọn.
-   `uo_out[3:2]`: mức nghiêm trọng cao nhất.
-   `uo_out[4]`: cờ báo hợp lệ/báo động (`1` nếu có ít nhất một kênh
    khác 0).
-   Các bit `uo_out[7:5]` phải bằng 0.
-   Dự kiến khoảng 120--180 cell, tile 1×1 (đây là ước lượng đề bài,
    không phải kết quả đã đo).

### Trường hợp kiểm thử bắt buộc theo thông tin đã có

1.  Tất cả kênh im lặng (mức 0).
2.  Chỉ một kênh có báo động.
3.  Hai kênh có cùng mức.
4.  Bốn kênh có mức khác nhau.

------------------------------------------------------------------------

## 2. Trạng thái hiện tại của GitHub

Repository đã tạo thành công:

-   Tài khoản/owner: `Diello287`
-   Tên repo: `four-channel-priority-alarm`
-   URL: https://github.com/Diello287/four-channel-priority-alarm
-   Visibility: Public
-   Trạng thái gần nhất: chỉ có `README.md` và commit `Initial commit`.
-   **Chưa xác nhận đã tạo file workflow, mã RTL, testbench, cấu hình
    LibreLane hay có lần chạy CI thành công.**
-   Link repo là link thật theo thông tin người học đã cung cấp. **Chưa
    có link CI run** vì chưa xác nhận workflow đã chạy.

------------------------------------------------------------------------

## 3. Khái niệm cần nắm

-   **RTL**: mô tả hành vi logic số ở mức thanh ghi/chuyển mức, thường
    viết bằng Verilog/SystemVerilog.
-   **Testbench**: môi trường tạo đầu vào và kiểm tra đầu ra của RTL.
-   **Simulation/waveform**: chạy mô phỏng; waveform thường là file
    `.vcd`, có thể mở bằng GTKWave.
-   **Synthesis**: chuyển RTL thành mạng cổng logic.
-   **P&R (Place and Route)**: bố trí cell và định tuyến dây.
-   **GDSII**: dữ liệu layout vật lý cuối cùng, dùng trong quy trình
    thiết kế vi mạch.
-   **Timing report/STA**: báo cáo kiểm tra thời gian, ví dụ đường tới
    hạn (*critical path*), độ trễ và slack.
-   **CI (Continuous Integration)**: GitHub Actions tự động chạy kiểm
    thử/flow khi push, tạo pull request hoặc được kích hoạt thủ công.
-   **PDK sky130A**: bộ dữ liệu công nghệ SkyWater 130 nm. Chỉ dùng khi
    flow và cấu hình dự án thực sự nhắm tới PDK này.

Quy trình tổng quát:

`RTL → mô phỏng → tổng hợp → floorplan/place/route → kiểm tra timing/DRC/LVS (nếu flow hỗ trợ) → GDSII và báo cáo`

Một lần CI có dấu xanh chỉ có nghĩa là các bước được cấu hình đã qua;
vẫn phải kiểm tra log, testbench, metrics và artifact.

------------------------------------------------------------------------

## 4. RTL tham khảo cho thiết kế

**Quan trọng:** Đoạn dưới đây là RTL tham khảo theo đặc tả đã nêu. Trước
khi dùng, phải giữ đúng tên module và danh sách cổng của template môn
học. Nếu template yêu cầu tên module khác, hãy sửa phù hợp với template;
không tự ý thay đổi giao diện top-level.

``` verilog
`default_nettype none

module project (
    input  wire [7:0] ui_in,
    output reg  [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    wire [1:0] sev0 = ui_in[1:0];
    wire [1:0] sev1 = ui_in[3:2];
    wire [1:0] sev2 = ui_in[5:4];
    wire [1:0] sev3 = ui_in[7:6];

    reg [1:0] best_sev;
    reg [1:0] best_idx;
    reg       alarm_valid;

    always @* begin
        // Khởi tạo bằng kênh 0 để kênh chỉ số nhỏ được ưu tiên khi hòa.
        best_sev = sev0;
        best_idx = 2'd0;

        // Dùng > thay vì >= để không ghi đè kênh chỉ số nhỏ khi hòa.
        if (sev1 > best_sev) begin
            best_sev = sev1;
            best_idx = 2'd1;
        end

        if (sev2 > best_sev) begin
            best_sev = sev2;
            best_idx = 2'd2;
        end

        if (sev3 > best_sev) begin
            best_sev = sev3;
            best_idx = 2'd3;
        end

        alarm_valid = (sev0 != 0) ||
                      (sev1 != 0) ||
                      (sev2 != 0) ||
                      (sev3 != 0);

        uo_out = 8'b0;
        uo_out[1:0] = best_idx;
        uo_out[3:2] = best_sev;
        uo_out[4]   = alarm_valid;
    end

    // Các cổng giao tiếp hai chiều không dùng trong thiết kế này.
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule

`default_nettype wire
```

### Giải thích tie-break

Khởi đầu chọn kênh 0, sau đó chỉ cập nhật khi mức mới **lớn hơn** mức
đang chọn. Nếu hai mức bằng nhau, điều kiện `>` là sai nên kênh có chỉ
số nhỏ hơn vẫn được giữ lại.

Nếu cả bốn mức đều bằng 0, thiết kế cho ra chỉ số 0, mức 0,
`alarm_valid=0`. Cần xác nhận cách xử lý trạng thái im lặng này có đúng
yêu cầu giảng viên không.

------------------------------------------------------------------------

## 5. Các vector kiểm thử tham khảo

Mỗi kênh chiếm 2 bit, theo thứ tự `sev3 sev2 sev1 sev0` khi viết toàn bộ
`ui_in`.

  ----------------------------------------------------------------------------------
  Mục đích          `ui_in`           Mức kênh                     Kết quả
                                      `(sev0, sev1, sev2, sev3)`   `uo_out[4:0]`
  ----------------- ----------------- ---------------------------- -----------------
  Tất cả im lặng    `8'b00000000`     `(0,0,0,0)`                  `5'b00000`

  Chỉ kênh 2 mức 2  `8'b00100000`     `(0,0,2,0)`                  `5'b11010`

  Kênh 0 và 2 cùng  `8'b00110011`     `(3,0,3,0)`                  `5'b11100`
  mức 3                                                            

  Mức lần lượt      `8'b11100100`     `(0,1,2,3)`                  `5'b11111`
  0,1,2,3                                                          
  ----------------------------------------------------------------------------------

Lưu ý: trong bảng, kết quả 5 bit được trình bày theo thứ tự `[4:0]` =
`{valid, severity[1:0], index[1:0]}`. Phải kiểm tra testbench thực tế và
điều chỉnh nếu quy ước đề bài khác.

### Yêu cầu với testbench

Testbench nên: 1. Khởi tạo đầu vào. 2. Thay đổi `ui_in` cho từng ca. 3.
Chờ đủ thời gian cho logic tổ hợp ổn định. 4. So sánh các bit đầu ra
mong đợi với `uo_out`. 5. In `PASS` chỉ khi toàn bộ kiểm tra đúng; có
lỗi thì phát `FAIL` hoặc `$fatal`. 6. Bao gồm các trường hợp hòa ở mọi
vị trí có ý nghĩa, không chỉ một trường hợp.

**Không nên chỉ dùng `grep PASS` để xác định test thành công** nếu
testbench không kiểm tra kết quả kỳ vọng. Cần đảm bảo lỗi cũng làm tiến
trình mô phỏng trả mã lỗi khác 0.

------------------------------------------------------------------------

## 6. Tạo cấu trúc file trong repo

Có hai hướng khác nhau. **Không trộn cấu trúc của hai template nếu chưa
điều chỉnh workflow.**

### Hướng A --- theo template của lớp

Trước tiên, kiểm tra hướng dẫn môn học. Nếu template yêu cầu
`src/project.v`, `test/tb.v`, `docs/info.md`, `info.yaml` hoặc cấu trúc
khác, giữ đúng cấu trúc đó. Không tự đổi tên top module và cổng.

Quy trình thường gặp theo hướng dẫn đã được trao đổi: 1. Tạo repo từ
template lớp qua **Use this template → Create a new repository**. 2. Sửa
RTL ở đường dẫn mà template yêu cầu. 3. Sửa testbench ở đường dẫn mà
template yêu cầu. 4. Cập nhật metadata/tài liệu theo yêu cầu môn học. 5.
Commit/push. 6. Xem GitHub Actions và tải artifact. 7. Phân tích layout,
metrics và timing; viết báo cáo.

Nếu đã tạo repo trống, có thể cần chép các file template vào repo hoặc
tạo repo khác từ template. Không giả định repo trống đã có sẵn cấu hình
của template.

### Hướng B --- workflow tùy chỉnh được người học gửi

Workflow tùy chỉnh trước đây có: - Trigger: `push`, `pull_request`,
`workflow_dispatch`. - Job `mo-phong`: cài Icarus Verilog, chạy
`iverilog -g2012 -o sim.vvp rtl/*.sv tb/*.sv`, chạy `vvp sim.vvp`, kiểm
tra lỗi/PASS và upload log/waveform. - Job `rtl2gds`: chờ job mô phỏng;
cài Nix, lấy LibreLane, chạy `librelane config.json`, kiểm tra
GDS/metrics, chạy `.github/doc_metrics.py`, upload artifact.

Workflow đó đang mong đợi tối thiểu các đường dẫn: - `rtl/*.sv` -
`tb/*.sv` - `config.json` - `.github/doc_metrics.py`

Nếu dùng workflow tùy chỉnh, phải tạo đúng các file này **và bảo đảm cú
pháp cấu hình LibreLane phù hợp với phiên bản đã cài**. Không thể bảo
đảm workflow chạy chỉ bằng cách đổi ba biến `MA_DE`, `DESIGN_NAME`,
`CONFIG`.

Tên workflow được đề xuất: `.github/workflows/rtl2gds.yml`

Các biến đã được nhắc trong workflow: - `MA_DE: A01` --- cần xác nhận mã
đề thật theo lớp. - `DESIGN_NAME: a01_ripple_adder` --- đây là tên cũ
của thiết kế ripple adder, phải đổi thành tên phù hợp với dự án, ví dụ
`four_channel_priority_alarm`, nếu cấu hình và công cụ cho phép. -
`CONFIG: config.json` --- chỉ hợp lệ nếu file đó tồn tại và đúng định
dạng LibreLane.

**Không dùng nguyên workflow chưa kiểm tra**: đường dẫn
source/testbench, tên top module, định dạng config, lệnh CLI LibreLane
và script metrics có thể khác nhau giữa các phiên bản/template.

------------------------------------------------------------------------

## 7. Các bước cần làm từ trạng thái hiện tại đến cuối

### Bước 1 --- Hoàn thiện repo

Repo hiện có: `https://github.com/Diello287/four-channel-priority-alarm`

Hiện trạng được xác nhận lần cuối: repo Public, chỉ có `README.md`. Chưa
có CI run được xác nhận.

### Bước 2 --- Chọn cấu trúc

-   Ưu tiên template chính thức của lớp nếu giảng viên cung cấp.
-   Nếu bắt buộc tự tạo workflow, chọn Hướng B và chuẩn bị đủ file đầu
    vào.
-   Xác định chính xác top module, PDK, config, mã đề và lệnh chạy theo
    template.

### Bước 3 --- Thêm RTL

-   Đặt RTL vào đúng thư mục mà flow yêu cầu.
-   Giữ giao diện module phù hợp.
-   Kiểm tra thứ tự bit và tie-break.
-   Kiểm tra lint/syntax trước khi chạy flow đầy đủ nếu có thể.

### Bước 4 --- Thêm testbench

-   Bao phủ 4 trường hợp bắt buộc.
-   Thêm nhiều ca hòa để xác nhận kênh chỉ số nhỏ thắng.
-   Thêm ca mỗi kênh lần lượt là kênh ưu tiên.
-   Đảm bảo test fail thật sự khi đầu ra sai.

### Bước 5 --- Cấu hình LibreLane/PDK

-   Xác nhận phiên bản LibreLane và PDK mà lớp yêu cầu.
-   Chuẩn bị `config.json` theo cấu hình đúng của flow; không đoán các
    khóa cấu hình.
-   Xác nhận top module, nguồn RTL, clock (nếu dùng), die/core area và
    các thông số bắt buộc.
-   Kiểm tra xem flow có cần GitHub secrets hoặc quyền đặc biệt không;
    không đăng token/mật khẩu vào repo.

### Bước 6 --- Thêm GitHub Actions workflow

-   Tạo `.github/workflows/rtl2gds.yml`.
-   Kiểm tra YAML thụt lề và tên file.
-   Kiểm tra các đường dẫn nguồn/test/config/script khớp repo.
-   Commit changes.

### Bước 7 --- Chạy CI

1.  Mở tab **Actions** trong repo.
2.  Chọn workflow `RTL to GDSII`.
3.  Mở lần chạy mới nhất.
4.  Nếu đỏ, mở job bị lỗi và đọc log từ dòng lỗi đầu tiên; sửa nguyên
    nhân rồi commit/push lại.
5.  Nếu xanh, vẫn kiểm tra artifact và nội dung báo cáo.

Link trang Actions của repo:
https://github.com/Diello287/four-channel-priority-alarm/actions

Link CI run cụ thể chỉ xuất hiện sau khi workflow thực sự chạy. Không
dùng một URL có ID giả.

### Bước 8 --- Kiểm tra artifact

Tìm các artifact do workflow upload, có thể gồm: - Log mô phỏng. - Tool
versions. - Waveform `.vcd`. - GDSII. - Metrics/report. - Log của flow
vật lý.

Tên và sự có mặt của artifact phụ thuộc workflow thật sự chạy thành công
đến đâu. Tải về và xác minh file không rỗng; không coi việc artifact tồn
tại là bằng chứng đầy đủ rằng thiết kế đúng.

### Bước 9 --- Phân tích kết quả

Ghi lại: - Kết quả từng testbench. - Số cell/diện tích theo báo cáo tổng
hợp. - Kết quả timing, critical path và slack nếu có. - Kết quả DRC/LVS
nếu flow hỗ trợ và đã chạy. - Tên file GDSII cuối cùng. - Phiên bản công
cụ/PDK.

Không bịa số liệu. Lấy con số từ log/report thật của CI.

### Bước 10 --- Viết báo cáo

Theo cấu trúc và mẫu giảng viên cung cấp. Báo cáo nên nêu: - Mục tiêu và
đặc tả. - Cách thiết kế RTL. - Cách test và các ca kiểm thử. - Quy trình
RTL → GDSII. - Ảnh/sơ đồ waveform hoặc layout, kèm chú thích. - Metrics,
timing và nhận xét dựa trên report thực tế. - Hạn chế và kết luận.

#### Phân tích critical path cho mục 8

RTL tham khảo đang dùng chuỗi so sánh/cập nhật: 1. So sánh kênh 1 với
giá trị tốt nhất hiện tại. 2. So sánh kênh 2 với giá trị tốt nhất hiện
tại. 3. So sánh kênh 3 với giá trị tốt nhất hiện tại.

Vì vậy có **3 tầng so sánh/cập nhật theo cách nhìn thuật toán** cho 4
kênh. Nếu mở rộng thành 8 kênh theo cùng cấu trúc chuỗi, sẽ có 7 tầng,
tức thêm 4 tầng; tỷ lệ số tầng là `7/3 ≈ 2,33`. Đây chỉ là ước lượng
logic; độ trễ thực tế phải lấy từ tổng hợp và STA vì tối ưu hóa, fanout,
dây nối và cell có thể thay đổi kết quả.

### Bước 11 --- Chuẩn bị link nộp

Thông thường có thể cần: - Link repository:
`https://github.com/Diello287/four-channel-priority-alarm` - Link CI run
cụ thể từ tab Actions. - Artifact GDSII/report nếu yêu cầu. - Báo cáo
cuối cùng.

Xác nhận yêu cầu nộp bài của giảng viên để biết phải nộp link repo, link
Actions, file GDS hay tất cả.

------------------------------------------------------------------------

## 8. Cách lấy link CI

1.  Mở
    `https://github.com/Diello287/four-channel-priority-alarm/actions`.
2.  Chọn workflow và lần chạy mong muốn.
3.  Sao chép URL trên thanh địa chỉ.
4.  Mở link trong cửa sổ riêng tư hoặc tài khoản khác để kiểm tra quyền
    xem.
5.  Nếu repo public, link thường xem được công khai. Nếu repo private,
    người xem phải có quyền truy cập.

Không thể cung cấp link CI run thực tế trước khi workflow được commit và
chạy.

------------------------------------------------------------------------

## 9. Lỗi thường gặp

-   **Không thấy tab Actions có lần chạy:** workflow chưa được
    thêm/commit, workflow không được kích hoạt, hoặc YAML không hợp lệ.
-   **Không tìm thấy `rtl/*.sv` hoặc `tb/*.sv`:** workflow đang dùng
    đường dẫn không khớp cấu trúc repo.
-   **Không tìm thấy `config.json`:** thiếu cấu hình hoặc biến `CONFIG`
    sai.
-   **Không tìm thấy `.github/doc_metrics.py`:** script bị thiếu.
-   **Mô phỏng in PASS nhưng kết quả sai:** testbench không kiểm tra kỳ
    vọng đầy đủ.
-   **LibreLane lỗi:** đọc log, xác nhận cấu hình, phiên bản công cụ,
    PDK và top module.
-   **Không có GDS:** flow có thể dừng trước bước xuất layout; cần sửa
    lỗi đầu tiên trong log.
-   **CI xanh nhưng không chắc thiết kế đúng:** xem log test, waveform,
    metrics và các báo cáo thật.

------------------------------------------------------------------------

## 10. Hướng dẫn cho ChatGPT ở tài khoản mới

Hãy upload file này và gửi yêu cầu:

> Đây là hồ sơ bàn giao dự án môn nhập môn thiết kế vi mạch tích hợp của
> tôi. Hãy đọc kỹ và tiếp tục hướng dẫn tôi bằng tiếng Việt, từng bước
> một, không bỏ qua thao tác trên GitHub. Repo hiện tại là
> https://github.com/Diello287/four-channel-priority-alarm, mới có
> README.md theo trạng thái gần nhất. Đề tài là Bộ cảnh báo bốn kênh có
> mức ưu tiên. Hãy giúp tôi xác nhận cấu trúc dự án, chuẩn bị
> RTL/testbench/config/workflow đúng với template thực tế, chạy CI,
> debug lỗi, kiểm tra artifact GDSII và viết báo cáo. Không được giả
> định workflow hoặc CI đã chạy thành công; hãy yêu cầu tôi cung cấp
> file/log/ảnh cần thiết và không bịa số liệu.

### Việc tiếp theo cần làm ngay

1.  Mở repo GitHub.
2.  Xác nhận xem giảng viên có template bắt buộc không.
3.  Nếu có template, lấy đúng template trước khi hoàn thiện CI. Nếu
    không có, chuẩn bị cấu trúc tùy chỉnh và xác nhận cấu hình LibreLane
    trước.
4.  Chỉ sau đó mới commit workflow và chạy CI.
