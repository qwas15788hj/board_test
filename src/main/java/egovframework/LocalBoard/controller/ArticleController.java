package egovframework.LocalBoard.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.google.gson.JsonObject;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import egovframework.LocalBoard.dto.Article;
import egovframework.LocalBoard.dto.ArticleFile;
import egovframework.LocalBoard.dto.Comment;
import egovframework.LocalBoard.dto.Pagination;
import egovframework.LocalBoard.dto.Report;
import egovframework.LocalBoard.dto.SmarteditorVO;
import egovframework.LocalBoard.dto.User;
import egovframework.LocalBoard.service.ArticleService;
import egovframework.LocalBoard.service.CommentService;

@Controller
@RequestMapping("/article")
public class ArticleController {
	
	private static final Logger logger = LoggerFactory.getLogger(ArticleController.class);
	
	@Autowired
	private ArticleService articleService;
	@Autowired
	private CommentService commentService;
	
	// 게시물 목록 생성
	// 검색 및 기간 추가
	@GetMapping("/articleList")
	public String articleList(
	        @RequestParam(defaultValue = "1") String pageIndex,
	        @RequestParam(defaultValue = "전체") String searchCondition,
	        @RequestParam(defaultValue = "") String searchKeyword,
	        @RequestParam(defaultValue = "") String timeRange,
	        @RequestParam(defaultValue = "created_at") String sortBy,  // 기본 정렬 기준은 'created_at'
	        @RequestParam(defaultValue = "desc") String sortOrder,     // 기본 정렬 순서는 'desc'
	        Model model, HttpServletRequest request) {
	    
	    int pageIndexInt;
	    
	    try {
	        pageIndexInt = Integer.parseInt(pageIndex);
	    } catch (NumberFormatException e) {
	        pageIndexInt = 1;
	    }
	    
	    // Pagination 객체 생성 및 설정
	    Pagination pagination = new Pagination();
	    pagination.setSearchCondition(searchCondition);
	    pagination.setSearchKeyword(searchKeyword);
	    pagination.setTimeRange(timeRange); // timeRange 설정
	    pagination.setSortBy(sortBy);       // 정렬 기준 설정
	    pagination.setSortOrder(sortOrder); // 정렬 순서 설정

	    // 게시물 총 개수 가져오기 (검색 조건 포함)
	    int articleCount = articleService.getArticleCount(pagination);
	    pagination.setArticleTotal(articleCount);

	    // 페이지 인덱스 조정 (1보다 작은 경우 1로, 전체 페이지 수보다 큰 경우 마지막 페이지로)
	    if (pageIndexInt < 1) {
	        pageIndexInt = 1;
	    }
	    int totalPage = pagination.getTotalPages();
	    if (pageIndexInt > totalPage) {
	        pageIndexInt = totalPage;
	    }
	    
	    // Pagination에 현재 페이지 인덱스와 게시물 크기 설정
	    pagination.setPageIndex(pageIndexInt);
	    pagination.setArticleSize(10);
	    pagination.setOffset();
	    
	    List<Article> adminArticleList = null;
	    // 관리자 게시물 리스트 조회
	    if (pageIndex.equals("1") && searchCondition.equals("전체") && searchKeyword.equals("") && timeRange.equals("") && sortBy.equals("created_at") && sortOrder.equals("desc")) {
	    	adminArticleList = articleService.getArticleListByAdmin();
	    }
	    
	    // 게시물 리스트 조회 (검색 조건 포함)
	    List<Article> articleList = articleService.getArticleList(pagination);
	    
	    model.addAttribute("adminArticleList", adminArticleList);
	    model.addAttribute("articleList", articleList);
	    model.addAttribute("pagination", pagination);
	    
	    User user = (User) request.getSession().getAttribute("user");
	    model.addAttribute("user", user);
	    
	    request.getSession().setAttribute("pageIndex", pageIndexInt);
	    request.getSession().setAttribute("searchCondition", searchCondition);
	    request.getSession().setAttribute("searchKeyword", searchKeyword);
	    request.getSession().setAttribute("timeRange", timeRange);
	    request.getSession().setAttribute("sortBy", sortBy);
	    request.getSession().setAttribute("sortOrder", sortOrder);
	    
	    return "articleList";
	}

	// 게시글 작성 페이지 이동
	@GetMapping("/articleWrite")
	public String articleWrite(HttpServletRequest request) {
		User user = (User) request.getSession().getAttribute("user");
		if(user == null) {
			return "redirect:/user/login";
		}
		return "articleWrite";
	}
	
	// 게시글 작성
	@PostMapping("/saveArticle")
	public String saveArticle(@RequestParam("title") String title,
								@RequestParam("content") String content,
								@RequestParam("files") MultipartFile[] files,
								HttpServletRequest request) {

		User user = (User) request.getSession().getAttribute("user");
		if (user != null) {
			articleService.saveArticle(user, title, content, files, request);
		}
		return "redirect:/article/articleList";
		
	}
	
	// 게시글 내용 확인 페이지 이동
	@GetMapping("/articleDetail/{articleId}")
	public String articleDetail(@PathVariable("articleId") int articleId,
								@RequestParam(value = "pageIndex", defaultValue = "1") int pageIndex,
							    @RequestParam(value = "searchCondition", defaultValue = "전체") String searchCondition,
							    @RequestParam(value = "searchKeyword", defaultValue = "") String searchKeyword,
							    @RequestParam(value = "timeRange", defaultValue = "") String timeRange,
							    Model model, HttpServletRequest request) {

	    Article article = articleService.articleDetail(articleId);
	    model.addAttribute("article", article);
	    
	    User user = (User) request.getSession().getAttribute("user");
	    model.addAttribute("user", user);
	    
	    List<ArticleFile> articleFiles = articleService.getArticleFileByArticleId(article);
	    for (ArticleFile file : articleFiles) {
	        double fileSizeInKB = file.getFileSize() / 1024.0;
	        String roundedSize = String.format("%.1f", fileSizeInKB); // 소수점 첫째 자리 반올림
	        file.setFormattedFileSize(roundedSize + "KB"); // 문자열로 저장
	    }
	    model.addAttribute("articleFiles", articleFiles);
	    
	    // 검색 조건 및 페이지네이션 정보 추가
	    model.addAttribute("pageIndex", pageIndex);
	    model.addAttribute("searchCondition", searchCondition);
	    model.addAttribute("searchKeyword", searchKeyword);
	    model.addAttribute("timeRange", timeRange);
	    
	    boolean reportCheck = articleService.checkReportByUserIdAndArticleId(user.getId(), articleId);
	    System.out.println("reportCheck : " + reportCheck);
	    model.addAttribute("reportCheck", reportCheck);

	    return "articleDetail";
	}
	
	// 조회수 증가
	@PostMapping("/addViews/{articleId}")
	public ResponseEntity<Void> addViews(@PathVariable("articleId") int articleId, HttpServletRequest request) {
		Article article = articleService.articleDetail(articleId);
		User user = (User) request.getSession().getAttribute("user");
		if(article.getUser().getId() != user.getId()) {
			articleService.addViews(articleId);
		}
		return ResponseEntity.ok().build();
	}
	
	// 게시글 업데이트 페이지 이동
	@GetMapping("/update/{articleId}")
	public String articleUpdatePage(@PathVariable("articleId") int articleId, Model model, HttpServletRequest request) {
	    Article article = articleService.articleDetail(articleId);
	    
	    // 세션에서 로그인한 사용자 정보 가져오기
	    User user = (User) request.getSession().getAttribute("user");

	    // null 체크 및 작성자 검증
	    if (user == null || article == null || article.getUser() == null || user.getId() != article.getUser().getId()) {
	        // 작성자와 현재 로그인한 사용자가 다르면 유효하지 않은 접근 메시지를 표시하고 목록 페이지로 리다이렉트
	    	model.addAttribute("errorMessage", "유효한 접근이 아닙니다.");
	        return "articleList";
	    }

	    // 정상적으로 접근한 경우 게시글 수정 페이지로 이동
	    model.addAttribute("article", article);
	    
	    List<ArticleFile> articleFiles = articleService.getArticleFileByArticleId(article);
	    for (ArticleFile file : articleFiles) {
	        double fileSizeInKB = file.getFileSize() / 1024.0;
	        String roundedSize = String.format("%.1f", fileSizeInKB); // 소수점 첫째 자리 반올림
	        file.setFormattedFileSize(roundedSize + "KB"); // 문자열로 저장
	    }
	    model.addAttribute("articleFiles", articleFiles);
	    
	    return "articleUpdate";
	}
	
	// 게시글 업데이트
	@PostMapping("/update/{articleId}")
	public ResponseEntity<Map<String, Object>> articleUpdate(@PathVariable("articleId") int articleId,
															@RequestParam("content") String content,
													        @RequestParam(value = "existingFiles", required = false) List<Integer> existingFiles,
															@RequestParam("files") MultipartFile[] files,
															HttpServletRequest request) {

		Map<String, Object> response = new HashMap<>();
	    Article article = articleService.articleDetail(articleId);
	    User user = (User) request.getSession().getAttribute("user");

	    // null 체크 및 작성자 검증
	    if (user == null || article == null || article.getUser() == null || user.getId() != article.getUser().getId()) {
	        response.put("status", "error");
	        response.put("message", "유효한 접근이 아닙니다.");
	        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
	    }

	    // 게시글 업데이트
	    Map<String, Object> params = new HashMap<>();
	    params.put("articleId", articleId);
	    params.put("content", content);
	    articleService.articleUpdate(params, existingFiles, files, request);

	    // 세션에서 검색 조건 가져오기
	    HttpSession session = request.getSession();
	    response.put("status", "success");
	    response.put("pageIndex", session.getAttribute("pageIndex"));
	    response.put("searchCondition", session.getAttribute("searchCondition"));
	    response.put("searchKeyword", session.getAttribute("searchKeyword"));
	    response.put("timeRange", session.getAttribute("timeRange"));
	    response.put("sortBy", session.getAttribute("sortBy"));
	    response.put("sortOrder", session.getAttribute("sortOrder"));

	    return ResponseEntity.ok(response);
	}

	// 게시글 삭제
	@DeleteMapping("/delete/{articleId}")
	public String articleDelete(@PathVariable("articleId") int articleId,
	                            HttpServletRequest request,
	                            Model model) {
		
		Article article = articleService.articleDetail(articleId);
	    User user = (User) request.getSession().getAttribute("user");
	    
	    System.out.println("Delete user : " + user);
	    // null 체크 및 작성자 검증
	    if (user == null || article == null || article.getUser() == null || (user.getId() != article.getUser().getId() && !user.getRoleType().equals("ADMIN"))) {
	        // 작성자와 현재 로그인한 사용자가 다르면 유효하지 않은 접근 메시지를 표시하고 목록 페이지로 리다이렉트
	    	model.addAttribute("errorMessage", "유효한 접근이 아닙니다.");
	        return "articleList";
	    }
	    
	    commentService.removeCommentByArticleId(articleId);
	    articleService.articleDelete(articleId);

	    // 세션에서 검색 조건 가져오기
	    HttpSession session = request.getSession();
	    int pageIndex = (int) session.getAttribute("pageIndex");
	    String searchCondition = (String) session.getAttribute("searchCondition");
	    String searchKeyword = (String) session.getAttribute("searchKeyword");
	    String timeRange = (String) session.getAttribute("timeRange");
	    String sortBy = (String) session.getAttribute("sortBy");
	    String sortOrder = (String) session.getAttribute("sortOrder");
	    
	    // 각 파라미터를 URL 인코딩
	    try {
	        searchCondition = URLEncoder.encode(searchCondition, StandardCharsets.UTF_8.toString());
	        searchKeyword = URLEncoder.encode(searchKeyword, StandardCharsets.UTF_8.toString());
	        timeRange = URLEncoder.encode(timeRange, StandardCharsets.UTF_8.toString());
	        sortBy = URLEncoder.encode(sortBy, StandardCharsets.UTF_8.toString());
	        sortOrder = URLEncoder.encode(sortOrder, StandardCharsets.UTF_8.toString());
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return "redirect:/article/articleList?pageIndex=" + pageIndex +
	           "&searchCondition=" + searchCondition +
	           "&searchKeyword=" + searchKeyword +
	           "&timeRange=" + timeRange +
	           "&sortBy=" + sortBy +
	           "&sortOrder=" + sortOrder;
	}
	
	/*
	 * 이미지 업로드
	 * 실제 저장 위치: C:/Users/user/Desktop/board Project/eGovFrameDev-3.10.0-64bit/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/LocalBoard/resources/ckimage
	 */
	@PostMapping("/image/upload")
	@ResponseBody
	public String fileUpload(HttpServletRequest request, HttpServletResponse response, MultipartHttpServletRequest multiFile) throws IOException {
		
		//Json 객체 생성
		JsonObject json = new JsonObject();
		// Json 객체를 출력하기 위해 PrintWriter 생성
		PrintWriter printWriter = null;
		OutputStream out = null;
		//파일을 가져오기 위해 MultipartHttpServletRequest 의 getFile 메서드 사용
		MultipartFile file = multiFile.getFile("upload");
		
		//파일이 비어있지 않고(비어 있다면 null 반환)
		if (file != null) {
			// 파일 사이즈가 0보다 크고, 파일이름이 공백이 아닐때
			if (file.getSize() > 0 && StringUtils.isNotBlank(file.getName())) {
				if (file.getContentType().toLowerCase().startsWith("image/")) {

					try {
						//파일 이름 설정
						String fileName = file.getName();
						//바이트 타입설정
						byte[] bytes;
						//파일을 바이트 타입으로 변경
						bytes = file.getBytes();
						//파일이 실제로 저장되는 경로 
						String uploadPath = request.getServletContext().getRealPath("/resources/ckimage/");
						//저장되는 파일에 경로 설정
						File uploadFile = new File(uploadPath);
						if (!uploadFile.exists()) {
							uploadFile.mkdirs();
						}
						//파일이름을 랜덤하게 생성
						fileName = UUID.randomUUID().toString();
						//업로드 경로 + 파일이름을 줘서  데이터를 서버에 전송
						uploadPath = uploadPath + "/" + fileName;
						System.out.println("File saved to: " + uploadPath);
						out = new FileOutputStream(new File(uploadPath));
						out.write(bytes);
						
						//클라이언트에 이벤트 추가
						printWriter = response.getWriter();
						response.setContentType("text/html");
						
						//파일이 연결되는 Url 주소 설정
						String fileUrl = request.getContextPath() + "/resources/ckimage/" + fileName;
						
						//생성된 jason 객체를 이용해 파일 업로드 + 이름 + 주소를 CkEditor에 전송
						json.addProperty("uploaded", 1);
						json.addProperty("fileName", fileName);
						json.addProperty("url", fileUrl);
						printWriter.println(json);
					} catch (IOException e) {
						e.printStackTrace();
					} finally {
						if(out !=null) {
							out.close();
						}
						if(printWriter != null) {
							printWriter.close();
						}
					}
				}
			}
		}
		return null;
	}
	
	// 유저가 작성한 게시글 목록
	@GetMapping("/userArticles")
	@ResponseBody
	public List<Article> getArticlesByUserIdWithLimit(HttpServletRequest request, @RequestParam("offset") int offset) {
		User user = (User) request.getSession().getAttribute("user");
		if (user == null) {
			return null;
		}
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", user.getId());
		
		return articleService.getArticlesByUserIdWithLimit(params);
	}
	
	@GetMapping("/file/download")
	public void downloadFile(@RequestParam("fileUrl") String fileUrl,
	                         @RequestParam("fileName") String fileName,
	                         HttpServletRequest request,
	                         HttpServletResponse response) throws IOException {

	    // 서버의 실제 업로드 파일 경로 설정
	    String uploadPath = request.getServletContext().getRealPath("/resources/upload/");
	    String fileUrlTrimmed = fileUrl.replace("/resources/upload/", ""); // 중복된 경로 제거
	    String fullPath = uploadPath + fileUrlTrimmed;
	    
	    File file = new File(fullPath);

	    if (file.exists()) {
	        // ContentType 설정
	        response.setContentType("application/octet-stream");
	        response.setHeader("Content-Disposition", 
	                "attachment; filename=\"" + URLEncoder.encode(fileName, "UTF-8") + "\"");
	        response.setContentLength((int) file.length());

	        // 파일을 응답 스트림으로 전달
	        try (OutputStream out = response.getOutputStream()) {
	            Files.copy(file.toPath(), out);
	            out.flush();
	        }
	    } else {
	        System.out.println("File exists: false");
	        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
	        response.getWriter().write("File not found.");
	    }
	}
	
	@PostMapping("/report")
	public ResponseEntity<String> submitReport(@RequestParam int articleId, HttpServletRequest request) {
	    // 세션에서 유저 정보 가져오기
	    User user = (User) request.getSession().getAttribute("user");
	    if (user == null) {
	        return ResponseEntity.status(401).body("로그인이 필요합니다.");
	    }

	    int userId = user.getId();

	    // Report 객체 생성 및 데이터 설정
	    Report report = new Report();
	    report.setArticleId(articleId);
	    report.setUserId(user.getId());

	    // 신고 저장
	    articleService.saveReport(report);

	    return ResponseEntity.ok("신고가 접수되었습니다.");
	}

}
