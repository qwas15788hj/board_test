package egovframework.LocalBoard.service;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import egovframework.LocalBoard.controller.ArticleController;
import egovframework.LocalBoard.dto.Article;
import egovframework.LocalBoard.dto.ArticleFile;
import egovframework.LocalBoard.dto.Pagination;
import egovframework.LocalBoard.dto.User;
import egovframework.LocalBoard.mapper.ArticleMapper;

@Service
@Transactional
public class ArticleServiceImpl implements ArticleService {
	
	private static final Logger logger = LoggerFactory.getLogger(ArticleServiceImpl.class);

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
	public void saveArticle(User user, String title, String content, MultipartFile[] files, HttpServletRequest request) {
		
		Article article = new Article();
		article.setUser(user);
		article.setTitle(title);
		article.setContent(content);
		articleMapper.saveArticle(article);
		
	    int articleId = article.getArticleId(); // 자동 증가된 ID 가져오기
	    // 파일 저장 로직
	    String uploadPath = request.getServletContext().getRealPath("/resources/upload/");
	    File uploadDir = new File(uploadPath);
	    if (!uploadDir.exists()) {
	        uploadDir.mkdirs();
	    }

	    for (MultipartFile file : files) {
	        if (!file.isEmpty()) {
	            try {
	                String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
	                File destination = new File(uploadPath, fileName);
	                file.transferTo(destination);

	                // DB에 파일 정보 저장
	                ArticleFile articleFile = new ArticleFile();
	                articleFile.setArticleId(articleId); // 저장된 articleId 설정
	                articleFile.setFileName(file.getOriginalFilename());
	                articleFile.setFileUrl("/resources/upload/" + fileName);
	                articleFile.setFileSize(file.getSize());
	                articleMapper.saveFile(articleFile);
	            } catch (IOException e) {
	                e.printStackTrace();
	            }
	        }
	    }
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
	public void articleUpdate(Map<String, Object> params, List<Integer> existingFiles, MultipartFile[] files, HttpServletRequest request) {
		articleMapper.articleUpdate(params);
		
		Map<String, Object> deleteParams = new HashMap<String, Object>();
		deleteParams.put("articleId", (int) params.get("articleId"));
		deleteParams.put("existingFiles", existingFiles);		
		articleMapper.deleteFile(deleteParams);
		
		// 파일 저장 로직
	    String uploadPath = request.getServletContext().getRealPath("/resources/upload/");
	    File uploadDir = new File(uploadPath);
	    if (!uploadDir.exists()) {
	        uploadDir.mkdirs();
	    }

	    for (MultipartFile file : files) {
	        if (!file.isEmpty()) {
	            try {
	                String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
	                File destination = new File(uploadPath, fileName);
	                file.transferTo(destination);

	                // DB에 파일 정보 저장
	                ArticleFile articleFile = new ArticleFile();
	                articleFile.setArticleId((int) params.get("articleId")); // 저장된 articleId 설정
	                articleFile.setFileName(file.getOriginalFilename());
	                articleFile.setFileUrl("/resources/upload/" + fileName);
	                articleFile.setFileSize(file.getSize());
	                articleMapper.saveFile(articleFile);
	            } catch (IOException e) {
	                e.printStackTrace();
	            }
	        }
	    }
	    
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

	@Override
	public List<ArticleFile> getArticleFileByArticleId(Article article) {
		return articleMapper.getArticleFileByArticleId(article);
	}


}
