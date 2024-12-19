<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 목록</title>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Bootstrap 5 최신 버전 사용 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>

<script>

	//페이지 로드 후 에러 메시지가 있으면 alert로 표시하고, 페이지 리다이렉트
	window.onload = function() {
	    const errorMessage = '${errorMessage}';
	    if (errorMessage) {
	        alert(errorMessage);
	        // 원하는 URL로 리다이렉트 (현재 페이지를 다시 로드하지 않도록 설정)
	        window.location.href = '${pageContext.request.contextPath}/article/articleList';
	    }
	}
	
	function addViews(articleId) {
	    fetch(`${pageContext.request.contextPath}/article/addViews/` + articleId, {
	        method: 'POST'
	    })
	    .then(response => {
	        if (!response.ok) {
	            console.error("조회수 증가 실패");
	        }
	    })
	    .catch(error => {
	        console.error("조회수 증가 요청 중 오류 발생:", error);
	    });
	}
</script>

<style>
    /* 기본 스타일 */
    .sort-button {
        border: none;
        background: none;
        padding: 0;
        text-decoration: none;
        color: black;
        font-weight: normal;
    }

    /* 버튼이 활성화되었을 때 */
    .sort-button.active {
        color: #007bff;
        font-weight: bold;
    }
    
    .notice-row {
        background-color: #f8f9fa; /* 연한 회색 */
        font-weight: bold; /* 글씨 강조 */
        border-left: 5px solid #007bff; /* 파란색 테두리 */
    }
    
    .notice-title a {
	    color: #0000ff; /* 파란색 링크 */
	    font-weight: bold; /* 굵게 표시 */
	    text-decoration: none; /* 밑줄 제거 */
	}
	
	.notice-title a:hover {
	    text-decoration: underline !important; /* 링크에 마우스를 올리면 밑줄 표시 */
	}
	
	.articleList-title a:hover {
		text-decoration: underline !important; /* 링크에 마우스를 올리면 밑줄 표시 */
	}
    
</style>

<body>

	<div class="container mt-5">
		<!-- 게시글 목록 제목과 총 게시글 수 -->
		<div class="text-center mb-4">
			<h2 class="mb-0">
				<a href="${pageContext.request.contextPath}/article/articleList"
					style="text-decoration: none; color: inherit;"> 게시글 목록 </a>
			</h2>
		</div>


		<!-- 게시글 목록 제목과 총 게시글 수 영역 -->
		<div class="d-flex justify-content-between align-items-start mb-4">
			<span class="text-muted">총 게시글: ${pagination.articleTotal}개</span>
			<div class="d-flex">
		        <c:choose>
		            <c:when test="${user.roleType == 'ADMIN'}">
		                <!-- 관리자 페이지 -->
		                <form action="${pageContext.request.contextPath}/user/adminPage"
		                    method="get" class="me-2">
		                    <button type="submit" class="btn btn-outline-warning">관리자 페이지</button>
		                </form>
		            </c:when>
		            <c:otherwise>
		                <form action="${pageContext.request.contextPath}/user/myPage"
		                    method="get" class="me-2">
		                    <button type="submit" class="btn btn-outline-primary">마이페이지</button>
		                </form>
		            </c:otherwise>
		        </c:choose>
				<form action="${pageContext.request.contextPath}/user/logout"
					method="post">
					<button type="submit" class="btn btn-outline-danger">로그아웃</button>
				</form>
			</div>
		</div>

		<!-- 검색 및 필터 폼과 글쓰기 버튼을 감싸는 컨테이너 -->
		<div class="d-flex align-items-center gap-2 mb-4">
			<!-- 검색 및 필터 폼 -->
			<form action="${pageContext.request.contextPath}/article/articleList"
				method="get" class="d-flex align-items-center gap-2"
				style="flex-grow: 1;">
				<select name="searchCondition" class="form-select"
					style="width: 150px;">
					<option value="전체"
						<c:if test="${pagination.searchCondition == '전체'}">selected</c:if>>전체</option>
					<option value="제목"
						<c:if test="${pagination.searchCondition == '제목'}">selected</c:if>>제목</option>
					<option value="작성자"
						<c:if test="${pagination.searchCondition == '작성자'}">selected</c:if>>작성자</option>
				</select> <input type="text" name="searchKeyword" placeholder="검색어 입력"
					value="${pagination.searchKeyword}" class="form-control"
					style="width: 150px;"> <select name="timeRange"
					class="form-select" style="width: 150px;">
					<option value=""
						<c:if test="${pagination.timeRange == ''}">selected</c:if>>모두</option>
					<option value="1week"
						<c:if test="${pagination.timeRange == '1week'}">selected</c:if>>1주일</option>
					<option value="1month"
						<c:if test="${pagination.timeRange == '1month'}">selected</c:if>>1달</option>
					<option value="1year"
						<c:if test="${pagination.timeRange == '1year'}">selected</c:if>>1년</option>
				</select>

				<button type="submit" class="btn btn-primary">검색</button>
			</form>

			<!-- 글쓰기 버튼 -->
			<form
				action="${pageContext.request.contextPath}/article/articleWrite"
				method="get" class="ms-auto">
				<button type="submit" class="btn btn-success">글쓰기</button>
			</form>
		</div>


		<!-- 게시글 테이블 -->
		<c:choose>
			<c:when test="${not empty articleList}">
				<table class="table table-hover">
					<thead class="table-light">
						<tr>
							<th scope="col" style="width: 10%;">번호</th>
							<th scope="col" style="width: 40%;">제목</th>
							<th scope="col" style="width: 20%;">작성자</th>
							<th scope="col" style="width: 20%;">작성일</th>
							<th scope="col" style="width: 10%;">
							    <div style="display: inline-flex; align-items: center;">
							    	조회수
								    <div style="display: flex; flex-direction: column; margin-left: 5px;">
								        <c:choose>
								            <c:when test="${sortOrder == 'asc' && sortBy == 'views'}">
								                <a href="${pageContext.request.contextPath}/article/articleList?searchCondition=${pagination.searchCondition}&searchKeyword=${pagination.searchKeyword}&timeRange=${pagination.timeRange}" 
								                   class="sort-button active">
								                    ▲
								                </a>
								            </c:when>
								            <c:otherwise>
								                <a href="${pageContext.request.contextPath}/article/articleList?searchCondition=${pagination.searchCondition}&searchKeyword=${pagination.searchKeyword}&timeRange=${pagination.timeRange}&sortBy=views&sortOrder=asc" 
								                   class="sort-button">
								                    ▲
								                </a>
								            </c:otherwise>
								        </c:choose>
								
								        <c:choose>
								            <c:when test="${sortOrder == 'desc' && sortBy == 'views'}">
								                <a href="${pageContext.request.contextPath}/article/articleList?searchCondition=${pagination.searchCondition}&searchKeyword=${pagination.searchKeyword}&timeRange=${pagination.timeRange}" 
								                   class="sort-button active">
								                    ▼
								                </a>
								            </c:when>
								            <c:otherwise>
								                <a href="${pageContext.request.contextPath}/article/articleList?searchCondition=${pagination.searchCondition}&searchKeyword=${pagination.searchKeyword}&timeRange=${pagination.timeRange}&sortBy=views&sortOrder=desc" 
								                   class="sort-button">
								                    ▼
								                </a>
								            </c:otherwise>
								        </c:choose>
								    </div>
								</div>
							</th>
						</tr>
					</thead>
					<tbody>
						<!-- 관리자 글 출력 -->
		                <c:if test="${not empty adminArticleList}">
		                    <c:forEach var="adminArticle" items="${adminArticleList}" varStatus="status">
		                        <tr>
		                            <td class="notice-row">공지</td>
		                            <td class="notice-title">
		                                <a href="${pageContext.request.contextPath}/article/articleDetail/${adminArticle.articleId}" 
		                                   class="text-decoration-none">
		                                   ${adminArticle.title}
		                                </a>
		                            </td>
		                            <td>${adminArticle.user.nickname}</td>
		                            <td>${adminArticle.formattedCreatedAt}</td>
		                            <td>${adminArticle.views}</td>
		                        </tr>
		                    </c:forEach>
		                </c:if>
						<c:forEach var="article" items="${articleList}" varStatus="status">
							<tr>
								<td>${pagination.articleTotal - ((pagination.pageIndex - 1) * pagination.articleSize + status.index)}</td>
								<td class="articleList-title">
							    <a href="${pageContext.request.contextPath}/article/articleDetail/${article.articleId}?pageIndex=${pagination.pageIndex}&searchCondition=${pagination.searchCondition}&searchKeyword=${pagination.searchKeyword}&timeRange=${pagination.timeRange}&sortBy=${sortBy}&sortOrder=${sortOrder}" 
							       class="text-decoration-none" onclick="addViews(${article.articleId})">
							       ${article.title}
							    </a>
								</td>
								<td>${article.user.nickname}</td>
								<td>${article.formattedCreatedAt}</td>
								<td>${article.views}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</c:when>
			<c:otherwise>
				<div class="alert alert-warning text-center" role="alert">검색
					조건에 맞는 게시물이 없습니다!</div>
			</c:otherwise>
		</c:choose>

		<!-- 페이지네이션 -->
		<nav aria-label="Page navigation"
			class="d-flex justify-content-center mt-4">
			<ul class="pagination">
				<c:if test="${pagination.pageIndex > pagination.pageGroupSize}">
					<li class="page-item"><a class="page-link"
						href="?pageIndex=1&searchCondition=${pagination.searchCondition}&searchKeyword=${pagination.searchKeyword}&timeRange=${pagination.timeRange}&sortBy=${sortBy}&sortOrder=${sortOrder}">«</a>
					</li>
				</c:if>
				<c:if test="${pagination.pageIndex > pagination.pageGroupSize}">
					<li class="page-item"><a class="page-link"
						href="?pageIndex=${pagination.prevGroupPage+4}&searchCondition=${pagination.searchCondition}&searchKeyword=${pagination.searchKeyword}&timeRange=${pagination.timeRange}&sortBy=${sortBy}&sortOrder=${sortOrder}">‹</a>
					</li>
				</c:if>

				<c:forEach begin="${pagination.startPage}"
					end="${pagination.endPage}" var="i">
					<li
						class="page-item <c:if test='${i == pagination.pageIndex}'>active</c:if>">
						<a class="page-link"
						href="?pageIndex=${i}&searchCondition=${pagination.searchCondition}&searchKeyword=${pagination.searchKeyword}&timeRange=${pagination.timeRange}&sortBy=${sortBy}&sortOrder=${sortOrder}">
							${i} </a>
					</li>
				</c:forEach>

				<c:if test="${pagination.endPage != pagination.getTotalPages()}">
					<li class="page-item"><a class="page-link"
						href="?pageIndex=${pagination.nextGroupPage}&searchCondition=${pagination.searchCondition}&searchKeyword=${pagination.searchKeyword}&timeRange=${pagination.timeRange}&sortBy=${sortBy}&sortOrder=${sortOrder}">›</a>
					</li>
					<li class="page-item"><a class="page-link"
						href="?pageIndex=${pagination.getTotalPages()}&searchCondition=${pagination.searchCondition}&searchKeyword=${pagination.searchKeyword}&timeRange=${pagination.timeRange}&sortBy=${sortBy}&sortOrder=${sortOrder}">»</a>
					</li>
				</c:if>
			</ul>
		</nav>
	</div>

	<!-- Bootstrap JS 추가 -->
	<script
		src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>

</body>
</html>
