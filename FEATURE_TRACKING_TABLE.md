# 📋 SWP391_E_G5_TutorManagement - FEATURE TRACKING TABLE

## 🎯 DETAILED FEATURE BREAKDOWN

| # | Feature ID | Feature Category | Screen/Function | Screen/Function Details | Complexity | Bug Status | Mark | Comments | LOC | PIC | Planned Iteration |
|---|------------|------------------|-----------------|-------------------------|------------|------------|------|----------|-----|-----|-------------------|
| **COMMON FEATURES** |
| 1 | F_01 | Common | User Login | Enter email/password, "Forgot Password" option, login via Google | Level 1 | ✅ | Program: ✅<br>Doc: ✅ | Login system implemented with session management | 60 | HuyPD | ITER1 |
| 2 | F_02 | Common | Reset Password | Enter email for reset link, set new password after email verification | Level 1 | ✅ | Program: ✅<br>Doc: ✅ | Email verification working | 60 | HuyPD | ITER1 |
| 3 | F_03 | Common | User Register | Enter personal info, email verification, success notification | Level 1 | ✅ | Program: ✅<br>Doc: ✅ | Both student and tutor registration | 60 | HuyPD | ITER1 |
| 4 | F_04 | Common | Home Page | Display featured tutors, popular subjects, and login/register button | Level 2 | ✅ | Program: ✅<br>Doc: ✅ | Responsive design implemented | 90 | HuyPD | ITER1 |
| 5 | F_05 | Common | User Authorization | Role-based access (User, Tutor, Staff, Admin), navigate accordingly | Level 2 | ✅ | Program: ✅<br>Doc: ✅ | Filter system implemented | 90 | NamLV | ITER3 |
| **TUTOR MANAGEMENT** |
| 6 | F_06 | Tutor Management | Tutor List | Display detailed tutor list | Level 2 | ✅ | Program: ✅<br>Doc: ✅ | Search and filter functionality | 90 | NamLV | ITER1 |
| 7 | F_07 | Tutor Management | Add/Update/View Tutor Detail | Manage tutor profiles and information | Level 2 | ✅ | Program: ✅<br>Doc: ✅ | CRUD operations for tutors | 90 | NamLV | ITER2 |
| **USER MANAGEMENT** |
| 8 | F_08 | User Management | User Profile | View and edit personal information | Level 1 | ✅ | Program: ✅<br>Doc: ⚠️ | Basic profile management | - | - | ITER1 |
| 9 | F_09 | User Management | Add/Update/View User Detail | Admin function for user management | Level 2 | ✅ | Program: ✅<br>Doc: ⚠️ | Admin can manage all users | - | - | ITER2 |
| **CV MANAGEMENT** |
| 10 | F_10 | CV Management | View CV | Tutors create teaching schedules | Level 2 | ✅ | Program: ✅<br>Doc: ✅ | CV display with qualifications | 90 | HuyPD | ITER2 |
| 11 | F_11 | CV Management | Edit CV | Tutor edit and update CV | Level 2 | ✅ | Program: ✅<br>Doc: ✅ | Full CV editing capabilities | 90 | Pham Duc | ITER2 |
| 12 | F_12 | CV Management | Add/Update/Create Schedule | Admin review and approve tutor profiles | Level 1 | ✅ | Program: ✅<br>Doc: ✅ | Staff CV review system | 60 | Pham Duc | ITER3 |
| **SCHEDULE MANAGEMENT** |
| 13 | F_13 | Schedule Management | View Schedule | Admin manages tutors, users, staff info, deactivate accounts | Level 3 | ✅ | Program: ✅<br>Doc: ✅ | Calendar-based interface | 150 | HuyPD | ITER3 |
| 14 | F_14 | Schedule Management | Book Schedule | Select and book a tutor's schedule | Level 3 | ✅ | Program: ✅<br>Doc: ✅ | Real-time booking system | 120 | NamLV | ITER2 |
| **BLOG MANAGEMENT** |
| 15 | F_15 | Blog Management | Blog | Display learning and skill-related | Level 2 | ✅ | Program: ✅<br>Doc: ✅ | Content management system | 90 | NamLV | ITER2 |
| 16 | F_16 | Blog Management | Add/Update/View Blog Detail | Track and approve lesson status | Level 2 | ✅ | Program: ✅<br>Doc: ✅ | Full blog CRUD operations | 90 | NamLV | ITER3 |
| **PAYMENT MANAGEMENT** |
| 17 | F_17 | Payment Management | View History Payment | Users' transaction/payment history | Level 2 | 🔄 | Program: 🔄<br>Doc: ✅ | Basic structure implemented | 90 | HuyPD | ITER3 |
| 18 | F_18 | Payment Management | History Log | Store user/tutor/staff activity history | Level 2 | ✅ | Program: ✅<br>Doc: ✅ | Activity tracking system | 90 | Pham Duc | ITER2 |
| 19 | F_19 | Payment Management | Payment Booking | Pay via VNPay | Level 2 | 🔄 | Program: 🔄<br>Doc: ✅ | VNPay integration in progress | 60 | Pham Duc | ITER3 |
| **REPORT MANAGEMENT** |
| 20 | F_20 | Report Management | View Reports | Admin view user reports | Level 1 | ✅ | Program: ✅<br>Doc: ✅ | Basic reporting dashboard | 90 | Pham Duc | ITER1 |
| 21 | F_21 | Report Management | Report | View user/tutor/staff count, transactions, system earnings, history log | Level 2 | 🔄 | Program: 🔄<br>Doc: ⚠️ | Advanced analytics pending | - | Pham Duc | ITER3 |

---

## 📊 IMPLEMENTATION STATISTICS

### **By Complexity Level:**
- **Level 1 (Simple)**: 6 features → 390 LOC
- **Level 2 (Medium)**: 13 features → 1,170 LOC  
- **Level 3 (Complex)**: 2 features → 270 LOC

### **By Status:**
- **✅ Completed**: 18 features (85.7%)
- **🔄 In Progress**: 3 features (14.3%)
- **❌ Not Started**: 0 features (0%)

### **By Team Member:**
- **HuyPD**: 6 features (28.6%)
- **NamLV**: 5 features (23.8%)
- **Pham Duc**: 6 features (28.6%)
- **Unassigned**: 4 features (19.0%)

### **By Iteration:**
- **ITER1**: 6 features (Foundation)
- **ITER2**: 8 features (Core Features)
- **ITER3**: 7 features (Advanced Features)

---

## 🎯 QUALITY METRICS

### **Programming Completion:**
- Fully implemented: 18/21 (85.7%)
- In progress: 3/21 (14.3%)

### **Documentation Status:**
- Complete documentation: 17/21 (81.0%)
- Partial documentation: 2/21 (9.5%)
- Missing documentation: 2/21 (9.5%)

### **Testing Coverage:**
- Unit tests: Needs implementation
- Integration tests: Basic coverage
- User acceptance: Manual testing completed

---

## 🚀 CURRENT PRIORITIES

### **HIGH PRIORITY (ITER3 Completion):**
1. **F_19**: Complete VNPay payment integration
2. **F_17**: Finalize payment history functionality
3. **F_21**: Implement advanced reporting features

### **MEDIUM PRIORITY (Quality Improvement):**
1. Complete missing documentation
2. Implement comprehensive error handling
3. Add input validation across all forms

### **LOW PRIORITY (Future Enhancements):**
1. Mobile responsive optimization
2. Performance tuning
3. Advanced search features
4. Real-time notifications

---

## 🔍 RISK ASSESSMENT

### **Technical Risks:**
- Payment integration complexity
- Database performance with increased load
- Security vulnerabilities in user input

### **Project Risks:**
- Timeline pressure for ITER3 completion
- Integration testing complexity
- Deployment and production readiness

### **Mitigation Strategies:**
- Incremental testing approach
- Code review process
- Documentation updates
- Performance monitoring

---

*Last Updated: December 2024*  
*Project Status: ITER3 - 85.7% Complete*  
*Next Review: Weekly team meeting*





