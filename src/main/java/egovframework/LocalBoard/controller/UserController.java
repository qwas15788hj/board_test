package egovframework.LocalBoard.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.LocalBoard.dto.Article;
import egovframework.LocalBoard.dto.ReportedArticle;
import egovframework.LocalBoard.dto.ReportedComment;
import egovframework.LocalBoard.dto.User;
import egovframework.LocalBoard.mapper.UserMapper;
import egovframework.LocalBoard.service.ArticleService;
import egovframework.LocalBoard.service.CommentService;
import egovframework.LocalBoard.service.UserService;

@ComponentScan
@Controller
@RequestMapping("/user")
public class UserController {
	
	private static final Logger logger = LoggerFactory.getLogger(UserController.class);
	
	@Autowired
	private UserService userService;
	@Autowired
	private ArticleService articleService;
	@Autowired
	private CommentService commentService;
	
	// 로그인 페이지 이동
	@GetMapping("/login")
	public String loginPage() {
		return "login";
	}
	
	// 로그인 체크
	@PostMapping("/login")
	public String login(@RequestParam("loginId") String loginId,
						@RequestParam("pwd") String pwd,
						HttpServletRequest request) {
		
	    User findUser = userService.findByLoginId(loginId);
	    if (findUser == null) {
	        return "redirect:/user/login?error=true";
	    }

	    boolean isPasswordMatch = BCrypt.checkpw(pwd, findUser.getPwd());
	    if (!isPasswordMatch) {
	        return "redirect:/user/login?error=true";
	    }

	    request.getSession().setAttribute("user", findUser);
	    return "redirect:/article/articleList";
		
	}
	
	// 회원가입 페이지 이동
	@GetMapping("/join")
	public String joinPage() {
		return "join";
	}
	
	// 회원가입 체크
	@PostMapping("/join")
	public String join(@RequestParam("loginId") String loginId,
						@RequestParam("pwd") String pwd,
						@RequestParam("nickname") String nickname,
						HttpServletRequest request) {
		
	    // 비밀번호 암호화 후 userService에 전달
	    String encryptedPwd = BCrypt.hashpw(pwd, BCrypt.gensalt());
	    
	    // 데이터 전달을 위해 HashMap 사용
	    Map<String, Object> params = new HashMap<>();
	    params.put("loginId", loginId);
	    params.put("pwd", encryptedPwd);
	    params.put("nickname", nickname);

	    userService.join(params);
	    return "redirect:/user/login";
	    
	}
	
	
	// 회원가입 시 아이디 중복체크
    @ResponseBody
    @GetMapping(value = "/checkId", produces = "text/plain; charset=UTF-8")
    public String checkId(@RequestParam("loginId") String loginId) {
    	boolean isAvailable;
    	if(loginId.equals("admin")) {
    		isAvailable = false;
    	} else {
    		isAvailable = userService.checkId(loginId);
    	}
        return isAvailable ? "사용 가능한 아이디입니다." : "사용할 수 없는 아이디입니다.";
    }
	
    // 마이페이지 이동
    @GetMapping("/myPage")
    public String myPage(HttpServletRequest request, Model model) {
        User user = (User) request.getSession().getAttribute("user");
        int articleCount = articleService.getArticleCountByUserId(user.getId());
        
        model.addAttribute("user", user);
        model.addAttribute("articleCount", articleCount);
        return "myPage";
    }
    
    // 관리자 페이지
    @GetMapping("/adminPage")
    public String adminPage(HttpServletRequest request, Model model) {
    	User user = (User) request.getSession().getAttribute("user");
    	if (!user.getRoleType().equals("ADMIN")){
    		model.addAttribute("errorMessage", "유효한 접근이 아닙니다.");
    		return "articleList";
    	}
    	
    	List<ReportedArticle> reportedArticleList = articleService.getReportedArticleList();
    	System.out.println(reportedArticleList);
    	model.addAttribute("reportedArticleList", reportedArticleList);
    	
    	List<ReportedComment> reportedCommentList = commentService.getReportedCommentList();
    	System.out.println(reportedCommentList);
    	model.addAttribute("reportedCommentList", reportedCommentList);
    	
    	return "adminPage";
    }
    
    // 유저 정보 수정
    @PostMapping("/modify")
    public String modifyUserProfile(@RequestParam("userId") int userId,
                                    @RequestParam("pwd") String pwd,
                                    @RequestParam("nickname") String nickname,
                                    HttpServletRequest request,
                                    RedirectAttributes redirectAttributes,
                                    Model model) {

        User user = (User) request.getSession().getAttribute("user");
	    // null 체크 및 작성자 검증
	    if (user == null || user.getId() != userId) {
	        // 작성자와 현재 로그인한 사용자가 다르면 유효하지 않은 접근 메시지를 표시하고 목록 페이지로 리다이렉트
	    	model.addAttribute("errorMessage", "유효한 접근이 아닙니다.");
	        return "articleList";
	    }
	    
	    // 닉네임 검증
	    if (nickname.equalsIgnoreCase("관리자") || nickname.equalsIgnoreCase("admin")) {
	        redirectAttributes.addFlashAttribute("errorMessage", "해당 이름은 사용할 수 없습니다.");
	        return "redirect:/user/myPage";
	    }
	    
        // 비밀번호 암호화 후 업데이트
        user.setPwd(BCrypt.hashpw(pwd, BCrypt.gensalt()));
        user.setNickname(nickname);
        userService.modifyUserProfile(user);

        // 세션 정보 업데이트
        request.getSession().setAttribute("user", user);
        
        return "redirect:/article/articleList";
    }
    
    // 회원 탈퇴
    @PostMapping("/remove")
    public String removeUser(@RequestParam("userId") int userId, HttpServletRequest request, Model model) {
    	
	    User user = (User) request.getSession().getAttribute("user");
	    // null 체크 및 작성자 검증
	    if (user == null || user.getId() != userId) {
	        // 작성자와 현재 로그인한 사용자가 다르면 유효하지 않은 접근 메시지를 표시하고 목록 페이지로 리다이렉트
	    	model.addAttribute("errorMessage", "유효한 접근이 아닙니다.");
	        return "articleList";
	    }
	    
    	commentService.removeCommentByUserId(userId);
    	articleService.removeArticleByUserId(userId);
    	userService.removeUser(userId);
		HttpSession session = request.getSession(false);
		if (session != null) {
			session.invalidate();
		}
    	return "redirect:/user/login";
    }

    // 로그아웃
	@PostMapping("logout")
	public String logout(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if (session != null) {
			session.invalidate();
		}
		return "redirect:/user/login";
	}
	
}
