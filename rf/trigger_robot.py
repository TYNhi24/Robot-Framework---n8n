from flask import Flask
import subprocess
import os
import logging
import pandas as pd

# Thiết lập hệ thống ghi Log để theo dõi quá trình chạy trên Console
logging.basicConfig(level=logging.INFO)
log = logging.getLogger(__name__)

app = Flask(__name__)

# --- CẤU HÌNH ĐƯỜNG DẪN (Nên dùng đường dẫn tuyệt đối để tránh lỗi) ---
SHARED_FOLDER = r"C:\n8n_robot_share"  # Thư mục n8n dùng để gửi file Excel qua
FILE_NAME = "TCQNU.xlsx"             # Tên file Excel chứa kịch bản test
FILE_TO_PROCESS = os.path.join(SHARED_FOLDER, FILE_NAME)

# Đường dẫn đến file .robot và thư mục lưu kết quả
ROBOT_SCRIPT_PATH = r"E:\n8nRobot\automation\rf\tests\GenericEngine.robot" 
RESULTS_DIR = r"E:\n8nRobot\automation\rf\ketqua"
TEMP_XML_DIR = os.path.join(RESULTS_DIR, "temp_xml") # Nơi chứa các file XML tạm thời của từng sheet

# Tự động tạo thư mục nếu chưa tồn tại để tránh lỗi Permission/Not Found
for path in [RESULTS_DIR, TEMP_XML_DIR]:
    if not os.path.exists(path):
        os.makedirs(path)

# Định nghĩa API Endpoint để n8n gọi vào qua phương thức POST
@app.route('/run-robot', methods=['POST'])
def run_robot_trigger():
    log.info(">>> Đã nhận tín hiệu từ n8n. Bắt đầu quy trình chạy đa Sheet...")
    
    # Kiểm tra file Excel: Nếu n8n chưa kịp gửi file, trả về lỗi ngay để workflow n8n dừng lại
    if not os.path.exists(FILE_TO_PROCESS):
        log.error(f"XXX LỖI: Không tìm thấy file Excel tại: {FILE_TO_PROCESS}")
        return "Error: Excel file not found", 404 

    try:
        # 1. Sử dụng thư viện Pandas để đọc danh sách tất cả các tên Sheet có trong file Excel
        sheets = pd.ExcelFile(FILE_TO_PROCESS).sheet_names
        log.info(f"Tìm thấy {len(sheets)} sheets: {sheets}")

        output_files = []   # Danh sách lưu đường dẫn các file xml sau khi chạy xong mỗi sheet
        overall_fail = False # Biến cờ (flag) để kiểm tra xem tổng thể có sheet nào bị lỗi không

        # 2. Vòng lặp: Duyệt qua từng Sheet để thực thi kiểm thử
        for sheet in sheets:
            log.info(f"--- Đang thực thi Sheet: {sheet} ---")
            output_xml = os.path.join(TEMP_XML_DIR, f"output_{sheet}.xml")
            output_files.append(output_xml)
            
            # Cấu hình câu lệnh Robot Framework:
            # -v: Truyền biến SHEET_NAME vào file Robot để nạp dữ liệu đúng sheet
            # -N: Đặt tên Suite trong báo cáo theo tên Sheet cho dễ phân biệt
            # -o: Xuất kết quả ra file XML riêng lẻ để tí nữa gộp (rebot)
            # --report/--log NONE: Tắt xuất file HTML lẻ để tránh lộn xộn thư mục
            cmd = [
                "robot",
                "-v", f"SHEET_NAME:{sheet}",
                "-N", sheet,
                "-o", output_xml,
                "-d", RESULTS_DIR,
                "--report", "NONE",
                "--log", "NONE",
                ROBOT_SCRIPT_PATH
            ]
            
            # Thực thi lệnh Robot: 
            # check=False: Quan trọng! Để script không bị dừng đột ngột khi 1 test case bị Fail
            # shell=True: Cần thiết để Windows nhận diện được lệnh 'robot'
            result = subprocess.run(cmd, check=False, shell=True) 
            
            # Ghi nhận mã thoát (Exit code): 0 là Thành công, khác 0 là có Test Fail
            log.info(f">>> Sheet [{sheet}] kết thúc với mã thoát: {result.returncode}")
            if result.returncode != 0:
                overall_fail = True

        # 3. Sử dụng công cụ REBOT để gộp tất cả các file XML lẻ thành một báo cáo duy nhất
        log.info("--- Đang tổng hợp báo cáo cuối cùng bằng Rebot ---")
        final_log_path = os.path.abspath(os.path.join(RESULTS_DIR, "log.html"))
        
        rebot_cmd = [
            "rebot",
            "-N", "QNU Automation Project", # Tên hiển thị lớn nhất trên báo cáo
            "-d", RESULTS_DIR,              # Thư mục xuất báo cáo cuối cùng
            "-o", "output.xml",              # File XML tổng hợp
            *output_files                   # Giải nén danh sách các file xml lẻ vào lệnh
        ]
        subprocess.run(rebot_cmd, check=False, shell=True)

        # 4. Kiểm tra nếu báo cáo tổng hợp đã được tạo thành công
        if os.path.exists(final_log_path):
            log.info(f"--- Hoàn tất! Đang mở báo cáo tại: {final_log_path} ---")
            os.startfile(final_log_path) # Tự động mở trình duyệt hiển thị Log
            
            # Trả về mã 200 cho n8n để xác nhận Workflow đã chạy xong "thành công" về mặt kỹ thuật
            msg = "Tests finished with some failures" if overall_fail else "All tests passed"
            return f"{msg}. Log opened.", 200
        else:
            return "Rebot failed to generate log", 500
        
    except Exception as e:
        # Bắt các lỗi ngoại lệ (ví dụ: file Excel đang bị mở, lỗi thư viện...)
        log.error(f"XXX Lỗi hệ thống: {e}")
        return f"System Error: {e}", 500

if __name__ == '__main__':
    # Chạy Flask Server trên cổng 5000, host 0.0.0.0 cho phép truy cập từ mạng nội bộ
    log.info("--- Server Flask đang lắng nghe tại cổng 5000 ---")
    app.run(host='0.0.0.0', port=5000)