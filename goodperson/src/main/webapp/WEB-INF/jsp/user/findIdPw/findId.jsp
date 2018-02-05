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
<meta name="description" content="">
<meta name="author" content="">
<link rel="stylesheet" type="text/css" href="<c:url value='/common/css/login.css'/>" />
<title>::좋은사람 - 아이디 찾기</title>
<script src="<c:url value='/common/js/findIdPw.js'/>" charset="utf-8"></script>
<script type="text/javascript">
function chkData(){
	var name	= $("#name");
	var email 	= $("#email");
	var regNm	  	= /[ㄱ-ㅎ`.,\[\]\{\}\(\)\-_&=+~!@#$%^;*|\\\'\";:\/?]/g;
	var regEm  	= /[ㄱ-ㅎ가-힣A-Z`,\[\]\{\}\(\)\-_&=+~!#$%^;*|\\\'\";:\/?]/g;
		
			if (name.val() == "") {
				alert("이름을 입력하세요.");
				name.focus();
				return false;
			}
			if (email.val() == "") {
				alert("이메일을 입력하세요.");
				email.focus();
				return false;
			}

			if (regNm.test(name.val())) {
				alert("정확한 형식으로 입력하세요.");
				name.val('');
				name.focus();
				return false;
			}//id
			if (regEm.test(email.val())) {
				alert("정확한 형식으로 입력하세요.");
				email.val('');
				email.focus();
				return false;
			}//id
			return true;
}//chkData

$(function(){
	$('#btn_submit_id').on("click", function(){
		var flag = chkData();
		if(!flag){
			return false;
		}//end if
		
		$("#find_f").attr("action", "<c:url value='/user/searchId.do'/>");
		$("#find_f").attr("method", "post");
		$("#find_f").submit();
	});
});//jQuery
</script>
</head>
<body>
<div class="findIdPw_wrap">
	<div class="findIdPw_header_wrapper">
		<header class="findIdPw_header">
			<span class="findIdPw_notice"><h3>아이디 찾기</h3></span>
			<span class="findIdPw_header_otherlink">
				<a href="<c:url value='/user/findIdPw/findPw.do'/>">비밀번호 찾기</a>
			</span>
		</header>
	</div>
	
	<main class="findIdPw_contents_wrapper">
		<form id="find_f" name="find_f">
		<div class="findIdPw_contents_area">
			<c:choose>
				<c:when test="${fn:length(map) < 2}">
					<div class="findIdPw_guide">
						<span>아이디를 찾기 위해서는 이름과 이메일을 입력하셔야 합니다.</span>
					</div>
					<div class="findIdPw_inputField">
						<div>
							<div class="findIdPw_inputName"><input type="text" id="name" name="name" maxlength="15" placeholder="이름"/></div>
							<div class="findIdPw_inputEmail"><input type="text" id="email" name="email" maxlength="50" placeholder="이메일"/></div>
						</div>
					</div>
					<c:if test="${map.fail eq true}">
						<div class="missing_notice_wrapper">
							<div class="missing_notice">
								<p>존재하지 않는 정보입니다. 정확히 확인 후, 다시 입력하세요.</p>
							</div>
						</div>
					</c:if>
					<div class="findIdPw_btnField_wrapper">
						<div class="findIdPw_btnField">
							<a class="btn_comm" id="btn_submit_id">찾기</a>
							<a class="btn_comm" onclick="self.close()">취소</a>
						</div>
					</div>
				</c:when>
				<c:otherwise>
					<div class="idPw_result_wrapper">
						<div class="idPw_result">
							<p>확인된 아이디 : ${map.USERNAME}</p>
							<p></p>
						</div>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
		</form>
	</main>
	
	<footer class="findIdPw_footer_wrapper">
		<div class="findIdPw_footer_btn">
			<img alt="/common/images/btn/close_btn.gif" src="<c:url value='/common/images/btn/close_btn.gif'/>" 
				onclick="self.close();"/>
		</div>
	</footer>
</div>
</body>
</html>