package egovframework.LocalBoard.dto;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;

import com.sun.jndi.toolkit.ctx.StringHeadTail;

public class Article {
	
	private int articleId;
	private User user;
	private String title;
	private String content;
	private int views;
	private Timestamp createdAt;
	private String formattedCreatedAt;
	
	public int getArticleId() {
		return articleId;
	}
	public void setArticleId(int articleId) {
		this.articleId = articleId;
	}
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public int getViews() {
		return views;
	}
	public void setViews(int views) {
		this.views = views;
	}
	public Timestamp getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
		if (createdAt != null) {
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
			this.formattedCreatedAt = format.format(createdAt);
		}
	}
	public String getFormattedCreatedAt() {
		return formattedCreatedAt;
	}
	@Override
	public String toString() {
		return "Article [articleId=" + articleId + ", user=" + user + ", title=" + title + ", content=" + content
				+ ", views=" + views + ", createdAt=" + createdAt + ", formattedCreatedAt=" + formattedCreatedAt + "]";
	}
	
}
