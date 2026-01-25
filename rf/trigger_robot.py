from flask import Flask
import subprocess
import os
import logging

# Thiết lập logging
logging.basicConfig(level=logging.INFO)
log = logging.getLogger(__name__)

app = Flask(__name__)

# --- Cấu hình của bạn ---

# 1. Đường dẫn CHÍNH XÁC đến thư mục chia sẻ
SHARED_FOLDER = r"C:\n8n_robot_share"

# 2. Tên file Excel mà n8n sẽ lưu (bạn phải đặt tên này trong node n8n)
# !! QUAN TRỌNG: Tên này phải khớp với tên bạn đặt trong node "Read/Write Files"
FILE_NAME = "nopcommerce.xlsx"

# 3. Đường dẫn CHÍNH XÁC đến file robot của bạn
# !! QUAN TRỌNG: Hãy thay đổi đường dẫn này cho đúng
ROBOT_SCRIPT_PATH = r"E:\n8nRobot\automation\rf\tests\seacrhNopcommerce.robot" 


# --- Hết cấu hình ---

# Ghép đường dẫn đầy đủ đến file Excel
FILE_TO_PROCESS = os.path.join(SHARED_FOLDER, FILE_NAME)

@app.route('/run-robot', methods=['POST'])
def run_robot_trigger():
    log.info(">>> Đã nhận tín hiệu từ n8n...")
    
    # Kiểm tra xem file Excel có thực sự tồn tại không
    if not os.path.exists(FILE_TO_PROCESS):
        log.error(f"XXX LỖI: Không tìm thấy file Excel tại: {FILE_TO_PROCESS}")
        return "Lỗi: Không tìm thấy file Excel", 500

    try:
        log.info(f"Đang thực thi robot: {ROBOT_SCRIPT_PATH}")
        log.info(f"Với file data: {FILE_TO_PROCESS}")
        
        # Lệnh để chạy Robot Framework
        # Chúng ta không cần truyền biến nữa, vì file robot đã biết file excel
        command = [
            "robot",
            ROBOT_SCRIPT_PATH
        ]
        
        # Chạy lệnh
        # 'shell=True' rất quan trọng trên Windows
        subprocess.run(command, check=True, shell=True) 
        
        log.info(">>> Đã chạy Robot Framework thành công!")
        return "Robot script executed successfully", 200
        
    except Exception as e:
        log.error(f"XXX Lỗi khi chạy Robot: {e}")
        return f"Error executing Robot script: {e}", 500

if __name__ == '__main__':
    log.info("--- Server Flask đang lắng nghe tại cổng 5000 ---")
    log.info(f"--- Sẵn sàng chạy: {ROBOT_SCRIPT_PATH} ---")
    log.info(f"--- Sẽ tìm file data tại: {FILE_TO_PROCESS} ---")
    # Chạy server, lắng nghe trên tất cả IP của máy
    app.run(host='0.0.0.0', port=5000)