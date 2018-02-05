<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/include/include-header.jsp" %>   
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
<meta name="description" content="">
<meta name="author" content="">
<link rel="stylesheet" type="text/css" href="<c:url value='/common/css/login.css'/>" />
<title>::좋은사람 - 로그인 페이지</title>
<script type="text/javascript">
$(function(){
var id	= $('#id');
var pwd	= $('#pwd');
var regId 	  = /[a-z0-9_]{3,20}$/gi;
var regPw 	  = /[ㄱ-ㅎㅏ-ㅣ가-힣`.,\[\]\{\}\(\)\-=~;|\\\'\";:\/?]/g; //한글입력 방지
//g 	: 문자열 내의 모든 패턴 체크
//i		: 대소문자를 구별하지 않음
//m 	: 여러줄에 걸쳐서 체크


	
	$('#pwd').css({"ime-mode" : "disabled"}); // ie 한글 입력 방지
	
	$('input[name="submit"]').on("click", function(){
		if(id.val() == ""){
			alert("아이디를 입력하세요.");
			id.focus();
			return false;
		}
		if(pwd.val() == ""){
			alert("비밀번호를 입력하세요.");
			pwd.focus();
			return false;
		}
		
		if(!regId.test(id.val())){
			alert("아이디와 비밀번호를 확인하세요.");
			id.val('');
			pwd.val('');
			id.focus();
			return false;
		}//id
		if(!regPw.test(pwd.val())){
			alert("아이디와 비밀번호를 확인하세요.");
			id.val('');
			pwd.val('');
			pwd.focus();
			return false;
		}//pwd
		
		//스피링 시큐리티는 j_spring_security_check 에서 로그인 처리를 POST방식으로 처리한다
		$("#login_f").attr("action", "<c:url value='/j_spring_security_check'/>");
		$("#login_f").attr("method", "post");
		$("#login_f").submit();
	});
	
	//아이디 비밀번호 찾기 창
	var window_left = (screen.width-400)/2;         
    var window_top = (screen.height-450)/2;
	
    $("#findId").click(function(){
		var url = "<c:url value='/user/findIdPw/findId.do'/>";
		window.open(url,"popup_find","width=380, height=300, scrollbars=no,resizable=yes, status=no, top="+window_top+", left=" + window_left);
	});
	$("#findPw").click(function(){
		var url = "<c:url value='/user/findIdPw/findPw.do'/>";
		window.open(url,"popup_find","width=380, height=300, scrollbars=0, resizable=yes, status=no, top="+window_top+", left=" + window_left);
	});
	
})
</script>
</head>
<body onload="document.login_f.id.focus()">
<div id="wrap_container">
	<main class="main">
		<div class="main_gnb">
			<div class="main_logo">
				<img alt="/common/images/logo/main_logo.png" src="<c:url value='/common/images/logo/main_logo.png'/>" onclick="location.href='<c:url value="/main.do"/>'"/>
			</div><!-- main_logo  -->
			
			<div class="main_user_btn">
				<!-- sec:authorize태그는 access 속성에 설정된 권한을 가진 사람이 접근하면, 해당 태그 이하에 설정된 내용을 보여줄 수 있다.
					  사용자의 권한에 따라 보여줄 수 있는 화면을 설정할 수 있다.
					  sec:authentication 태그는 사용자의 정보를 보여준다. sec:authorize태그 하위등에서 사용하여(단독사용 가능), 사용자 정보(name등)를 표현할 수 있다.
				 -->
				<ul>
					<sec:authorize access="!isAuthenticated()">
						<li><a href="<c:url value='/user/login/login.do'/>" style="color: #fff">로그인</a></li>
						<li><a href="<c:url value='/user/join/AgreementTerms.do'/>" style="color: #fff">회원가입</a></li>
					</sec:authorize>
				</ul>
			</div><!-- main_user_btn -->
			
			<div class="main_nav_wrapper">
				<nav class="main_nav">
					<ul>
						<li><a id="main_nav_community" href="javascript:;">- 커뮤니티</a></li>
						<li><a id="main_nav_notice" href="javascript:;">- 건의&공지</a></li>
					</ul>
				</nav>
				<nav class="main_nav_category">
					<ul id="main_nav_community_category" class="main_nav_category_off">
						<li><a href="<c:url value='/board/openBoardList.do'/>">ㄴ유머</a></li>
						<li><a href="javascript:;">ㄴQ&A</a></li>
					</ul>
					<ul id="main_nav_notice_category" class="main_nav_category_off">
						<li><a href="javascript:;">ㄴ공지사항</a></li>
						<li><a href="javascript:;">ㄴ건의사항</a></li>
					</ul>
				</nav>
			</div><!-- main_nav_wrapper -->
		</div><!-- .main_gnb -->
		
		
		<!-- It's the main contents area after this line. -->
		<div class="view_notice">
			<h1>로그인</h1>
		</div>
		
		<div id="login_contetnt_wrapper" class="board_content_wrapper">
			<div id="login_area_wrapper" class="login_area_wrapper">
				<div class="area_notice"><h5>로그인</h5></div>
				<div class="login_area">
					<form id="login_f" name="login_f">
							<div class="login_id_wrapper"><input type="text" id="id" name="id" maxlength="20" placeholder="아이디" class="login_id"/></div>
							<div class="login_pwd_wrapper"><input type="password" id="pwd" name="pwd" maxlength="20" placeholder="비밀번호" class="login_pwd"/></div>
							<div class="login_btn_wrapper"><input type="submit" name="submit" value="로그인" class="btn"></div>
					</form>
				</div>
				<div class="login_link_wrapper">
					<div class="link_signIn_And_Find_AccountInfo">
						<!-- 아이디,비밀번호 찾기 - UserController / 회원가입 - JoinController -->
						<a href="javascript:;" id="findId">아이디 찾기</a><span class="link_seperator">/</span>
						<a href="javascript:;" id="findPw">비밀번호 찾기</a><span class="link_seperator">/</span> 
						<a href="<c:url value='/user/join/AgreementTerms.do'/>">회원가입</a>
					</div>
				</div>
			</div>
			
			<!-- alert warning -->
			<c:if test="${not empty param.fail}">
				<div class="alert_warning_wrapper">
					<div id="alert_warning" class="alert_warning">
						<p>로그인 실패! ID와 비밀번호를 확인하세요.</p>
						<p>원인 : ${sessionScope["SPRING_SECURITY_LAST_EXCEPTION"].message}</p>
						<c:remove scope="session" var="SPRING_SECURITY_LAST_EXCEPTION"/>
						<!-- 로그인 error 원인을 가지고 있는 객체를 사용 후 remove. -->
					</div>
				</div>
			</c:if>
		</div>
	</main>
</div><!-- wrap_container -->
</body>
</html>