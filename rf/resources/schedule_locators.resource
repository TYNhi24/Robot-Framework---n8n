*** Variables ***
# Links
${LNK_TKB_GV}         xpath://a[contains(text(),'THỜI KHÓA BIỂU GIẢNG VIÊN')]

# Inputs
${INPUT_YEAR}         xpath://label[text()='Năm học']/following-sibling::div//input
${INPUT_SEMESTER}     xpath://label[text()='Học kỳ']/following-sibling::div//input
${INPUT_FACULTY}      xpath://label[text()='Khoa']/following-sibling::div//input
${INPUT_LECTURER_ID}  xpath://label[contains(text(),'Mã GV')]/following-sibling::div//input

# Buttons
${BTN_FILTER}         xpath://button[contains(., 'Lọc')]
${BTN_REFRESH}        xpath://button[contains(., 'Làm mới')]

# Assertions
${TABLE_SCHEDULE}     xpath://table[contains(@class, 'schedule-table')]
${LBL_RESULT_HEADER}  xpath://div[contains(@class, 'schedule-header-section')]
${CELL_NO_SCHEDULE}     xpath://td[contains(text(), 'Chưa có lịch học')]
