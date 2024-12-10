package egovframework.LocalBoard.controller;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import egovframework.LocalBoard.dto.Comment;
import egovframework.LocalBoard.dto.User;
import egovframework.LocalBoard.service.CommentService;

@RestController
@RequestMapping("/comment")
public class CommentController {
	
	private static final Logger logger = LoggerFactory.getLogger(CommentController.class);
	
	@Autowired
	private CommentService commentService;
	
	// root 댓글 가져오는 함수
	@GetMapping("/{articleId}/rootComments")
	public List<Comment> getRootComments(@PathVariable int articleId) {
	    List<Comment> comments = commentService.getRootComments(articleId);
	    comments.forEach(comment -> {
	        // 개행 처리 및 HTML-safe 변환
	        comment.setContent(comment.getContent().replace("\n", "\\n"));
	    });
	    return comments;
	}
	
	// root 댓글 이외의 모든 댓글 가져오는 함수
	@GetMapping("/{commentId}/replies")
	public List<Comment> getRepliesByCommentId(@PathVariable int commentId) {
	    List<Comment> replies = commentService.getRepliesByCommentId(commentId);
	    replies.forEach(reply -> {
	        // 개행 처리 및 HTML-safe 변환
	        reply.setContent(reply.getContent().replace("\n", "\\n"));
	    });
	    return replies;
	}
	
	// 댓글 작성
    @PostMapping("/write")
    public ResponseEntity<Comment> writeComment(@RequestParam("articleId") int articleId,
    											@RequestParam("userId") int userId,
    											@RequestParam("parentCommentId") Integer parentCommentId,
    											@RequestParam("content") String content) {
    	
        try {
        	// 클라이언트에서 전송된 content의 개행 문자 디코딩
            String decodedContent = content.replace("\\n", "\n");
            
            // Map에 데이터를 담아 서비스에 전달
            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("articleId", articleId);
            paramMap.put("userId", userId);
            paramMap.put("content", decodedContent);
            paramMap.put("parentCommentId", parentCommentId);
            
            // 서비스 호출
            Comment newComment = commentService.writeComment(paramMap);
            return ResponseEntity.ok(newComment);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    @PostMapping("/update")
    public ResponseEntity<?> updateCommentTest(@RequestParam int commentId, 
                                               @RequestParam String content, 
                                               HttpServletRequest request) {
        try {
            // 세션에서 현재 로그인한 사용자 가져오기
            User user = (User) request.getSession().getAttribute("user");
            // 댓글 작성자 확인
            Comment comment = commentService.getCommentById(commentId);

            if (comment.getIsDeleted() == 1) {
            	logger.info("이미 삭제된 댓글입니다.");
                return createResponse("이미 삭제된 댓글입니다.", HttpStatus.NOT_FOUND);
            }

            if (comment.getUser().getId() != user.getId()) {
            	logger.info("유효한 접근이 아닙니다.");
                return createResponse("유효한 접근이 아닙니다.", HttpStatus.FORBIDDEN);
            }

            // 클라이언트에서 전송된 content의 개행 문자 디코딩
            String decodedContent = content.replace("\\n", "\n");
            
            // 댓글 업데이트
            Comment updatedComment = commentService.updateComment(commentId, decodedContent);
            return ResponseEntity.ok(updatedComment);

        } catch (Exception e) {
            e.printStackTrace();
            return createResponse("댓글 업데이트에 실패했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    // 댓글 삭제
    @PostMapping("/remove")
    public ResponseEntity<?> removeComment(@RequestParam("commentId") int commentId, HttpServletRequest request) {
        try {
        	// 세션에서 현재 로그인한 사용자 가져오기
            User user = (User) request.getSession().getAttribute("user");
            // 댓글 작성자 확인
            Comment comment = commentService.getCommentById(commentId);
            
            if (comment.getIsDeleted() == 1) {
            	logger.info("이미 삭제된 댓글입니다.");
                return createResponse("이미 삭제된 댓글입니다.", HttpStatus.NOT_FOUND);
            }

            if (comment.getUser().getId() != user.getId()) {
            	logger.info("유효한 접근이 아닙니다.");
                return createResponse("유효한 접근이 아닙니다.", HttpStatus.FORBIDDEN);
            }
        	
            commentService.removeComment(commentId); // Service 호출
            Map<String, String> response = new HashMap<>();
            response.put("message", "댓글이 삭제되었습니다.");
            return ResponseEntity.ok(response); // JSON 형식으로 응답
        } catch (Exception e) {
            e.printStackTrace();
            return createResponse("댓글 삭제에 실패했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    // 재사용 가능한 메서드 추가
    private ResponseEntity<String> createResponse(String message, HttpStatus status) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(new MediaType("text", "plain", StandardCharsets.UTF_8));
        return new ResponseEntity<>(message, headers, status);
    }

}
