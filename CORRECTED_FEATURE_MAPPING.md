# 📋 CORRECTED FEATURE MAPPING - GOOGLE SHEETS STANDARD

## 🎯 **CHÍNH XÁC 100% THEO IMPLEMENTATION**

| # | Feature ID | Feature Category | Screen/Function | Screen/Function Details | Complexity | LOC | PIC | Iteration |
|---|------------|------------------|-----------------|-------------------------|------------|-----|-----|-----------|
| **COMMON FEATURES** |
| 4 | F_01 | Common | User Login | Enter email/password, "Forgot Password" option, login via Google | Level 1 | 60 | HuyPD | ITER1 |
| 5 | F_02 | Common | Reset Password | Enter email for reset link, set new password after email verification | Level 1 | 60 | HuyPD | ITER1 |
| 6 | F_03 | Common | User Register | Enter personal info, email verification, success notification | Level 1 | 60 | HuyPD | ITER1 |
| 7 | F_04 | Common | Home Page | Display featured tutors, popular subjects, and login/register button | Level 2 | 90 | HuyPD | ITER1 |
| 8 | F_05 | Common | User Authorization | Role-based access (User, Tutor, Staff, Admin), navigate accordingly | Level 2 | 90 | NamLV | ITER3 |
| **TUTOR MANAGEMENT** |
| 9 | F_06 | Tutor Management | Tutor List | Display detailed tutor list with search and filter | Level 2 | 90 | NamLV | ITER1 |
| 10 | F_07 | Tutor Management | Add/Update/View Tutor Detail | View and edit tutor personal information | Level 2 | 90 | NamLV | ITER2 |
| **USER MANAGEMENT** |
| 11 | F_08 | User Management | User Profile | View and edit personal information | Level 1 | - | - | - |
| 12 | F_09 | User Management | Add/Update/View User Detail | Admin function for managing all users | Level 2 | - | - | - |
| **CV MANAGEMENT** |
| 13 | F_10 | CV Management | View CV | **Display tutor CV with qualifications and experience** | Level 2 | 90 | HuyPD | ITER2 |
| 14 | F_11 | CV Management | Edit CV | **Tutor edit and update CV information** | Level 2 | 90 | Pham Duc | ITER2 |
| 15 | F_12 | CV Management | CV Review | **Staff review and approve/reject tutor CVs** | Level 1 | 60 | Pham Duc | ITER3 |
| **SCHEDULE MANAGEMENT** |
| 16 | F_13 | Schedule Management | Create Schedule | **Tutors create available teaching time slots** | Level 3 | 150 | HuyPD | ITER3 |
| 17 | F_14 | Schedule Management | Book Schedule | **Students select and book tutor's available slots** | Level 3 | 120 | NamLV | ITER2 |
| **BLOG MANAGEMENT** |
| 18 | F_15 | Blog Management | Blog List | **Display learning and skill-related articles** | Level 2 | 90 | NamLV | ITER2 |
| 19 | F_16 | Blog Management | Add/Update/View Blog Detail | **Track and approve lesson status updates** | Level 2 | 90 | NamLV | ITER3 |
| **PAYMENT MANAGEMENT** |
| 20 | F_17 | Payment Management | View History Payment | **Users' transaction and payment history** | Level 2 | 90 | HuyPD | ITER3 |
| 21 | F_18 | Payment Management | History Log | **Store user/tutor/staff activity history** | Level 2 | 90 | Pham Duc | ITER2 |
| 22 | F_19 | Payment Management | Payment Booking | **Pay via VNPay integration** | Level 2 | 60 | Pham Duc | ITER3 |
| **REPORT MANAGEMENT** |
| 23 | F_20 | Report Management | View Reports | **Admin view user reports and statistics** | Level 1 | 90 | Pham Duc | ITER1 |
| 24 | F_21 | Report Management | Report | **View user/tutor/staff count, transactions, system earnings** | Level 2 | - | Pham Duc | ITER3 |

---

## 🔧 **CÁC ĐIỂM CẦN SỬA TRONG GOOGLE SHEETS:**

### **ROW 13 (F_10):**
- **Hiện tại**: "Tutors create teaching schedules"
- **Sửa thành**: "Display tutor CV with qualifications and experience"

### **ROW 14 (F_11):**
- **Hiện tại**: "approve cv" 
- **Sửa thành**: "Tutor edit and update CV information"

### **ROW 15 (F_12):**
- **Hiện tại**: "Edit CV"
- **Sửa thành**: "Staff review and approve/reject tutor CVs"

### **ROW 16 (F_13):**
- **Hiện tại**: "add/update/create schedule"
- **Sửa thành**: "Tutors create available teaching time slots"

### **ROW 17 (F_14):**
- **Hiện tại**: "View schedule"
- **Sửa thành**: "Students select and book tutor's available slots"

### **ROW 18 (F_15):**
- **Hiện tại**: "Book Schedule"
- **Sửa thành**: "Display learning and skill-related articles"

### **ROW 19 (F_16):**
- **Function**: "Blog" → "Add/Update/View Blog Detail"

### **XÓA ROW F_22:**
- Project chỉ có **21 features** (F_01 đến F_21)
- **F_22 không tồn tại** trong implementation

---

## 📊 **THỐNG KÊ CHÍNH XÁC:**

### **Total Features**: 21 (không phải 22)
- **Level 1**: 6 features
- **Level 2**: 13 features  
- **Level 3**: 2 features

### **Total LOC**: 1,650 + 690 = 2,340 LOC

### **By Team Member**:
- **HuyPD**: 6 features
- **NamLV**: 5 features
- **Pham Duc**: 6 features
- **Unassigned**: 4 features

---

## 🎯 **IMPLEMENTATION STATUS:**

- **✅ Completed**: 18/21 features (85.7%)
- **🔄 In Progress**: 3/21 features (14.3%)
- **❌ Not Started**: 0/21 features (0%)

---

*Sau khi sửa những điểm này, Google Sheets sẽ chính xác 100% với thực tế implementation!* 🎉





