<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시물 상세보기</title>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Bootstrap 5 최신 버전 사용 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<%-- <link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css"> --%>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">

<!-- 현재 세션에 저장된 유저의 ID값 가져오기 -->
<%@ page import="egovframework.LocalBoard.dto.User" %>
<%
    // Java에서 현재 로그인된 사용자의 ID를 가져와서 currentUserId에 저장
    User user = (User) session.getAttribute("user");
    int currentUserId = (user != null) ? user.getId() : 0;
    boolean isAdmin = (user != null) && user.getRoleType().equals("ADMIN");
    request.setAttribute("currentUserId", currentUserId);
    request.setAttribute("isAdmin", isAdmin);
%>

<style>
    .reply-box {
        border: 1px solid #ddd; /* 공통 스타일 */
        padding: 1rem; /* 공통 스타일 */
        margin-bottom: 0.5rem; /* 공통 스타일 */
        background-color: #f8f9fa; /* 공통 스타일 */
    }
    .marker {
    	background-color: yellow; /* 배경색을 노란색으로 설정 */
   	}
</style>

<script>

	// 데이터를 출력할 때, 데이터가 이스케이프된 문자일 경우 HTML로 디코딩
	document.addEventListener("DOMContentLoaded", function() {
	var content = `${article.content}`;
	
	// 이스케이프된 HTML 문자열을 실제 HTML로 변환
	var decodedContent = content
	    .replace(/&lt;/g, "<")
	    .replace(/&gt;/g, ">")
	    .replace(/&quot;/g, '"')
	    .replace(/&amp;/g, "&");
	
	document.getElementById('content').innerHTML = decodedContent;
	
	});

	const currentUserId = <%= currentUserId %>; // Java 변수를 JavaScript 변수로 전달
	const articleId = ${articleId}; // 서버에서 전달된 articleId
	let previousCommentId = null; // 이전에 열렸던 commentId를 저장
	
	// 댓글 최대값 체크
	function checkCommentLength() {
	    const contentField = document.getElementById("commentContent");
	    const maxLength = 50;
	    const currentLength = contentField.value.length;
	
	    if (currentLength > maxLength) {
	        alert("댓글은 최대 " + maxLength + "자까지만 입력할 수 있습니다.");
	        contentField.value = contentField.value.slice(0, maxLength);
	    }
	}
	
	
	// 페이지 로드 시 root 댓글 가져오기	
	$(document).ready(function() {
	    loadRootComments();
	});
	
	// Root 댓글 불러오기
	function loadRootComments() {
	    fetch(`${pageContext.request.contextPath}/comment/\${articleId}/rootComments`)
	        .then(response => response.json())
	        .then(comments => {
	            renderComments(comments, $('#commentListContainer'));
	        })
	        .catch(error => console.error('댓글 로드 실패:', error));
	}
	
		// root 댓글 렌더링 함수
	function renderComments(comments, container) {
	    container.empty(); // 기존 댓글 초기화
	
	    comments.forEach(comment => {
	        const createdAt = new Date(comment.createdAt).toLocaleString();
	        const isOwner = currentUserId === comment.user.id; // 작성자와 현재 사용자 비교
	        const content = comment.isDeleted === 1 ? "삭제된 글 입니다."
	        					: comment.isDeleted === 2 ? "관리자에 의해 삭제된 글 입니다."
	        							: comment.content;
	        const isAdmin = ${isAdmin};
	
	        /* // 댓글 영역 생성
	        const commentDiv = $(`
	            <div id="root-\${comment.commentId}" class="border p-3 mb-3 bg-light">
	           		<div id="comment-\${comment.commentId}" class="comment-content">
	                    <p>작성자 : \${comment.user.nickname}</p>
	                    <p style="white-space: pre-wrap;">\${content.replace(/\\n/g, "\n")}</p>
	                    <small>\${createdAt}</small>
	                    <button class="btn btn-secondary btn-sm mt-2" onclick="loadReplies(\${comment.commentId})">답글 보기</button>
	                    \${comment.isDeleted ? "" : `
	                        <div class="comment-actions">
		                        <button class="btn btn-primary btn-sm mt-2" onclick="showReplyForm(\${comment.commentId}, 0, 0)">작성</button>
		                        \${
		                            isOwner
		                                ? `<button class="btn btn-warning btn-sm mt-2" onclick="editComment(\${comment.commentId}, '\${comment.content}')">수정</button>
		                                   <button class="btn btn-danger btn-sm mt-2" onclick="deleteComment(\${comment.commentId})">삭제</button>`
		                                : ""}
	                        </div>
	                    `}
	                </div>
	                <div id="replies-\${comment.commentId}" class="mt-2" style="display: none;"></div>
	            </div>
	        `);
	
	        container.append(commentDiv); */
	        
	     	// 댓글 영역 생성
	        const commentDiv = $(`
	            <div id="root-\${comment.commentId}" class="border p-3 mb-3 bg-light">
	                <div id="comment-\${comment.commentId}" class="comment-content position-relative">
	                    <p>작성자 : \${comment.user.nickname}</p>
	                    <p style="white-space: pre-wrap;">\${content.replace(/\\n/g, "\n")}</p>
	                    <small>\${createdAt}</small>
	                    
	                    \${
	                    	!isOwner && comment.isDeleted === 0
			                    <!-- 오른쪽 상단의 ... 버튼 -->
			                    ? `<div class="dropdown position-absolute" style="top: 10px; right: 10px;">
				                        <button class="btn btn-secondary btn-sm dropdown-toggle" type="button" id="dropdownMenu-\${comment.commentId}" data-bs-toggle="dropdown" aria-expanded="false">
				                            ...
				                        </button>
				                        <ul class="dropdown-menu" aria-labelledby="dropdownMenu-\${comment.commentId}">
				                            <li>
				                                <button class="dropdown-item" onclick="reportComment(\${comment.commentId})">신고</button>
				                            </li>
				                        </ul>
			                    	</div>`
			                    : ""
	                    }

	                    <button class="btn btn-secondary btn-sm mt-2" onclick="loadReplies(\${comment.commentId})">답글 보기</button>
	                    \${comment.isDeleted ? "" : `
	                        <div class="comment-actions">
	                            <button class="btn btn-primary btn-sm mt-2" onclick="showReplyForm(\${comment.commentId}, 0, 0)">작성</button>
	                            \${
	                                isOwner
	                                    ? `<button class="btn btn-warning btn-sm mt-2" onclick="editComment(\${comment.commentId}, '\${comment.content}')">수정</button>
	                                       <button class="btn btn-danger btn-sm mt-2" onclick="deleteComment(\${comment.commentId})">삭제</button>`
                                       : (isAdmin 
	                                       ? `<button class="btn btn-danger btn-sm mt-2" onclick="deleteComment(\${comment.commentId})">삭제</button>`
	                                       : ""
	                                     )
	                            }
	                        </div>
	                    `}
	                </div>
	                <div id="replies-\${comment.commentId}" class="mt-2" style="display: none;"></div>
	            </div>
	        `);

	        container.append(commentDiv);

	    });
	}
		
		//root 댓글 이외의 모든 댓글 가져오기 및 렌더링
	function loadReplies(commentId) {
	    // 대댓글 영역을 표시할 컨테이너
	    const repliesContainer = $(`#replies-\${commentId}`);
	
	    // 이미 표시된 상태라면 숨기기
	    if (repliesContainer.is(":visible")) {
	        repliesContainer.hide();
	        repliesContainer.find('.reply-form').remove(); // 폼 제거
	        return;
	    }
	
	    // 댓글의 대댓글 가져오기
	    fetch(`${pageContext.request.contextPath}/comment/\${commentId}/replies`)
	        .then(response => response.json())
	        .then(replies => {
	            // 대댓글 렌더링
	            renderReplies(replies, repliesContainer); // 1부터 시작 (level)
	            repliesContainer.show(); // 대댓글 컨테이너 표시
	            repliesState[commentId] = true;
	
	        })
	        .catch(error => console.error('대댓글 로드 실패:', error));
	}
	
	// root 댓글 이외의 모든 댓글 렌더링 함수
	function renderReplies(replies, container) {
	    container.empty(); // 기존 대댓글 초기화
	
	    replies.forEach(reply => {
	        const createdAt = new Date(reply.createdAt).toLocaleString();
	        const marginLeft = reply.level * 30; // 레벨에 따른 왼쪽 마진 설정
	        const isOwner = currentUserId === reply.user.id; // 작성자와 현재 사용자 비교
	        const content = reply.isDeleted === 1 ? "삭제된 글 입니다."
								: reply.isDeleted === 2 ? "관리자에 의해 삭제된 글 입니다."
										: reply.content;
	        const isAdmin = ${isAdmin};
	
	        
	        // 대댓글 생성
	        const replyDiv = $(`
	            <div id="comment-\${reply.commentId}" class="border p-3 mb-2 bg-light position-relative" style="margin-left: \${marginLeft}px;">
	                <p>작성자 : \${reply.user.nickname}</p>
	                <p style="white-space: pre-wrap;">\${content.replace(/\\n/g, "\n")}</p>
	                <small>\${createdAt}</small>
	                
	                \${
                    	!isOwner && reply.isDeleted === 0
                    	? `
		                    <!-- 오른쪽 상단의 ... 버튼 -->
		                    <div class="dropdown position-absolute" style="top: 10px; right: 10px;">
		                        <button class="btn btn-secondary btn-sm dropdown-toggle" type="button" id="dropdownMenu-\${reply.commentId}" data-bs-toggle="dropdown" aria-expanded="false">
		                            ...
		                        </button>
		                        <ul class="dropdown-menu" aria-labelledby="dropdownMenu-\${reply.commentId}">
		                            <li>
		                                <button class="dropdown-item" onclick="reportComment(\${reply.commentId})">신고</button>
		                            </li>
		                        </ul>
		                    </div>
		                   ` : ""
	                }
	                \${reply.isDeleted ? "" : `
	                    <div class="comment-actions">
	                        <button class="btn btn-primary btn-sm mt-2" onclick="showReplyForm(\${reply.commentId}, 1, \${reply.level})">작성</button>
                            \${
                                isOwner
                                    ? `<button class="btn btn-warning btn-sm mt-2" onclick="editComment(\${reply.commentId}, '\${reply.content}')">수정</button>
                                       <button class="btn btn-danger btn-sm mt-2" onclick="deleteComment(\${reply.commentId})">삭제</button>`
                                   : (isAdmin 
                                       ? `<button class="btn btn-danger btn-sm mt-2" onclick="deleteComment(\${reply.commentId})">삭제</button>`
                                       : ""
                                     )
                            }
	                    </div>
	                `}
	                <div id="replies-\${reply.commentId}" class="mt-2" style="display: none;"></div>
	            </div>
	        `);
	
	        container.append(replyDiv);
	    });
	}
	
	
	const repliesState = {}; // 각 댓글 ID에 대한 상태 저장
	
	// 대댓글 작성 폼 표시 함수
	function showReplyForm(parentCommentId, check, currentLevel) {
		const nextLevel = currentLevel + 1; // 다음 댓글의 레벨 계산
			// 대댓글 작성 영역을 표시할 컨테이너
	    const replyContainer = \$(`#comment-\${parentCommentId}`);
	    const replyContainerVisible = \$(`#replies-\${parentCommentId}`);
		
	    // 열려 있는 모든 수정 폼 닫기
	    $('.edit-form').each(function () {
	        const parentDiv = $(this).closest('.comment-content'); // 수정 폼의 부모 댓글 영역
	        parentDiv.find('p').show(); // 숨겨진 댓글 내용 복구
	        parentDiv.find('.edit-form').remove(); // 수정 폼 제거
	        parentDiv.find('.comment-actions').show(); // 버튼 영역 표시
	    });
	    
	    
	    // 현재 열려 있는 폼의 컨테이너와 클릭한 컨테이너 비교
	    if (\$('.reply-form').parent().attr('id') === `comment-\${parentCommentId}`) {
	        \$('.reply-form').remove(); // 열려 있는 모든 폼 닫기
	        return; // 폼이 동일한 컨테이너에 열려 있으면 종료
	    }
	    
	    \$('.reply-form').remove(); // 열려 있는 모든 폼 닫기
	
	    const isRepliesVisible = replyContainerVisible.is(":visible");
	
	    // 상태가 초기화되지 않았다면 false로 초기화
	    if (repliesState[parentCommentId] === undefined) {
	        repliesState[parentCommentId] = false;
	    }
	
	    // 답글 보기가 눌리지 않았고 check가 0이며 답글 상태가 false일 때만 loadReplies 실행
	    if (check === 0 && !isRepliesVisible) {
	        loadReplies(parentCommentId);
	        console.log(repliesState);
	
	        // 답글 로드 후 작성 폼을 지연 표시
	        setTimeout(() => {
	            // 작성 폼 직접 생성 및 추가
	            const replyForm = \$(` 
	                <div class="reply-form border p-3 mt-2 bg-white">
	                    <textarea id="replyContent-\${parentCommentId}" rows="3" class="form-control"
	                        placeholder="답글을 입력하세요" maxlength="50" required></textarea>
	                    <button type="button" class="btn btn-primary mt-2"
	                        onclick="submitComment(\${articleId}, \${parentCommentId}, \${nextLevel});">등록</button>
	                </div>
	            `);
	            replyContainer.append(replyForm); // 폼 추가
	            replyContainer.show(); // 컨테이너 표시
	        }, 100);
	
	        // 답글 보기가 실행되었음을 기록
	        repliesState[parentCommentId] = true;
	      	console.log(repliesState);
	        return;
	    } else {
	        // 대댓글 작성 폼 생성
	        const replyForm = $(`
	            <div class="reply-form border p-3 mt-2 bg-white">
	                <textarea id="replyContent-\${parentCommentId}" rows="3" class="form-control"
	                    placeholder="답글을 입력하세요" maxlength="50" required></textarea>
	                <button type="button" class="btn btn-primary mt-2"
	                    onclick="submitComment(\${articleId}, \${parentCommentId}, \${nextLevel});">등록</button>
	            </div>
	        `);
	        // 폼 추가
	        replyContainer.append(replyForm);
	        replyContainer.show();
	    }
	}
	
	function submitComment(articleId, parentCommentId, level) {
	    const contentField = parentCommentId === 0 
	        ? $("#commentContent") 
	        : $(`#replyContent-\${parentCommentId}`);
	    const content = contentField.val();
	    const fileInput = document.getElementById("imageUpload");
	    const file = fileInput.files[0]; // 선택된 파일
	    
	    console.log("입력된 content 값:", content); // 입력된 값 확인

	    if (!content || content.trim() === "") {
	        alert("댓글 내용을 입력하세요.");
	        return;
	    }
	    
	    // FormData 객체 생성
	    const formData = new FormData();
	    formData.append("articleId", articleId);
	    formData.append("userId", currentUserId);
	    formData.append("parentCommentId", parentCommentId);
	    formData.append("content", content);
	    if (file) {
	        formData.append("image", file); // 이미지 파일 추가
	    }

	    // Fetch API를 사용하여 서버로 데이터 전송
	    fetch(`${pageContext.request.contextPath}/comment/write`, {
	        method: "POST",
	        body: formData, // FormData 객체 전달
	    })
	    .then(response => {
	        if (!response.ok) {
	            throw new Error("댓글 작성 실패");
	        }
	        return response.json();
	    })
	    .then(newComment => {
	        // 댓글 작성 성공 시 화면에 바로 반영
	        if (parentCommentId === 0) {
	            console.log("댓글 작성 parentCommentId === 0 호출");
	            // 새 root 댓글을 맨 위에 추가
	            const container = $("#commentListContainer");
	            const isOwner = currentUserId === newComment.user.id; // 작성자와 현재 사용자 비교
	            
	            // Escape 처리하여 onclick 속성에서 문제가 없도록 수정
	            const escapedContent = newComment.content.replace(/'/g, "\\'").replace(/"/g, '\\"').replace(/\n/g, "\\n");
	            
	            container.prepend(`
	                <div id="comment-\${newComment.commentId}" class="border p-3 mb-3 bg-light">
	                    <p>작성자 : \${newComment.user.nickname}</p>
	                    <p style="white-space: pre-wrap;">\${newComment.content.replace(/\\n/g, "\n")}</p>
	                    <small>\${new Date(newComment.createdAt).toLocaleString()}</small>
	                    <button class="btn btn-secondary btn-sm mt-2" onclick="loadReplies(\${newComment.commentId})">답글 보기</button>
	                    <button class="btn btn-primary btn-sm mt-2" onclick="showReplyForm(\${newComment.commentId}, 0, \${newComment.level})">작성</button>
	                    <div class="comment-actions">
	                        \${
	                            isOwner
	                                ? `<button class="btn btn-warning btn-sm mt-2" onclick="editComment(\${newComment.commentId}, '\${escapedContent}')">수정</button>
	                                   <button class="btn btn-danger btn-sm mt-2" onclick="deleteComment(\${newComment.commentId})">삭제</button>`
	                                : ""
	                        }
	                    </div>
	                    <div id="replies-\${newComment.commentId}" class="mt-2" style="display: none;"></div>
	                </div>
	            `);
	        } else {
	            console.log("댓글 작성 parentCommentId !== 0 호출");
	            // 새 대댓글을 올바른 위치에 추가
	            const parentMargin = parseInt($(`#comment-\${parentCommentId}`).css('margin-left'));
	            const newMargin = parentMargin + 30; // 부모의 마진 값에 30을 더하여 설정

	            let targetContainer = null;
	            let foundParent = false; // 부모 commentId 이후부터 탐색하기 위한 플래그

	            // 현재 댓글이 추가되어야 할 위치 탐색 (등록 버튼을 누른 parentCommentId부터 시작)
	            $(`[id^=comment-]`).each(function () {
	                const currentCommentId = $(this).attr('id').split('-')[1];
	                
	                if (foundParent) {
	                    const currentMargin = parseInt($(this).css('margin-left'));
	                    if (isNaN(currentMargin) || currentMargin === 0) {
	                        // 현재 요소가 root 댓글인 경우
	                        // 해당 대댓글은 부모의 마지막 자식으로 추가
	                        targetContainer = null;  // root 댓글에는 추가하지 않기 위해 null로 설정
	                        return false; // break the each loop
	                    } else if (currentMargin < newMargin) {
	                        // 부모보다 마진 값이 작거나 같다면 여기에 삽입
	                        targetContainer = $(this);
	                        return false; // break the each loop
	                    }
	                }

	                // 부모 댓글 찾기
	                if (currentCommentId === `\${parentCommentId}`) {
	                    foundParent = true; // 부모 댓글을 찾으면 그 이후부터 탐색 시작
	                }
	            });

	            const isOwner = currentUserId === newComment.user.id; // 작성자와 현재 사용자 비교
	            const escapedContent = newComment.content.replace(/'/g, "\\'").replace(/"/g, '\\"').replace(/\n/g, "\\n"); // Escape 처리
	            const newReplyHtml = `
	                <div id="comment-\${newComment.commentId}" class="border p-3 mb-2 bg-light" style="margin-left: \${newMargin}px;">
	                    <p>작성자 : \${newComment.user.nickname}</p>
	                    <p style="white-space: pre-wrap;">\${newComment.content.replace(/\\n/g, "\n")}</p>
	                    <small>\${new Date(newComment.createdAt).toLocaleString()}</small>
	                    <button class="btn btn-primary btn-sm mt-2" onclick="showReplyForm(\${newComment.commentId}, 1, \${newComment.level})">작성</button>
	                    <div class="comment-actions">
	                        \${
	                            isOwner
	                                ? `<button class="btn btn-warning btn-sm mt-2" onclick="editComment(\${newComment.commentId}, '\${escapedContent}')">수정</button>
	                                   <button class="btn btn-danger btn-sm mt-2" onclick="deleteComment(\${newComment.commentId})">삭제</button>`
	                                : ""
	                        }
	                    </div>
	                    <div id="replies-\${newComment.commentId}" class="mt-2" style="display: none;"></div>
	                </div>
	            `;

	            if (targetContainer) {
	            	console.log("targetContainer 발견 : ", targetContainer);
	                targetContainer.before(newReplyHtml);
	            } else {
	                // 적절한 위치를 찾지 못한 경우, 루트 댓글로 올라가서 해당 루트의 마지막에 추가
	                let rootElement = $(`#comment-\${parentCommentId}`).closest("[id^=root-]");
	                if (rootElement.length) {
	                    console.log("루트 요소 발견, rootElement:", rootElement.attr('id'));
	                    rootElement.append(newReplyHtml); // 루트 댓글의 마지막에 추가
	                } else {
	                    console.log("루트 요소를 찾을 수 없음");

	                    // 현재 parentCommentId에서 가장 가까운 commentListContainer 밑의 comment id 찾기
	                    let closestParentId = null;
	                    $(`#comment-\${parentCommentId}`)
	                        .parentsUntil("#commentListContainer")
	                        .each(function () {
	                            const parentId = $(this).attr("id");
	                            if (parentId && parentId.startsWith("comment-")) {
	                                closestParentId = parentId.split("-")[1];
	                                return false; // break out of each loop
	                            }
	                        });

	                    // 최상위 parentId를 기반으로 commentListContainer 바로 아래의 id를 설정
	                    if (closestParentId) {
	                        console.log("찾은 최상위 parentId:", closestParentId);
	                        parentCommentId = closestParentId;
	                    }

	                    // 추가하려는 댓글이 이미 존재하는지 확인
	                    if ($(`#comment-\${newComment.commentId}`).length > 0) {
	                        console.log("중복 댓글 발견, 추가하지 않음:", newComment.commentId);
	                        return;
	                    }

	                    // 루트를 찾지 못한 경우 commentListContainer 바로 아래에 추가
	                    $(`#comment-\${parentCommentId}`).append(newReplyHtml);
	                }

	            }
	        }

	        // 입력 필드 초기화
	        contentField.val("");
            fileInput.value = ""; // 파일 입력 초기화
            $("#imagePreviewContainer").empty(); // 이미지 미리보기 초기화
	    })
	    .catch(error => {
	        console.error("댓글 작성 중 오류:", error);
	        alert("댓글 작성에 실패했습니다.");
	    });
	}
	
	function editComment(commentId) {
	    console.log("editComment 호출됨:", commentId);

	    // 열려 있는 모든 작성 폼 닫기
	    $('.reply-form').remove();

	    // 이전에 열렸던 수정 폼을 닫고 내용 복구
	    if (previousCommentId !== null && previousCommentId !== commentId) {
	        const previousDiv = $(`#comment-\${previousCommentId}`);
	        previousDiv.find('p').eq(1).show(); // 숨겨진 내용을 다시 표시 (두 번째 p 태그)
	        previousDiv.find('.edit-form').remove(); // 수정 폼 제거
	        previousDiv.find('.comment-actions').first().show(); // 숨겨졌던 버튼 영역 다시 표시
	    }

	    // 수정하려는 댓글 영역 선택
	    const commentDiv = $(`#comment-\${commentId}`);
	    console.log("현재 댓글 선택됨:", commentDiv);

	    // 이미 수정 중인 상태라면 종료
	    if (commentDiv.find('.edit-form').length > 0) {
	        console.log("이미 수정 중인 폼 존재");
	        return;
	    }
	    
	    // 현재 댓글 내용을 가져오기
	    let currentContent = commentDiv.find('p').eq(1).html(); // .html()로 개행 포함된 내용 가져오기
	    currentContent = currentContent.replace(/<br\s*\/?>/g, "\n"); // <br>을 \n으로 변환

	    // 기존 댓글 내용 숨기기 (여기서 해당 댓글 내용만 숨깁니다)
	    commentDiv.find('p').eq(1).hide();

	    commentDiv.find('.comment-actions').first().hide();

	    // 수정용 textarea와 저장/취소 버튼 추가
	    const editForm = $(`
	        <div class="edit-form mt-2">
	            <textarea id="editContent-\${commentId}" class="form-control" rows="3" style="width:100%;">\${currentContent}</textarea>
	            <div class="mt-2">
	                <button class="btn btn-success btn-sm" onclick="saveEdit(\${commentId})">저장</button>
	                <button class="btn btn-secondary btn-sm" onclick="cancelEdit(\${commentId})">취소</button>
	            </div>
	        </div>
	    `);

	    // 수정 폼을 두 번째 <p> 태그 바로 아래에 추가
	    commentDiv.find('p').eq(1).after(editForm);

	    // 현재 수정 중인 commentId를 기록
	    previousCommentId = commentId;
	}
	
	function cancelEdit(commentId) {
	    const commentDiv = $(`#comment-\${commentId}`);
	    commentDiv.find('p').eq(1).show(); // 숨겨진 댓글 내용을 다시 표시
	    commentDiv.find('.edit-form').remove(); // 수정 폼 제거
	    commentDiv.find('.comment-actions').show(); // 숨겨진 버튼 영역 다시 표시

	    // 이전에 열렸던 댓글 ID 초기화
	    if (previousCommentId === commentId) {
	        previousCommentId = null;
	    }
	}
	
	function saveEdit(commentId) {
	    // 수정된 내용 가져오기
	    const updatedContent = $(`#editContent-\${commentId}`).val();
	
	    // 입력된 내용이 비어 있는지 확인
	    if (!updatedContent || updatedContent.trim() === "") {
	        alert("내용을 입력해주세요.");
	        return;
	    }
	
	    // Fetch API를 통해 수정 요청 전송
	    fetch("${pageContext.request.contextPath}/comment/update", {
	        method: "POST",
	        headers: {
	            "Content-Type": "application/x-www-form-urlencoded",
	        },
	        body: new URLSearchParams({
	            commentId: commentId,
	            content: updatedContent.replace(/\n/g, "\\n"), // 개행 문자 인코딩
	        }),
	    })
	        .then((response) => {
	            if (!response.ok) {
	                // 서버에서 반환된 에러 메시지를 처리
	                return response.text().then((errorMessage) => {
	                    console.error("서버 반환 에러 메시지:", errorMessage); // 에러 메시지 로그 출력
	                    throw new Error(errorMessage); // 에러 메시지를 실제로 던짐
	                });
	            }
	            return response.json(); // 성공 시 JSON 데이터를 반환
	        })
	        .then((updatedComment) => {
	            // DOM에서 해당 댓글 업데이트
	            const commentDiv = $(`#comment-\${commentId}`);
	            
	            commentDiv.find("p").show(); // 기존 숨겨진 댓글 내용 표시
	            commentDiv.find(".edit-form").remove(); // 수정 폼 제거
	            commentDiv.find(".comment-actions").show(); // 수정/삭제 버튼 표시
	
	            // 업데이트된 내용 반영
	            commentDiv.find("p:first").next().replaceWith(`
	                <p style="white-space: pre-wrap;">\${updatedComment.content.replace(/\\n/g, "\n")}</p>
	            `);
	
	            alert("댓글이 성공적으로 수정되었습니다.");
	        })
	        .catch((error) => {
		        console.error(error);
		        alert(error.message || "댓글 수정에 실패했습니다.");
	        });
	}
	
	function deleteComment(commentId) {
	    if (!confirm("댓글을 삭제하시겠습니까?")) {
	        return;
	    }
	
	    // 서버로 삭제 요청 전송
	    fetch("${pageContext.request.contextPath}/comment/remove", {
	        method: "POST",
	        headers: {
	            "Content-Type": "application/x-www-form-urlencoded",
	        },
	        body: new URLSearchParams({
	            commentId: commentId,
	        }),
	    })
        .then((response) => {
            if (!response.ok) {
                // 서버에서 반환된 에러 메시지를 처리
                return response.text().then((errorMessage) => {
                    console.error("서버 반환 에러 메시지:", errorMessage); // 에러 메시지 로그 출력
                    throw new Error(errorMessage); // 에러 메시지를 실제로 던짐
                });
            }
            return response.json(); // 성공 시 JSON 데이터를 반환
        })
	    .then(data => {
	        // DOM에서 해당 댓글 내용 변경
	        const commentDiv = $(`#comment-\${commentId}`);
	        const isAdmin = ${isAdmin};
	        if (isAdmin) {
	        	commentDiv.find("p").first().next().text("관리자에 의해 삭제된 글 입니다."); // 해당 댓글 내용 변경        	
	        } else {
		        commentDiv.find("p").first().next().text("삭제된 글 입니다."); // 해당 댓글 내용 변경        		        	
	        }
	        commentDiv.find(".comment-actions").first().remove();
	        
	        alert(data.message || "댓글이 삭제되었습니다.");
	    })
	    .catch(error => {
	        console.error(error);
	        alert(error.message || "댓글 삭제에 실패했습니다.");
	    });
	}
	
	function reportArticle(articleId) {
	    fetch(`${pageContext.request.contextPath}/article/report?articleId=\${articleId}`, {
	        method: "POST",
	        headers: {
	        	"Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
	        }
	    })
	    .then(response => {
	        if (!response.ok) {
	            throw new Error("신고 처리 중 오류가 발생했습니다.");
	        }
	        return response.text();
	    })
	    .then(message => {
	        alert("신고가 접수되었습니다."); // 서버 응답 메시지 표시
	     	// 버튼 변경 로직
	        const reportButton = document.querySelector(`button[onclick="reportArticle(${articleId})"]`);
	        if (reportButton) {
	            reportButton.classList.remove("btn-outline-danger");
	            reportButton.classList.add("btn-danger");
	            reportButton.setAttribute("disabled", "true");
	            reportButton.innerHTML = `
	                <i class="bi bi-exclamation-triangle-fill"></i> 신고됨
	            `;
	        }
	    })
	    .catch(error => {
	        console.error("신고 처리 중 오류:", error);
	        alert("신고 처리에 실패했습니다.");
	    });
	}
	
    function confirmDelete() {
        return confirm("정말 삭제하시겠습니까?");
    }
    
    function reportComment(commentId) {
        if (!commentId) {
            alert("댓글 ID가 유효하지 않습니다.");
            return;
        }

        const params = new URLSearchParams();
        params.append("commentId", commentId);

        fetch(`${pageContext.request.contextPath}/comment/report`, {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
            },
            body: params.toString()
        })
        .then(response => response.text())
        .then(message => {
            alert(message); // 서버 응답 메시지 표시
        })
        .catch(error => {
            console.error("댓글 신고 처리 중 오류:", error);
            alert("신고 처리에 실패했습니다.");
        });
    }
    
    function handleImagePreview(input) {
        const previewContainer = document.getElementById('imagePreviewContainer');
        previewContainer.innerHTML = ''; // 기존 미리보기 초기화

        if (input.files && input.files[0]) {
            const file = input.files[0];

            // 이미지 파일인지 확인
            if (!file.type.startsWith('image/')) {
                alert('이미지 파일만 선택할 수 있습니다.');
                return;
            }

            // 미리보기 이미지 추가
            const reader = new FileReader();
            reader.onload = function (e) {
                // 이미지 요소 생성
                const imgWrapper = document.createElement('div');
                imgWrapper.style.position = 'relative';
                imgWrapper.style.display = 'inline-block';
                imgWrapper.style.marginRight = '10px';
                
                const img = document.createElement('img');
                img.src = e.target.result;
                img.style.maxWidth = '100px';
                img.style.maxHeight = '100px';
                img.style.borderRadius = '5px';
                imgWrapper.appendChild(img);

                // 삭제 버튼 추가
                const removeButton = document.createElement('button');
                removeButton.innerText = 'X';
                removeButton.style.position = 'absolute';
                removeButton.style.top = '0';
                removeButton.style.right = '0';
                removeButton.style.backgroundColor = 'red';
                removeButton.style.color = 'white';
                removeButton.style.border = 'none';
                removeButton.style.borderRadius = '50%';
                removeButton.style.cursor = 'pointer';
                removeButton.onclick = function () {
                    previewContainer.innerHTML = '';
                    input.value = ''; // 파일 초기화
                };
                imgWrapper.appendChild(removeButton);

                previewContainer.appendChild(imgWrapper);
            };
            reader.readAsDataURL(file);
        }
    }




</script>

</head>
<body class="container py-4">

	<h2 class="text-center">${article.title}</h2>
	<p>
		<strong>작성자:</strong> ${article.user.nickname}
	</p>

	<!-- 작성일과 버튼을 하나의 줄에 정렬 -->
	<div class="d-flex justify-content-between align-items-center mb-4">
		<div>
			<!-- 작성일 -->
			<p class="mb-0">
				<strong>작성일:</strong> ${article.createdAt}
			</p>
			<p></p>
			<p class="mb-0">
				<strong>조회수:</strong> ${article.views}
			</p>			
		</div>
		<!-- 목록으로 돌아가기, 수정, 삭제 버튼 -->
		<div>
			<button class="btn btn-secondary me-2"
				onclick="location.href='${pageContext.request.contextPath}/article/articleList?pageIndex=${pageIndex}&searchCondition=${searchCondition}&searchKeyword=${searchKeyword}&timeRange=${timeRange}&sortBy=${sortBy}&sortOrder=${sortOrder}'">
				목록으로 돌아가기</button>

			<c:if test="${article.user.id == user.id}">
				<button class="btn btn-warning me-2"
					onclick="location.href='${pageContext.request.contextPath}/article/update/${article.articleId}'">
					수정</button>
			</c:if>
			<c:if test="${article.user.id == user.id || user.roleType == 'ADMIN'}">
				<form
					action="${pageContext.request.contextPath}/article/delete/${article.articleId}"
					method="post" style="display: inline-block;" onsubmit="return confirmDelete();">
					<input type="hidden" name="_method" value="delete">
					<button type="submit" class="btn btn-danger">삭제</button>
				</form>
			</c:if>
			<!-- 작성자가 아닌 경우 '신고' 버튼 표시 -->
			<c:if test="${article.user.id != user.id && article.user.roleType != 'ADMIN' && user.roleType != 'ADMIN'}">
			    <c:if test="${reportCheck}">
			        <button class="btn btn-danger" disabled>
			            <i class="bi bi-exclamation-triangle-fill"></i> 신고됨
			        </button>
			    </c:if>
			    <c:if test="${!reportCheck}">
			        <button class="btn btn-outline-danger" onclick="reportArticle(${article.articleId})">
			            <i class="bi bi-exclamation-triangle-fill"></i> 신고
			        </button>
			    </c:if>
			</c:if>
		</div>
	</div>
	<div id="content" class="border mb-4" style="padding: 10px; white-space: pre;">
		<c:out value="${article.content}" escapeXml="false"/>
	</div>
	
	<!-- 첨부파일 목록 표시 -->
	<c:if test="${not empty articleFiles}">
	    <div class="mb-3">
	        <label><strong>파일 목록</strong></label>
	        <ul class="list-unstyled">
	            <c:forEach var="file" items="${articleFiles}">
	                <li>
	                    <a href="${pageContext.request.contextPath}/article/file/download?fileUrl=${file.fileUrl}&fileName=${file.fileName}" download="${file.fileName}">
	                        ${file.fileName} (${file.formattedFileSize})
	                    </a>
	                </li>
	            </c:forEach>
	        </ul>
	    </div>
	</c:if>

	<!-- 댓글 작성 폼 -->
	<div class="mb-4">
	    <c:if test="${not empty user}">
	        <div class="form-group mb-2 comment-inbox">
	            <label><strong>댓글작성</strong></label>
	            
	            <!-- 텍스트 입력 영역 -->
	            <textarea id="commentContent" rows="3" class="form-control"
	                      placeholder="댓글을 입력하세요" maxlength="50" required
	                      oninput="checkCommentLength()"></textarea>
	
	            <!-- 이미지 미리보기 및 첨부 영역 -->
	            <div id="imagePreviewContainer" class="d-flex flex-wrap mt-2"></div>
	
	            <!-- 버튼 영역 -->
	            <div class="d-flex align-items-center mt-2">
	                <label for="imageUpload" class="btn btn-light me-2">
	                    <i class="bi bi-camera"></i> 사진 추가
	                </label>
	                <input type="file" id="imageUpload" accept="image/*" style="display: none;" onchange="handleImagePreview(this)" />
	                
	                <button type="button" class="btn btn-primary"
	                        onclick="submitComment(${articleId}, 0, 0);">등록</button>
	            </div>
	
	            <input type="hidden" id="articleId" value="${articleId}" />
	            <input type="hidden" id="userId" value="${user.id}" />
	        </div>
	    </c:if>
	</div>


	<!-- 댓글 표시 영역 -->
	<div id="commentListContainer" class="mb-4">
		<!-- 댓글 데이터가 이곳에 렌더링됩니다 -->
	</div>

</body>
</html>
