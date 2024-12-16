package egovframework.LocalBoard.dto;

public class ArticleFile {
	
    private int id;
    private int articleId; 
    private String fileName;
    private String fileUrl;
    private long fileSize;
    private String formattedFileSize;
    
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getArticleId() {
		return articleId;
	}
	public void setArticleId(int articleId) {
		this.articleId = articleId;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getFileUrl() {
		return fileUrl;
	}
	public void setFileUrl(String fileUrl) {
		this.fileUrl = fileUrl;
	}
	public long getFileSize() {
		return fileSize;
	}
	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}
	public String getFormattedFileSize() {
		return formattedFileSize;
	}
	public void setFormattedFileSize(String formattedFileSize) {
		this.formattedFileSize = formattedFileSize;
	}
	@Override
	public String toString() {
		return "ArticleFile [id=" + id + ", articleId=" + articleId + ", fileName=" + fileName + ", fileUrl=" + fileUrl
				+ ", fileSize=" + fileSize + ", formattedFileSize=" + formattedFileSize + "]";
	}
	   
}
