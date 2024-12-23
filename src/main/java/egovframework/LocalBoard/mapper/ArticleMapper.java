package egovframework.LocalBoard.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import egovframework.LocalBoard.dto.Article;
import egovframework.LocalBoard.dto.ArticleFile;
import egovframework.LocalBoard.dto.Pagination;
import egovframework.LocalBoard.dto.Report;
import egovframework.LocalBoard.dto.ReportedArticle;

@Mapper
public interface ArticleMapper {

	List<Article> getArticleList(Pagination pagination);

	List<Article> getArticleListByAdmin();

	int getArticleCount(Pagination pagination);

	void saveArticle(Article article);

	Article getArticle(int articleId);

	void addViews(int articleId);

	void articleUpdate(Map<String, Object> params);

	void articleDetele(int articleId);

	void removeArticleByUserId(int userId);

	int getArticleCountByUserId(int userId);

	List<Article> getArticlesByUserIdWithLimit(Map<String, Object> params);

	void saveFile(ArticleFile articleFile);

	List<ArticleFile> getArticleFileByArticleId(Article article);

	void deleteFile(Map<String, Object> deleteParams);

	void saveReport(Report report);

	int checkReportByUserIdAndArticleId(Map<String, Object> params);

	List<ReportedArticle> getReportedArticleList();

}
