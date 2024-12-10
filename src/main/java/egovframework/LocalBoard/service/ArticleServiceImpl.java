package egovframework.LocalBoard.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.LocalBoard.dto.Article;
import egovframework.LocalBoard.dto.Pagination;
import egovframework.LocalBoard.dto.User;
import egovframework.LocalBoard.mapper.ArticleMapper;

@Service
@Transactional
public class ArticleServiceImpl implements ArticleService {
	
	@Autowired
	private ArticleMapper articleMapper;

	@Override
	public List<Article> getArticleList(Pagination pagination) {
		return articleMapper.getArticleList(pagination);
	}
	
	// 검색조건 추가
	@Override
	public int getArticleCount(Pagination pagination) {
		return articleMapper.getArticleCount(pagination);
	}

	@Override
	public void saveArticle(User user, String title, String content) {
		Article article = new Article();
		article.setUser(user);
		article.setTitle(title);
		article.setContent(content);
		
		articleMapper.saveArticle(article);
	}

	@Override
	public Article articleDetail(int articleId) {
		return articleMapper.getArticle(articleId);
	}

	@Override
	public void addViews(int articleId) {
		articleMapper.addViews(articleId);
	}

	@Override
	public void articleUpdate(Map<String, Object> params) {
		articleMapper.articleUpdate(params);
	}

	@Override
	public void articleDelete(int articleId) {
		articleMapper.articleDetele(articleId);
	}

	@Override
	public void removeArticleByUserId(int userId) {
		articleMapper.removeArticleByUserId(userId);
	}

	@Override
	public int getArticleCountByUserId(int userId) {
		return articleMapper.getArticleCountByUserId(userId);
	}

	@Override
	public List<Article> getArticlesByUserIdWithLimit(Map<String, Object> params) {
		return articleMapper.getArticlesByUserIdWithLimit(params);
	}


}
