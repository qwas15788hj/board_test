<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Bootstrap 5 최신 버전 사용 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>

<style>
    .badge {
        font-size: 1rem;
    }
    .text-danger {
        color: #dc3545 !important;
    }
    .article-title:hover {
	    text-decoration: underline !important; /* 마우스를 올리면 밑줄 추가 */
	}
    
</style>


<body>
	<div class="container mt-5">
	    <!-- 관리자 페이지 제목 -->
	    <div class="text-center mb-4">
	        <h2 class="mb-0">관리자 페이지</h2>
	    </div>
	
	    <!-- 신고된 게시글 테이블 -->
	    <c:if test="${not empty reportedArticleList}">
	        <h4 class="text-danger mb-4">신고된 게시글 목록</h4>
	        <table class="table table-hover">
	            <thead class="table-light">
	                <tr>
	                    <th scope="col" style="width: 10%;">번호</th>
	                    <th scope="col" style="width: 40%;">제목</th>
	                    <th scope="col" style="width: 20%;">작성자</th>
	                    <th scope="col" style="width: 10%;">신고 수</th>
	                    <th scope="col" style="width: 20%;">작성일</th>
	                </tr>
	            </thead>
	            <tbody>
	                <c:forEach var="reportedArticleList" items="${reportedArticleList}" varStatus="status">
	                    <tr>
	                        <td>${status.index + 1}</td>
	                        <td>
	                            <a href="${pageContext.request.contextPath}/article/articleDetail/${reportedArticleList.articleId}"
	                            	class="article-title text-decoration-none">
	                                ${reportedArticleList.title}
	                            </a>
	                        </td>
	                        <td>${reportedArticleList.user.nickname}</td>
	                        <td><span class="text-decoration-none text-danger">${reportedArticleList.reportCount}</span></td>
	                        <td>${reportedArticleList.createdAt}</td>
	                    </tr>
	                </c:forEach>
	            </tbody>
	        </table>
	    </c:if>
	
	    <!-- 신고된 게시글이 없을 때 -->
	    <c:if test="${empty reportedArticleList}">
	        <div class="alert alert-info text-center" role="alert">
	            신고된 게시글이 없습니다.
	        </div>
	    </c:if>
	</div>

</body>
</html>