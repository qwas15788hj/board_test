package egovframework.LocalBoard.service;

import java.util.List;
import java.util.Map;

import egovframework.LocalBoard.dto.Article;
import egovframework.LocalBoard.dto.Pagination;
import egovframework.LocalBoard.dto.User;

public interface ArticleService {

	List<Article> getArticleList(Pagination pagination);
	int getArticleCount(Pagination pagination);
	void saveArticle(User user, String title, String content);
	Article articleDetail(int articleId);
	void articleUpdate(Map<String, Object> params);
	void articleDelete(int articleId);
	void addViews(int articleId);
	void removeArticleByUserId(int userId);
	int getArticleCountByUserId(int userId);
	List<Article> getArticlesByUserIdWithLimit(Map<String, Object> params);

}
