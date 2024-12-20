package egovframework.LocalBoard.config;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

@Configuration
public class CommonInterceptor extends HandlerInterceptorAdapter {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 세션에서 로그인 정보를 가져옴
        Object user = request.getSession().getAttribute("user");

        // 로그인이 안된 상태라면 로그인 페이지로 리다이렉트
        if (user == null) {
            String uri = request.getRequestURI();
            
            // 로그인 및 회원가입 페이지는 예외 처리
            if (uri.equals(request.getContextPath() + "/user/login") ||
            	uri.equals(request.getContextPath() + "/user/join") ||
            	uri.startsWith(request.getContextPath() + "/excel")) {
                return true; // 로그인 및 회원가입 페이지는 예외적으로 통과시킴
            }

            // 그 외 페이지는 로그인 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/user/login");
            return false; // 요청을 중단
        }

        return true; // 로그인이 되어 있으면 요청을 진행
    }
}
