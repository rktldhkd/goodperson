<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jsp" %>   
<!DOCTYPE html>
<html>
<head>
<title>::좋은 사람 - 회원 정보 수정</title>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
<meta name="description" content="">
<meta name="author" content="">
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.3/themes/smoothness/jquery-ui.css">
<style>
/* 요일(한글/영문)에 색상 표시 */
.ui-datepicker-week-end:first-child{color:#f00;}
/* IE 8이하는 :last-child 동작 안함, beforeShowDay 함수 호출시 saturday class를 return으로 처리 */
.ui-datepicker-week-end:last-child{color:#00f;}
/* 날짜(일)에 색상 표시 */
.ui-datepicker-calendar > tbody td:first-child a {COLOR: #f00;}
.ui-datepicker-calendar > tbody td:last-child a {COLOR: blue;}

/* 선택한날짜 색상 변경 */
.ui-state-active, .ui-widget-content .ui-state-active, .ui-widget-header .ui-state-active {  
    color: white;  /*글자색상*/
    background: #6A6A6A; /*배경색상*/
    font-weight: 900;
}
</style>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script src="//code.jquery.com/ui/1.11.3/jquery-ui.js"></script>
<script src="<c:url value='/common/js/user.js'/>" charset="utf-8"></script>
<script type="text/javascript">
//비밀번호 재인증 폼 검사.
function reconfirmPwd(){//modifyInfo.jsp
	var regPwd  	= /[ㄱ-ㅎ가-힣`.,\[\]\{\}\(\)\;\'\":\/?]/g;
	var pwd 		= $('#pwd');
	
	if (pwd.val() == "") {
		alert("비밀번호를 입력하세요.");
		pwd.focus();
		return false;
	}//enf if
	if(regPwd.test(pwd.val())){
		alert("비밀번호를 다시 입력하세요.");
		pwd.val('');
		pwd.focus();
		return false;
	}//end if
	
	$("#chk_f").attr("action", "<c:url value='/user/reconfirmPwd.do'/>");
	$("#chk_f").attr("method", "post");
	$("#chk_f").submit();
}//chkPwd

////////회원정보 수정 폼데이터 검사
function chkForm_modifyInfo(){
	var frm 			= document.modifyUser_f;
	var pwd 		= $("#pwd");
	var name		= $("#name");
	var birth		= document.getElementById("datepicker");
	var ph			= $("#ph");
	var mail			= $("#email");
	var addr 		= $("#addr");
	var d_addr		= $("#detailAddr");
	var zipcode	= $("#zipcode");
	
	var regPw 	  		= /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).*$/gi; //영문,특수문자,숫자를 다 혼용해야 패스워드 체크에 통과되는 정규식
	var regNm	  		= /^[가-힣]{2,6}$/g;
	//var regBirth		= /[0-9]{8}/g;
	var regPh	  		= /^[0-9\-]{3,4}/g;
	var regEm	  	 	= /^[a-z0-9.@]{4,20}$/g;
	var regDeAddr 	= /[^ㄱ-ㅎㅏ-ㅣ가-힣0-9-\s,]{3,30}/g; /* /^[가-힣|a-z|A-Z|0-9]{3,20}/g */
	
	//비밀번호가 빈칸이면 실행 X. 빈 칸일 시, 기존 비밀번호 유지.
	if(!(pwd.val() == '' || pwd.val() == null)){
		if(!regPw.test(pwd.val())){
			alert("비밀번호는 6~16자의 영문 대 소문자, 숫자, 특수문자를 사용하십시오.");
			pwd.val("");
			pwd.focus();
			return false;
		}//비밀번호
	}
	
	if(!regNm.test(name.val())){
		alert("이름을 형식에 맞게 입력하세요.");
		name.focus();
		return false;
	}//이름
	
	//생년월일의 유효 년도 체크  
	var y_compareVal = birth.value;
	if (y_compareVal.substr(0,2) < 19 || y_compareVal.substr(0,4) > new Date().getFullYear()){ 
    	alert("유효하지 않은 년도입니다.");
	    birth.focus();
	    return false;
    }//생년월일의 유효 년도 체크   
	
	if(!regEm.test(mail.val())){
		alert("이메일을 형식에 맞게 입력하세요.");
		mail.focus();
		return false;
	}//email
	
	if(!regPh.test(ph.val())){
		alert('전화번호를 형식에 맞게 입력하세요.');
		ph.focus();
		return false;
	}
	
	if(zipcode.val().length == 0 || addr.val().length == 0){
		alert("주소를 입력하세요.");
		return false;
	}
	if(d_addr.val() == null || d_addr.val() == ''){
		alert("상세 주소 입력란을 형식에 맞게 채워주세요.");
		d_addr.focus();
		return false;
	}
	if(regDeAddr.test(d_addr.val())){
		alert("상세 주소 입력란을 형식에 맞게 채워주세요.");
		d_addr.focus();
		return false;
	}
	
	frm.action		=  "<c:url value='/user/updateModifiedInfo.do'/>"
	frm.method	=	"post";
	frm.submit();
}//chkForm_modifyInfo



$(function(){
	if($('#auth').val() == "true"){//jquery에는 boolean형이 따로 없기 때문에 문자열로 비교.
		$('.modifyInfo_area').css('margin-bottom', '50px');
	}//end if
	
	$('#pwd').css({"ime-mode" : "disabled"});//한글입력방지, 이하 동문.
	$('.email').css("ime-mode", "disabled");
	$('#ph1').css("ime-mode", "disabled");
	$('#ph2').css("ime-mode", "disabled");
	
})//jQuery
</script>
</head>
<body>
<input type="hidden" id="auth" value="${param.auth}"/>
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
		
		
		<!-------- It's the main contents area after this line. -------->
			<div class="modifyInfo_wrapper">
				<div class="modifyInfo_area">
					<div class="view_notice">
						<h1>회원 정보 확인/수정</h1>
					</div>
					
					<!-- 정보 수정 전, 비밀번호 입력으로 한 번 더 사용자 확인. -->
					<!-- 사용자 확인 view -->
					<c:if test="${param.auth eq false}">
						<div class="reconfirm_wrapper">
							<div class="reconfirm_area">
								<form id="chk_f" name="chk_f" class="chk_f">
									<div class="reconfirm_id">
										<input type="text" id="id" name="id" maxlength="16" value="${id}" readonly="readonly"/>
									</div>
									
									<div class="reconfirm_pwd">
										<input type="password" id="pwd" name="pwd" maxlength="20" placeholder="비밀번호"/>
									</div>
									
									<div class="reconfirm_btns">
										<div class="reconfirm_btns_submit">
											<input type="submit" id="btn_submit" class="btn" onclick="reconfirmPwd()" value="확인">
										</div>
									</div>
								</form>
								<div class="missing_notice_wrapper">
									<div class="missing_notice">
										회원님의 계정과 정보를 안전하게 보호하기 위해 비밀번호를 다시 한 번 확인합니다.
									</div>
								</div>
								<c:if test="${param.fail eq true}">
									<div class="missing_notice_wrapper">
										<div class="missing_notice">
											<p>존재하지 않는 정보입니다. 정확히 확인 후, 다시 입력하세요.</p>
										</div>
									</div>
								</c:if>
							</div><!-- reconfim_area -->
						</div><!-- reconfirm_wrapper -->
					</c:if><!-- 인증, 재인증 실패시 화면 -->
				
						
					
					<!-- 인증 후, view -->
					<c:if test="${param.auth eq true}">
						<div class="userInfo_wrapper">
							<div class="id_wrapper">
								<div class="id_area"><font>${map.USERNAME}</font> 님의 정보입니다.</div>
							</div>
							<div class="modifyInfo_notice">
								<p>● 안내</p>
								<ul>
									<li>회원 정보를 수정하길 원하신다면, 안내글 하단의 <span>'수정하기'</span> 버튼을 누른 후, 수정을 진행하세요.</li>
									<li>회원 정보를 수정 후, 수정한 정보를 저장하려면 화면 하단의 <span>'수정확정'</span> 버튼을 누르세요.</li>
									<li><span>비밀번호 수정</span>은 입력하시면 수정되고, 공란으로 놔둘 시 수정되지 않습니다.</li>
									<li>비밀번호 수정을 원하시지 않는다면 입력하지 마세요. 빈 칸으로 놔두시면 수정되지 않습니다.</li>
									<li>주소는 주소 입력부의 <span>'주소찾기'</span> 버튼을 누르셔서 수정하시면, 나머지 상세주소와 우편번호까지 수정됩니다.</li>
									<li><span>전화번호 수정</span> 시, 예) 010-1111-2222</li>
								</ul>
								<div>
									<button id="btn_allowModify" class="btn" onclick="allowModify()">수정 하기</button>
								</div>
							</div>
							<form id="modifyUser_f" name="modifyUser_f" class="modifyUser_f">
								<div class="pwd_area">
									<label for="pwd">비밀번호</label>
									<input type="password" id="pwd" name="pwd" placeholder="비밀번호" readonly="readonly" maxlength="16"/>
								</div>
								<div class="name_area">
									<label for="name">이름</label>
									<input type="text" id="name" name="name" placeholder="이름" value="${map.NAME}" readonly="readonly" maxlength="6"/>
								</div>
								<div class="birth_area">
									<label for="birth">생년월일</label>
									<input type="text" id="datepicker" name="birth" placeholder="생년월일" value="${map.BIRTH}" readonly="readonly" maxlength="8"/>
								</div>
								<div class="ph_area">
									<label for="ph">전화번호</label>
									<input type="text" id="ph" name="ph" placeholder="연락처" value="${map.PHONE}" readonly="readonly" maxlength="13"/>
								</div>
								<div class="email_area">
									<label for="email">이메일</label>
									<input type="text" id="email" name="email" placeholder="이메일" value="${map.EMAIL}" readonly="readonly" maxlength="40"/>
								</div>
								<div class="addr_area">
									<label for="addr" style="display: inline-block;">주소</label>
									<span><a id="searchAddr" class="btn_a" onclick="javascript:;">주소찾기</a></span>
									<input type="text" id="addr" name="addr" readonly="readonly" placeholder="도로명 혹은 지번 주소" value="${map.ADDR}" readonly="readonly"/>
								</div>
								<div class="detailAddr_area">
									<label for="detailAddr">상세 주소</label>
									<input type="text" id="detailAddr" name="detailAddr" placeholder="상세 주소" value="${map.DETAILADDR}" readonly="readonly" maxlength="30"/>
								</div>
								<div class="zipcode_area">
									<label for="zipcode">우편 번호</label>
									<input type="text" id="zipcode" name="zipcode" placeholder="새우편 번호" value="${map.ZIPCODE}" readonly="readonly"/>
								</div>
								<div class="btn_wrapper">
									<div class="btn_area">
										<div>
											<input type="submit" class="btn" onclick="return chkForm_modifyInfo()" value="수정 확정"/>
										</div>
									</div>
								</div>
							</form>
						</div><!-- UserInfo_wrapper -->
					</c:if>
				</div><!-- modify_area -->
			</div><!-- modify_wrapper -->
	</main>
</div><!-- wrap_container -->
</body>
</html>