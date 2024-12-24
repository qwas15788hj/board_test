package egovframework.LocalBoard.service;

import java.math.BigInteger;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.LocalBoard.dto.Comment;
import egovframework.LocalBoard.dto.ReportedComment;
import egovframework.LocalBoard.mapper.CommentMapper;

@Service
@Transactional
public class CommentServiceImpl implements CommentService {

	@Autowired
	private CommentMapper commentMapper;

	@Override
	public void removeCommentByUserId(int userId) {
		commentMapper.removeCommentByUserId(userId);
	}

	@Override
	public void removeCommentByArticleId(int articleId) {
		commentMapper.removeCommentByArticleId(articleId);
	}

	@Override
	public List<Comment> getRootComments(int articleId) {
		return commentMapper.getRootComments(articleId);
	}

	@Override
	public List<Comment> getRepliesByCommentId(int commentId) {
		return commentMapper.getRepliesByCommentId(commentId);
	}

	@Override
	public Comment writeComment(Map<String, Object> paramMap) {
		commentMapper.writeComment(paramMap);
		
	    // Mapper에서 자동 생성된 commentId 값을 paramMap에서 가져옴
	    Object commentIdObject = paramMap.get("commentId");
	    int commentId;
	    if (commentIdObject instanceof BigInteger) {
	        commentId = ((BigInteger) commentIdObject).intValue();
	    } else if (commentIdObject instanceof Integer) {
	        commentId = (Integer) commentIdObject;
	    } else {
	        throw new IllegalArgumentException("commentId의 타입이 예상과 다릅니다: " + commentIdObject.getClass().getName());
	    }
	    
		return commentMapper.getCommentById(commentId);
	}

	@Override
	public Comment updateComment(int commentId, String content) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("commentId", commentId);
		params.put("content", content);
		commentMapper.updateComment(params);
		
		return commentMapper.getCommentById(commentId);
	}

	@Override
	public void removeComment(int commentId) {
		commentMapper.removeComment(commentId);
	}

	@Override
	public Comment getCommentById(int commentId) {
		return commentMapper.getCommentById(commentId);
	}

	@Override
	public boolean checkReportComment(int userId, int commentId) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("commentId", commentId);
		
		return commentMapper.checkReportComment(params) > 0;
	}

	@Override
	public void saveReportComment(int userId, int commentId) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("commentId", commentId);
		commentMapper.saveReportComment(params);
	}

	@Override
	public List<ReportedComment> getReportedCommentList() {
		return commentMapper.getReportedCommentList();
	}

}
