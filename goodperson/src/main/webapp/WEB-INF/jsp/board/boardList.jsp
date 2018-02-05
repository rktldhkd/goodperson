<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>:: 게시판</title>
<script type="text/javascript">
function fn_openBoardWrite(){
    var comSubmit = new ComSubmit();
    comSubmit.setUrl("<c:url value='/board/openBoardWrite.do' />");
    comSubmit.submit();
}//openBoardWrite()
function fn_openBoardDetail(obj){
    var comSubmit = new ComSubmit();
    comSubmit.setUrl("<c:url value='/board/openBoardDetail.do' />");
    comSubmit.addParam("IDX", obj.parent().find("#IDX").val());
    comSubmit.addParam("TotalComments", obj.parent().find("#COMMENTS_COUNT").val());
    comSubmit.submit();
}//openBoardDetail()
function fn_search(pageNo){
	//pageNo 변수는 스프링(전자정부)에서 알아서 얻어온다.
	//jsFunction에는 fn_search라고 선언만 되어있지만, 실제 실행된 페이지의
	//소스를 개발자도구로 보면, fn_search(n) 형식으로 스프링(전자정부)에서 알아서 뿌려주고 있다.
	var comSubmit = new ComSubmit();
	comSubmit.setUrl("<c:url value='/board/openBoardList.do' />");
	comSubmit.addParam("currentPageNo", pageNo);
	comSubmit.submit();
}//fn_search()
function fn_search_keyword(){
	/* new ComSubmit('폼 네임') 선언 시, 해당 폼 네임의 폼의 데이터들은 addParam() 메소드 
		사용 안해도 넘어 간다.
		$("#ddl > option:selected").val();
		[출처] jquery radio checked, select option selected|작성자 프리윈드
	*/
	var comSubmit = new ComSubmit('search_f');
	comSubmit.setUrl("<c:url value='/board/searchBoardItem.do' />");
	comSubmit.addParam("search_type", $("#search_type > option:selected").val());
	comSubmit.submit();
}//fn_search_keyword()

$(function(){
	 $("#write").on("click", function(e){ //글쓰기 버튼
         e.preventDefault();
         fn_openBoardWrite();
     }); 
	 
	 $("input[id='search_item']").on("click", function(e){// 게시판 특정 글 검색
		e.preventDefault();
		fn_search_keyword();	 	
	 })
      
     $("a[id='title']").on("click", function(e){ //제목 
         e.preventDefault();
         fn_openBoardDetail($(this));
     });
})
</script>
</head>
<body>
<div id="wrap_container">
	<div class="main_gnb">
		<div class="main_logo">
			<img alt="/common/images/logo/main_logo.png" src="<c:url value='/common/images/logo/main_logo.png'/>" onclick="location.href='<c:url value="/main.do"/>'"/>
		</div><!-- main_logo  -->
		
		<div class="main_user_info">
			<sec:authorize access="isAuthenticated()">
				<div>
					<!-- 사용자가 로그인(인증)을 하지 않았으므로(isAuthenticated()) 아래의 코드는 출력되지 않는다. -->
					<!-- context-security.xml의 authentication-manager태그 부분의 name 값  -->
					<!-- authentication의 property에 id 값을 불러오는 프로퍼티값은 여러 개가 있다 (name, username, principal.username 등등) -->
					<!-- 안불러와지거나 그런 프로퍼티 없다고 에러뜨면 하나씩 다 해볼 것. -->
					<strong><sec:authentication property="name"/></strong>님 환영합니다.<br/>
				</div>
				<div class="user_roles_notice">	
					<sec:authentication property="authorities" var="roles"/>
					Your roles are 
					<ul>
						<c:forEach var="role" items="${roles}">
							<li><font size="2">● ${role}</font></li>
						</c:forEach>
					</ul>
					<!--  ==${sessionScope.userLoginInfo.username}님 환영합니다. -->
				</div>
				<div class="user_roles_notice" style="overflow: scroll;">
					이름 : <sec:authentication property="name"/><br/><!-- 'principal.username' property와 같다. -->
					IP : <sec:authentication property="details"/><!-- 세션 아이디, 원격 IP 주소 등.. -->
				</div>
			</sec:authorize>	
		</div>
		
		<div class="main_user_btn">
			<!-- sec:authorize태그는 access 속성에 설정된 권한을 가진 사람이 접근하면, 해당 태그 이하에 설정된 내용을 보여줄 수 있다.
				  사용자의 권한에 따라 보여줄 수 있는 화면을 설정할 수 있다.
				  sec:authentication 태그는 사용자의 정보를 보여준다. sec:authorize태그 하위등에서 사용하여(단독사용 가능), 사용자 정보(name등)를 표현할 수 있다.
			 -->
			<ul>
				<sec:authorize access="hasAnyAuthority('ROLE_MANAGER', 'ROLE_ADMIN')">
					<li><a href="<c:url value='/manager/main.do' />" style="color: #fff">회원 관리</a></li>
				</sec:authorize>
				
				<sec:authorize access="hasAuthority('ROLE_USER')">
					<li><a href="<c:url value='/user/modifyInfo.do?auth=false&fail=false' />" style="color: #fff">내 정보</a></li>
				</sec:authorize>
			
				<sec:authorize access="!isAuthenticated()">
					<li><a href="<c:url value='/user/login/login.do'/>" style="color: #fff">로그인</a></li>
					<li><a href="<c:url value='/user/join/AgreementTerms.do'/>" style="color: #fff">회원가입</a></li>
				</sec:authorize>
			
				<sec:authorize access="isAuthenticated()">
					<li><a href="<c:url value='/j_spring_security_logout' />" style="color: #fff">로그아웃</a></li>
				</sec:authorize>
			</ul>
		</div><!-- main_user_btn -->
		
		<div class="main_nav_wrapper">
			<nav class="main_nav">
				<ul>
					<li><a id="main_nav_community" href="javascript:;">- 커뮤니티</a></li>
					<li><a id="main_nav_notice" href="javascript:;">- 건의&amp;공지</a></li>
				</ul>
			</nav>
			<nav class="main_nav_category">
				<ul id="main_nav_community_category" class="main_nav_category_off">
					<li><font>[커뮤니티]</font></li>
					<li><a href="<c:url value='/board/openBoardList.do'/>">ㄴ유머</a></li>
					<li><a href="javascript:;">ㄴQ&amp;A</a></li>
				</ul>
				<ul id="main_nav_notice_category" class="main_nav_category_off">
					<li><font>[건의&amp;공지]</font></li>
					<li><a href="javascript:;">ㄴ공지사항</a></li>
					<li><a href="javascript:;">ㄴ건의사항</a></li>
				</ul>
			</nav>
		</div><!-- main_nav_wrapper -->
	</div><!-- .main_gnb -->
	
	
	<!-- begin content -->
	<main id="content" class="main">
		<div class="content_header">
			<h2 class="section_title" onclick="location.href='<c:url value="/main.do"/>'">:: 게시판 목록</h2>
			<span class="btn_area pull_right">
				<sec:authorize access="hasAnyAuthority('ROLE_MANAGER', 'ROLE_ADMIN', 'ROLE_USER')">
					<a href="#this" class="btn-success btn-wide" id="write">글 쓰기</a>
				</sec:authorize>
			</span>
			
			<div class="boardList_search_wrapper">
				<div class="boardList_search_area">
					<form name="search_f" id="search_f">
						<span class="pull_right display_tbl">
							<select class="search_type" id="search_type">
								<option value="TITLE" id="TITLE">제목</option>
								<option value="CREA_ID" id="CREA_ID">작성자</option>
								<option value="CONTENTS" id="CONTENTS">내용</option>
							</select>
							<input type="text" name="search_keyword" id="search_keyword" value="${search_keyword}" class="search_input display_tblCell" maxlength="16" size="16"/>
							<span class="boardList_search_btn display_tblCell">
								<input type="submit" id="search_item" value="찾기" class="search_btn"/>
							</span>
						</span>
					</form>
				</div><!-- boardList_search_area -->
			</div><!-- boardList_search_wrapper -->
		</div><!-- end content_header -->
		<table style="border:1px solid #ccc" class="board_list">
		    <colgroup>
		        <col width="10%"/>
		        <col width="*"/>
		        <col width="15%"/>
		        <col width="15%"/>
		        <col width="20%"/>
		    </colgroup>
		    <thead>
		        <tr>
		            <th scope="col">글번호</th>
		            <th scope="col">제목</th>
		            <th scope="col">작성자</th>
		            <th scope="col">조회수</th>
		            <th scope="col">작성일</th>
		        </tr>
		    </thead>
		    <tbody>
		    <%-- paginationInfo의 총 레코드 수 : ${paginationInfo.getTotalRecordCount() } --%>
		        <c:choose>
		            <c:when test="${fn:length(list) > 0 and paginationInfo.getTotalRecordCount() > 0}">
		                <c:forEach items="${list }" var="row">
		                    <tr>
		                        <td>${row.IDX }</td>
		                        <td class="title">
		                        	<a href="#this" id="title">${row.TITLE }</a>
		                        	<c:if test="${row.COMMENTS_COUNT > 0}">
		                        		<span><font size="2px" color="#04CB04">[${row.COMMENTS_COUNT}]</font></span>
		                        	</c:if>
		                        	<input type="hidden" id="IDX" value="${row.IDX }">
		                        	<input type="hidden" id="COMMENTS_COUNT" value="${row.COMMENTS_COUNT }">
		                        </td>
		                        <td>${row.CREA_ID }</td>
		                        <td>${row.HIT_CNT }</td>
		                        <td>${row.CREA_DTM }</td>
		                    </tr>
		                </c:forEach>
		            </c:when>
		            <c:otherwise>
		                <tr>
		                    <td colspan="5">
		                    	<p class="search_result">
		                    		<span class="highlight_text">'${search_keyword}'</span> 검색 결과
		                    	</p>
		                    	<p>	
		                    		조회된 결과가 없습니다.
		                    	</p>
		                    </td>
		                </tr>
		            </c:otherwise>
		        </c:choose>
		    </tbody>
		</table>
		
		<div class="board_paging_wrapper">
			<div class="board_paging_area">
				<ul>
					<!-- 페이징(전자정부) -->
					<!-- jsFunction 속성은 페이징 태그를 클릭 시, 수행할 함수를 의미한다. -->
					<c:if test="${not empty paginationInfo}">
						<ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_search"/>
					</c:if>
				</ul>
				<input type="hidden" id="currentPageNo" name="currentPageNo"/><!-- 현재 페이지 번호 -->
			</div>
		</div>
		<br/>
		
		<jsp:include page="/WEB-INF/include/include-body.jsp" />
	</main>
	<!-- end contents -->
	
</div>
</body>
</html>