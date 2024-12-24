package egovframework.LocalBoard.dto;

import java.sql.Timestamp;

public class ReportedComment {

	private int articleId;
	private String content;
	private String nickname;
	private Timestamp createdAt;
	private int reportCount;
	
	public int getArticleId() {
		return articleId;
	}
	public void setArticleId(int articleId) {
		this.articleId = articleId;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public Timestamp getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}
	public int getReportCount() {
		return reportCount;
	}
	public void setReportCount(int reportCount) {
		this.reportCount = reportCount;
	}
	
	@Override
	public String toString() {
		return "ReportedComment [articleId=" + articleId + ", content=" + content + ", nickname=" + nickname
				+ ", createdAt=" + createdAt + ", reportCount=" + reportCount + "]";
	}
	
}
