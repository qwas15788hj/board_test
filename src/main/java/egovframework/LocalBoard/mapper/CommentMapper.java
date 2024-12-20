package egovframework.LocalBoard.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import egovframework.LocalBoard.dto.Comment;

@Mapper
public interface CommentMapper {
	
	void removeCommentByUserId(int userId);
	
	void removeCommentByArticleId(int articleId);

	List<Comment> getRootComments(int articleId);

	List<Comment> getRepliesByCommentId(int commentId);

	void writeComment(Map<String, Object> paramMap);
	
	void updateComment(Map<String, Object> params);

	void removeComment(int commentId);

	Comment getCommentById(Integer commentId);
	
}
