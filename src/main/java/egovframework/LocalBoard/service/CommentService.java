package egovframework.LocalBoard.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;

import egovframework.LocalBoard.dto.Comment;
import egovframework.LocalBoard.dto.ReportedComment;

public interface CommentService {

	void removeCommentByUserId(int userId);
	void removeCommentByArticleId(int articleId);
	List<Comment> getRootComments(int articleId);
	List<Comment> getRepliesByCommentId(int commentId);
	Comment writeComment(Map<String, Object> paramMap);
	Comment updateComment(int commentId, String content);
	void removeComment(HashMap<String, Object> params);
	Comment getCommentById(int commentId);
	boolean checkReportComment(int userId, int commentId);
	void saveReportComment(int userId, int commentId);
	List<ReportedComment> getReportedCommentList();
}
