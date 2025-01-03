package egovframework.LocalBoard.dto;

import java.sql.Timestamp;

import org.stringtemplate.v4.compiler.CodeGenerator.primary_return;


public class Comment {

	private int commentId;
	private Article article;
	private User user;
	private Integer parentCommentId;
	private String content;
	private Timestamp createdAt;
	private int isDeleted;
	private String image;
	private int level; // 무한 댓글을 위한 level 생성
	
	public int getCommentId() {
		return commentId;
	}
	public void setCommentId(int commentId) {
		this.commentId = commentId;
	}
	public Article getArticle() {
		return article;
	}
	public void setArticle(Article article) {
		this.article = article;
	}
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	public Integer getParentCommentId() {
		return parentCommentId;
	}
	public void setParentCommentId(Integer parentCommentId) {
		this.parentCommentId = parentCommentId;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Timestamp getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}
	public int getIsDeleted() {
		return isDeleted;
	}
	public void setIsDeleted(int isDeleted) {
		this.isDeleted = isDeleted;
	}
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}
	public int getLevel() {
		return level;
	}
	public void setLevel(int level) {
		this.level = level;
	}
	@Override
	public String toString() {
		return "Comment [commentId=" + commentId + ", article=" + article + ", user=" + user + ", parentCommentId="
				+ parentCommentId + ", content=" + content + ", createdAt=" + createdAt + ", isDeleted=" + isDeleted
				+ ", image=" + image + ", level=" + level + "]";
	}
}
