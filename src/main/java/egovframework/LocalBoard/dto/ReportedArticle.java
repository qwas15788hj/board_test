package egovframework.LocalBoard.dto;

import java.sql.Timestamp;

import org.hsqldb.types.TimeData;

public class ReportedArticle {
	
	private int articleId;
	private String title;
	private Timestamp createdAt;
	private User user;
	private int reportCount;
	
	public int getArticleId() {
		return articleId;
	}
	public void setArticleId(int articleId) {
		this.articleId = articleId;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public Timestamp getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	public int getReportCount() {
		return reportCount;
	}
	public void setReportCount(int reportCount) {
		this.reportCount = reportCount;
	}
	
	@Override
	public String toString() {
		return "ReportedArticle [articleId=" + articleId + ", title=" + title + ", createdAt=" + createdAt + ", user="
				+ user + ", reportCount=" + reportCount + "]";
	}
	
	
}
