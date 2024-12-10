package egovframework.LocalBoard.dto;

public class Pagination {

    private int pageIndex = 1;          // 현재 페이지 번호 (기본값 1)
    private int articleSize = 10; 		// 한 페이지에 표시할 레코드 수 (기본값 10)
    private int articleTotal;       	// 전체 레코드 수 (예: 총 게시물 수)
    private int pageGroupSize = 5;      // 페이지 그룹 크기 (한 번에 표시할 페이지 수)
    private int offset;					// 조회할 게시글 시작점 
    
    // 검색 관련 필드 추가
    private String searchCondition = "";   // 검색 조건 (작성자, 제목, 전체)
    private String searchKeyword = "";     // 검색어
    private String timeRange = "";         // 기간 필터 (1년, 1달, 1주, 전체)
    
    // 정렬 관련 필드 추가
    private String sortBy = "created_at"; // 정렬 기준 (created_at 또는 views)
    private String sortOrder = "desc";    // 정렬 순서 (asc 또는 desc), 기본값은 'desc'

    // 전체 페이지 수를 계산합니다.
    public int getTotalPages() {
        return (int) Math.ceil((double) articleTotal / articleSize);
    }

    // 현재 페이지 그룹의 시작 페이지 번호를 계산합니다.
    public int getStartPage() {
        int currentGroup = (pageIndex - 1) / pageGroupSize;  // 현재 페이지 그룹 계산
        return currentGroup * pageGroupSize + 1;
    }

    // 현재 페이지 그룹의 마지막 페이지 번호를 계산합니다.
    public int getEndPage() {
        int endPage = getStartPage() + pageGroupSize - 1;
        return Math.min(endPage, getTotalPages());
    }

    // 이전 페이지 그룹의 첫 페이지 번호를 계산합니다.
    public int getPrevGroupPage() {
        return Math.max(getStartPage() - pageGroupSize, 1);
    }

    // 다음 페이지 그룹의 첫 페이지 번호를 계산합니다.
    public int getNextGroupPage() {
        return Math.min(getEndPage() + 1, getTotalPages());
    }

	public int getPageIndex() {
		return pageIndex;
	}

	public void setPageIndex(int pageIndex) {
		this.pageIndex = pageIndex;
	}

	public int getArticleSize() {
		return articleSize;
	}

	public void setArticleSize(int articleSize) {
		this.articleSize = articleSize;
	}

	public int getArticleTotal() {
		return articleTotal;
	}

	public void setArticleTotal(int articleTotal) {
		this.articleTotal = articleTotal;
	}

	public int getPageGroupSize() {
		return pageGroupSize;
	}

	public void setPageGroupSize(int pageGroupSize) {
		this.pageGroupSize = pageGroupSize;
	}
	
	public int getOffset() {
		return offset;
	}
	
	// 현재 페이지의 게시물 시작 위치
	public void setOffset() {
	    this.offset = Math.max((pageIndex - 1) * articleSize, 0);
	}
	
	// 검색 조건 get, set
	public String getSearchCondition() {
		return searchCondition;
	}

	public void setSearchCondition(String searchCondition) {
		this.searchCondition = searchCondition;
	}

	public String getSearchKeyword() {
		return searchKeyword;
	}

	public void setSearchKeyword(String searchKeyword) {
		this.searchKeyword = searchKeyword;
	}

	public String getTimeRange() {
		return timeRange;
	}

	public void setTimeRange(String timeRange) {
		this.timeRange = timeRange;
	}

	public String getSortBy() {
		return sortBy;
	}

	public void setSortBy(String sortBy) {
		this.sortBy = sortBy;
	}

	public String getSortOrder() {
		return sortOrder;
	}

	public void setSortOrder(String sortOrder) {
		this.sortOrder = sortOrder;
	}

	public void setOffset(int offset) {
		this.offset = offset;
	}

	@Override
	public String toString() {
		return "Pagination [pageIndex=" + pageIndex + ", articleSize=" + articleSize + ", articleTotal=" + articleTotal
				+ ", pageGroupSize=" + pageGroupSize + ", offset=" + offset + ", searchCondition=" + searchCondition
				+ ", searchKeyword=" + searchKeyword + ", timeRange=" + timeRange + "]";
	}
	
	public String toStringAll() {
        return "Pagination [pageIndex=" + pageIndex 
                + ", articleSize=" + articleSize 
                + ", articleTotal=" + articleTotal 
                + ", pageGroupSize=" + pageGroupSize 
                + ", offset=" + offset 
                + ", searchCondition=" + searchCondition 
                + ", searchKeyword=" + searchKeyword 
                + ", timeRange=" + timeRange 
                + ", totalPages=" + getTotalPages() 
                + ", startPage=" + getStartPage() 
                + ", endPage=" + getEndPage() 
                + ", prevGroupPage=" + getPrevGroupPage() 
                + ", nextGroupPage=" + getNextGroupPage() 
                + "]";
    }
	
}


