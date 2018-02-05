<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jsp" %>        
<!DOCTYPE html>
<html>
<head>
<title>:: 게시글 수정</title>
<script type="text/javascript">
var gfv_count = '${fn:length(list)}';


function fn_openBoardList(){
    var comSubmit = new ComSubmit();
    comSubmit.setUrl("<c:url value='/board/openBoardList.do' />");
    comSubmit.submit();
}//fn_openBoardList()
function fn_updateBoard(){
    var comSubmit = new ComSubmit("frm");
    $('#CONTENTS').val().replace(/\n/g, "<br/>");
    
    comSubmit.setUrl("<c:url value='/board/updateBoard.do' />");
    comSubmit.submit();
}//fn_updateBoard()
function fn_deleteBoard(){
    var comSubmit = new ComSubmit();
    comSubmit.setUrl("<c:url value='/board/deleteBoard.do' />");
    comSubmit.addParam("IDX", $("#IDX").val());
    comSubmit.submit();
}//fn_deleteBoard()
function fn_addFile(){
		var addObj = "<div class='attachment'><span style='margin-right:4px;'><input type='file' name='file_"+(gfv_count)+"'></span>"+
		"<span><a href='#this' class='btn' id='delete_"+(gfv_count)+"' name='delete_"+(gfv_count++)+"'>삭제</a></span></div>";
		$("#fileDiv").append(addObj);
		$("a[name^='delete']").on("click", function(e){
			e.preventDefault();
			fn_deleteAddFile($(this)); // a 태그의 name값이 deleteAddFile인게 넘어간다.
		});
}//fn_addFile()
function fn_deleteAddFile(obj){
		obj.parent().parent().remove();
}//fn_deleteAddFile

	
$(function(){
	$("#list").on("click", function(e){ //목록으로 버튼
        e.preventDefault();
        fn_openBoardList();
    });
     
    $("#update").on("click", function(e){ //저장하기 버튼
        e.preventDefault();
        fn_updateBoard();
    });
     
    $("#delete").on("click", function(e){ //글삭제하기 버튼
        e.preventDefault();
        fn_deleteBoard();
    });
    $("#addFile").on("click", function(e){ // 첨부파일 추가 버튼
		e.preventDefault();
		fn_addFile();
	});
	$("a[id^='delete']").on("click", function(e){ // 첨부파일 삭제 버튼
		e.preventDefault();
		fn_deleteAddFile($(this));
	});
});//jQuery

</script>
</head>
<body>
<div class="wrap">
	<div class="main_gnb">
		<div class="main_user_info">
			<sec:authorize access="isAuthenticated()">
				<div>
					<!-- 사용자가 로그인(인증)을 하지 않았으므로(isAuthenticated()) 아래의 코드는 출력되지 않는다. -->
					<!-- context-security.xml의 authentication-manager태그 부분의 name 값  -->
					<!-- authentication의 property에 id 값을 불러오는 프로퍼티값은 여러 개가 있다 (name, username, principal.username 등등) -->
					<!-- 안불러와지거나 그런 프로퍼티 없다고 에러뜨면 하나씩 다 해볼 것. -->
					<strong><sec:authentication property="name" var="sec_id"/>${sec_id}</strong>님 환영합니다.<br/>
					<c:set var="sec_id" value="${sec_id}" scope="page"></c:set>
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
		</div><!-- main_user_info -->
		
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
	
	<main class="main">
		<form id="frm" name="frm" enctype="multipart/form-data">
	        <table class="board_view">
	            <colgroup>
	                <col width="15%"/>
	                <col width="35%"/>
	                <col width="15%"/>
	                <col width="35%"/>
	            </colgroup>
	            <caption>게시글 상세</caption>
	            <tbody>
	                <tr>
	                    <th scope="row">글 번호</th>
	                    <td>
	                        ${map.IDX }
	                        <input type="hidden" id="IDX" name="IDX" value="${map.IDX }">
	                    </td>
	                    <th scope="row">조회수</th>
	                    <td>${map.HIT_CNT }</td>
	                </tr>
	                <tr>
	                    <th scope="row">작성자</th>
	                    <td>${map.CREA_ID }</td>
	                    <th scope="row">작성시간</th>
	                    <td>${map.CREA_DTM }</td>
	                </tr>
	                <tr>
	                    <th scope="row">제목</th>
	                    <td colspan="3">
	                        <input type="text" id="TITLE" name="TITLE" class="wdp_90" value="${map.TITLE }"/>
	                    </td>
	                </tr>
	                <tr>
	                    <td colspan="4" class="view_text">
	                        <textarea rows="20" cols="100" title="내용" id="CONTENTS" name="CONTENTS">${map.CONTENTS }</textarea>
	                    </td>
	                </tr>
	                 <tr>
	                    <th scope="row">첨부파일</th>
	                    <td colspan="3">
	                        <div id="fileDiv">                
	                            <c:forEach var="row" items="${list }" varStatus="var">
	                                <div class="attachment">
	                                    <input type="hidden" id="IDX" name="IDX_${var.index }" value="${row.IDX }">
	                                    <span><a href="#this" id="name_${var.index }" name="name_${var.index }">${row.ORIGINAL_FILE_NAME }</a></span>
	                                    <span><input type="file" id="file_${var.index }" name="file_${var.index }"> (${row.FILE_SIZE } KB)</span>
	                                    <span><a href="#this" class="btn" id="delete_${var.index }" name="delete_${var.index }">삭제</a></span>
	                                </div>
	                            </c:forEach>
	                        </div>
	                    </td>
	                </tr>
	            </tbody>
	        </table>
	    </form>
	     
	    <!-- onclick 이벤트 리스너로, JQuery에서 .on("click") 지정 없이 바로 function과 연계 가능  -->
	    
	    <a href="#this" class="btn" id="addFile">파일 추가</a>
	    <a href="#this" class="btn" id="list">목록으로</a>
	    <a href="#this" class="btn" id="update">저장하기</a>
	    <a href="#this" class="btn" id="delete">삭제하기</a>
	    
		<jsp:include page="/WEB-INF/include/include-body.jsp" />
	</main>

</div><!-- wrap -->
</body>
</html>