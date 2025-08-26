<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chờ Phê Duyệt - G5 SmartTutor</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .approval-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            padding: 3rem;
            margin-top: 5rem;
            text-align: center;
        }
        .success-icon {
            font-size: 4rem;
            color: #28a745;
            margin-bottom: 1.5rem;
        }
        .approval-title {
            color: #2c3e50;
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        .approval-message {
            color: #7f8c8d;
            font-size: 1.2rem;
            line-height: 1.6;
            margin-bottom: 2rem;
        }
        .info-box {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 1.5rem;
            margin: 1.5rem 0;
            border-left: 5px solid #007bff;
        }
        .btn-home {
            background: linear-gradient(45deg, #007bff, #0056b3);
            border: none;
            border-radius: 25px;
            padding: 12px 30px;
            font-size: 1.1rem;
            font-weight: 600;
            color: white;
            text-decoration: none;
            display: inline-block;
            margin-top: 1rem;
            transition: all 0.3s ease;
        }
        .btn-home:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0, 123, 255, 0.3);
            color: white;
            text-decoration: none;
        }
        .steps {
            text-align: left;
            margin: 2rem 0;
        }
        .step {
            display: flex;
            align-items: center;
            margin: 1rem 0;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 10px;
        }
        .step-number {
            background: #007bff;
            color: white;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 1rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="approval-card">
                    <div class="success-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    
                    <h1 class="approval-title">Đăng Ký Thành Công!</h1>
                    
                    <p class="approval-message">
                        Chúc mừng! Bạn đã đăng ký trở thành gia sư thành công. 
                        Hồ sơ của bạn đang được xem xét và phê duyệt.
                    </p>
                    
                    <div class="info-box">
                        <h5><i class="fas fa-info-circle text-primary"></i> Trạng Thái Hiện Tại</h5>
                        <p class="mb-0">
                            <strong>Trạng thái:</strong> 
                            <span class="badge bg-warning text-dark">Chờ Phê Duyệt</span>
                        </p>
                    </div>
                    
                    <div class="steps">
                        <h5><i class="fas fa-list-ol text-primary"></i> Quy Trình Tiếp Theo</h5>
                        
                        <div class="step">
                            <div class="step-number">1</div>
                            <div>
                                <strong>Xem xét hồ sơ</strong><br>
                                <small class="text-muted">Admin sẽ xem xét CV và thông tin của bạn</small>
                            </div>
                        </div>
                        
                        <div class="step">
                            <div class="step-number">2</div>
                            <div>
                                <strong>Phê duyệt</strong><br>
                                <small class="text-muted">Hồ sơ sẽ được phê duyệt trong 1-3 ngày làm việc</small>
                            </div>
                        </div>
                        
                        <div class="step">
                            <div class="step-number">3</div>
                            <div>
                                <strong>Kích hoạt tài khoản</strong><br>
                                <small class="text-muted">Bạn sẽ nhận được email thông báo kết quả</small>
                            </div>
                        </div>
                    </div>
                    
                    <div class="info-box">
                        <h6><i class="fas fa-envelope text-primary"></i> Lưu Ý</h6>
                        <ul class="mb-0 text-start">
                            <li>Vui lòng kiểm tra email thường xuyên</li>
                            <li>Đảm bảo thông tin trong CV là chính xác</li>
                            <li>Liên hệ admin nếu có thắc mắc</li>
                        </ul>
                    </div>
                    
                    <a href="${pageContext.request.contextPath}/" class="btn-home">
                        <i class="fas fa-home"></i> Về Trang Chủ
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
