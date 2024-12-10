<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>글 수정</title>

    <!-- jQuery 라이브러리 추가 -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
	<!-- Bootstrap 5 최신 버전 사용 -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- CKEditor CDN 방식으로 JavaScript 추가 -->
    <script src="//cdn.ckeditor.com/4.19.0/full/ckeditor.js"></script>
    
    <style>
        .marker {
            background-color: yellow; /* 배경색을 노란색으로 설정 */
        }
    </style>
</head>
<body class="container mt-5">

    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow-sm">
                <div class="card-header text-center">
                    <h3>글 수정</h3>
                </div>
                <div class="card-body">
                    <form id="editForm" action="${pageContext.request.contextPath}/article/update/${article.articleId}" method="post">
                        <div class="mb-3">
                            <label for="title" class="form-label"><strong>제목:</strong></label>
                            <input type="text" name="title" id="title" class="form-control" value="${article.title}" required readonly>
                        </div>

                        <div class="mb-3">
                            <label for="content" class="form-label"><strong>내용:</strong></label>
                            <!-- CKEditor가 적용될 textarea -->
                            <textarea name="content" id="content" rows="10" style="width: 100%; height: 300px;" class="form-control">
                                <c:out value="${article.content}" escapeXml="false"/>
                            </textarea>
                        </div>

                        <div class="d-flex justify-content-between">
                            <button type="button" class="btn btn-primary" onclick="submitContents()">수정 저장</button>
                            <button type="button" class="btn btn-secondary" onclick="location.href='${pageContext.request.contextPath}/article/articleList?pageIndex=${pageIndex}&searchCondition=${searchCondition}&searchKeyword=${searchKeyword}&timeRange=${timeRange}&sortBy=${sortBy}&sortOrder=${sortOrder}'">돌아가기</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- CKEditor 초기화 스크립트 -->
    <script type="text/javascript">
        $(function () {
            CKEDITOR.replace('content', {
                filebrowserUploadUrl: '${pageContext.request.contextPath}/article/image/upload',
                removePlugins: 'exportpdf', // exportpdf 플러그인 제거
                on: {
                    instanceReady: function () {
                        setTimeout(function() {
                            var warningBanner = document.getElementById('cke_notifications_area_content');
                            if (warningBanner) {
                                warningBanner.style.display = 'none';
                            }
                        }, 1); // 0.5초 후 실행
                    }
                }
            });
        });

        function submitContents() {
            // CKEditor 내용 동기화
            CKEDITOR.instances.content.updateElement();

            // 제목과 내용의 유효성 검사
            const title = document.getElementById("title").value.trim();
            const content = document.getElementById("content").value.trim();

            if (title === "") {
                alert("제목을 입력하세요.");
                document.getElementById("title").focus();
                return false;
            }

            if (content === "" || content === "<br>" || content === "<br/>" || content === "<p>&nbsp;</p>") {
                alert("내용을 입력하세요.");
                return false;
            }

            // 유효성 검사를 통과하면 폼 제출
            document.getElementById("editForm").submit();
        }
    </script>
</body>
</html>
