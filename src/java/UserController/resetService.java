/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package UserController;

import java.time.LocalDateTime;
import java.util.Properties;
import java.util.UUID;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 *
 * @author Heizxje
 */
public class resetService {

    private final int LIMIT_MINUS = 10;
    static final String from = "g4.smarttutor@gmail.com";
    static final String password = "ijvk xqlx yvxp rdug";

    // Tạo token ngẫu nhiên
    public String generateToken() {
        return UUID.randomUUID().toString();
    }

    // Tính thời gian hết hạn (10 phút)
    public LocalDateTime expireDateTime() {
        return LocalDateTime.now().plusMinutes(LIMIT_MINUS);
    }

    // Kiểm tra token đã hết hạn chưa
    public boolean isExpireTime(LocalDateTime time) {
        return LocalDateTime.now().isAfter(time);
    }

    // Gửi email đặt lại mật khẩu (giữ nguyên)
    public boolean sendEmail(String to, String link, String name) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        
        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        };

        Session session = Session.getInstance(props, auth);
        
        MimeMessage msg = new MimeMessage(session);

        try {
            msg.addHeader("Content-type", "text/html; charset=UTF-8");
            msg.setFrom(from);
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
            msg.setSubject("Đặt Lại Mật Khẩu - G4-SmartTutor", "UTF-8");

            String content = "<h3>Xin chào " + name + ",</h3>"
                    + "<p>Chúng tôi đã nhận được yêu cầu đặt lại mật khẩu cho tài khoản G4-SmartTutor của bạn. "
                    + "Nếu bạn đã gửi yêu cầu này, vui lòng nhấn vào liên kết dưới đây để thiết lập mật khẩu mới:</p>"
                    + "<p><a href='" + link + "' style='color: blue; text-decoration: underline;'>Đặt Lại Mật Khẩu</a></p>"
                    + "<p>Nếu nút trên không hoạt động, bạn có thể sao chép và dán liên kết này vào trình duyệt:</p>"
                    + "<p><a href='" + link + "'>" + link + "</a></p>"
                    + "<p>Liên kết này sẽ hết hạn sau 10 phút vì lý do bảo mật. Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này.</p>"
                    + "<p>Nếu bạn cần hỗ trợ, vui lòng liên hệ với chúng tôi qua g4.smarttutor@gmail.com .</p>"
                    + "<p>Trân trọng,<br>Đội Ngũ G4-SmartTutor</p>";

            msg.setContent(content, "text/html; charset=UTF-8");
            Transport.send(msg);
            System.out.println("Send successfully");
            return true;
        } catch (Exception e) {
            System.out.println("Send error");
            System.out.println(e);
            return false;
        }
    }

    // Gửi email kích hoạt tài khoản (giữ nguyên)
    public boolean sendActivationEmail(String to, String link, String name) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        };

        Session session = Session.getInstance(props, auth);
        MimeMessage msg = new MimeMessage(session);

        try {
            msg.addHeader("Content-type", "text/html; charset=UTF-8");
            msg.setFrom(from);
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
            msg.setSubject("Kích Hoạt Tài Khoản - G4-SmartTutor", "UTF-8");

            String content = "<h3>Xin chào " + name + ",</h3>"
                    + "<p>Cảm ơn bạn đã đăng ký tài khoản tại G4-SmartTutor. "
                    + "Vui lòng nhấn vào liên kết dưới đây để kích hoạt tài khoản của bạn:</p>"
                    + "<p><a href='" + link + "' style='color: blue; text-decoration: underline;'>Kích Hoạt Tài Khoản</a></p>"
                    + "<p>Nếu nút trên không hoạt động, bạn có thể sao chép và dán liên kết này vào trình duyệt:</p>"
                    + "<p><a href='" + link + "'>" + link + "</a></p>"
                    + "<p>Liên kết này sẽ hết hạn sau 10 phút vì lý do bảo mật. Nếu bạn không đăng ký, vui lòng bỏ qua email này.</p>"
                    + "<p>Nếu bạn cần hỗ trợ, vui lòng liên hệ với chúng tôi qua g4.smarttutor@gmail.com .</p>"
                    + "<p>Trân trọng,<br>Đội Ngũ G4-SmartTutor</p>";

            msg.setContent(content, "text/html; charset=UTF-8");
            Transport.send(msg);
            System.out.println("Activation email sent successfully");
            return true;
        } catch (Exception e) {
            System.out.println("Activation email send error");
            System.out.println(e);
            return false;
        }
    }

    // Gửi email thông báo tài khoản đã được kích hoạt (mới)
    public boolean sendAccountActivatedEmail(String to, String name) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        };

        Session session = Session.getInstance(props, auth);
        MimeMessage msg = new MimeMessage(session);

        try {
            msg.addHeader("Content-type", "text/html; charset=UTF-8");
            msg.setFrom(from);
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
            msg.setSubject("Tài Khoản Đã Được Kích Hoạt - G4-SmartTutor", "UTF-8");

            String content = "<h3>Xin chào " + name + ",</h3>"
                    + "<p>Chúc mừng bạn! Tài khoản G4-SmartTutor của bạn đã được kích hoạt thành công.</p>"
                    + "<p>Bạn có thể đăng nhập ngay bây giờ để bắt đầu sử dụng dịch vụ của chúng tôi.</p>"
                    + "<p>Nếu bạn cần hỗ trợ, vui lòng liên hệ với chúng tôi qua g4.smarttutor@gmail.com .</p>"
                    + "<p>Trân trọng,<br>Đội Ngũ G4-SmartTutor</p>";

            msg.setContent(content, "text/html; charset=UTF-8");
            Transport.send(msg);
            System.out.println("Account activated email sent successfully");
            return true;
        } catch (Exception e) {
            System.out.println("Account activated email send error");
            System.out.println(e);
            return false;
        }
    }
}