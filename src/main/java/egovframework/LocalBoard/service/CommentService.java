package egovframework.LocalBoard.service;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;

import egovframework.LocalBoard.dto.Comment;

public interface CommentService {

	void removeCommentByUserId(int userId);
	void removeCommentByArticleId(int articleId);
	List<Comment> getRootComments(int articleId);
	List<Comment> getRepliesByCommentId(int commentId);
	Comment writeComment(Map<String, Object> paramMap);
	Comment updateComment(int commentId, String content);
	void removeComment(int commentId);
	Comment getCommentById(int commentId);
}
