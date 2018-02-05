<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jsp" %>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
<meta name="description" content=""><!-- 검색엔진의 검색결과에 처음 나오는 설명문. -->
<meta name="author" content="">
<title>:: 좋은사람</title>
<script type="text/javascript">
$(function(){
	$("a[id='title']").on("click", function(e){ //제목 
        e.preventDefault();
        fn_openBoardDetail($(this));
    });	
});//jQuery

window.onload = function(){
	var obj	=	document.getElementsByName("crea_date");
	
	calDate(obj)
}//window.onload

//// 두 날짜의 차이를 시간, 일 단위로 계산
function calDate(obj){
	var today		= new Date();
	var date;
	//var date  		= new Date($('#crea_date').text());
	
	for(var i=0; i<obj.length; i++){
		date = new Date(obj[i].innerHTML); 
		// (대상) / 밀리 / 분 / 시간;
		// 86400초 가 대상이라면,
		// 86400 / 60 = 1440분.
		// 1440 / 60 = 24시간.
		var calTime	= (today - date) / 1000 / 60 / 60; // 현재시간 밀리초/초/분/시
		var result; // 최종결과.
		
		//calTime 변수 초기화 시, Math.floor를 하지 않는다.
		//초, 분단위 if문에서 0으로 나오기때문이다.
		//calTime에 들어가는 값은 숫자형이므로, indexOf 안먹힘. 소수점 이하 버리기.
		if(calTime < 24){//23시간까진 '시간 전'으로 설정.
			if(calTime < 1){//글이 작성된지 1시간도 안될 경우. 0.x시간.
				if(calTime*60 < 60){// 59분까진 시간이 아닌 '분 전'으로 설정.
					result = (Math.floor(calTime*60))+"분 전";
				}else if(calTime*60*60 < 60){// 59초까진 1분 전으로 친다.
					result = "1분 전";
				}//end inner if-else if
			}else{//23시간까진 '시간 전'으로 설정.
				result = Math.floor(calTime) + "시간 전";
			}//end if-else
		}else{
			result = (Math.floor(calTime/24))+"일 전";
		}//end if-else
		obj[i].innerHTML =result;
	}//end for
}//calDate()

function fn_openBoardDetail(obj){
    var comSubmit = new ComSubmit();
    comSubmit.setUrl("<c:url value='/board/openBoardDetail.do' />");
    comSubmit.addParam("IDX", obj.parent().find("#IDX").val());
    comSubmit.submit();
}//openBoardDetail()

</script>
</head>
<body>
<div id="wrap_container">
	<main class="main">
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
					
					<%-- 2016.08.11 수정.
					로그인 인증이 되면 매니저든 관리자든 유저든 내 정보 보기 창에 들어갈 수 있도록 수정.
					<sec:authorize access="hasAuthority('ROLE_USER')">
						<li><a href="<c:url value='/user/modifyInfo.do?auth=false&fail=false' />" style="color: #fff">내 정보</a></li>
					</sec:authorize> --%>
				
					<sec:authorize access="!isAuthenticated()">
						<li><a href="<c:url value='/user/login/login.do'/>" style="color: #fff">로그인</a></li>
						<li><a href="<c:url value='/user/join/AgreementTerms.do'/>" style="color: #fff">회원가입</a></li>
					</sec:authorize>
				
					<sec:authorize access="isAuthenticated()">
						<li><a href="<c:url value='/user/modifyInfo.do?auth=false&fail=false' />" style="color: #fff">내 정보</a></li>
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
		
		
		<!-- It's the main contents area after this line. -->
		<div class="main_banner_wrapper">
			<div class="main_banner">
				<a href="http://www.naver.com">
					<img src="http://file.okky.kr/banner/main-banner-2252cf44f7298664be7b0bd131311412.jpg">
				</a>
			</div>
		</div><!-- main_banner_wrapper  -->
		
		<div id="board_content_wrapper" class="board_content_wrapper">
			<div class="board_newestItem_wrapper">
				<div class="board_notice">
					<h3><a href="<c:url value='/board/openBoardList.do'/>">+유머</a></h3>
				</div>
					<div class="board_newestItem_area">
						<c:choose>
			            <c:when test="${fn:length(items) > 0}">
			                <c:forEach items="${items}" var="row">
		                        <div class="board_newestItem_item">
		                        	<div class="board_newestItem_title">
			                        	<a href="#this" id="title">${row.TITLE }</a>
			                        	<input type="hidden" id="IDX" value="${row.IDX }">
		                        	</div>
		                        	<div class="board_newestItem_info"><!-- ${fn:substring(row.CREA_DTM, 0, 16)} -->
				                        <span name="crea_date" class="pull_right">${fn:substring(row.CREA_DTM, 0, 16)}</span>
				                        <span class="pull_right bold_text">${row.CREA_ID }</span>
			                        </div>
		                        </div>
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
				</div><!-- board_newestItem_area -->
			</div><!-- board_newestItem_wrapper -->
		</div><!-- board_content_wrapper -->
		<jsp:include page="/WEB-INF/include/include-body.jsp" />
	</main>
</div><!-- wrap_container -->
</body>
</html>