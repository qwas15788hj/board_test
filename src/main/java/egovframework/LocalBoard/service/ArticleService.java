package egovframework.LocalBoard.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

import egovframework.LocalBoard.dto.Article;
import egovframework.LocalBoard.dto.ArticleFile;
import egovframework.LocalBoard.dto.Pagination;
import egovframework.LocalBoard.dto.Report;
import egovframework.LocalBoard.dto.User;

public interface ArticleService {

	List<Article> getArticleList(Pagination pagination);
	List<Article> getArticleListByAdmin();
	int getArticleCount(Pagination pagination);
	void saveArticle(User user, String title, String content, MultipartFile[] files, HttpServletRequest request);
	Article articleDetail(int articleId);
	void articleUpdate(Map<String, Object> params, List<Integer> existingFiles, MultipartFile[] files, HttpServletRequest request);
	void articleDelete(int articleId);
	void addViews(int articleId);
	void removeArticleByUserId(int userId);
	int getArticleCountByUserId(int userId);
	List<Article> getArticlesByUserIdWithLimit(Map<String, Object> params);
	List<ArticleFile> getArticleFileByArticleId(Article article);
	void saveReport(Report report);
	boolean checkReportByUserIdAndArticleId(int userId, int articleId);

}
