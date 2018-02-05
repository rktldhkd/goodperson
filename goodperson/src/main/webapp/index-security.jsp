<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
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
<title>홈페이지</title>
<script type="text/javascript">
</script>
</head>
<body>
<!-- sec:authorize태그는 access 속성에 설정된 권한을 가진 사람이 접근하면, 해당 태그 이하에 설정된 내용을 보여줄 수 있다.
	  사용자의 권한에 따라 보여줄 수 있는 화면을 설정할 수 있다.
	  sec:authentication 태그는 사용자의 정보를 보여준다. sec:authorize태그 하위등에서 사용하여(단독사용 가능), 사용자 정보(name등)를 표현할 수 있다.
 -->
<sec:authorize access="isAuthenticated()">
	<!-- 사용자가 로그인(인증)을 하지 않았으므로(isAuthenticated()) 아래의 코드는 출력되지 않는다. -->
	<!-- context-security.xml의 authentication-manager태그 부분의 name 값  -->
	<sec:authentication property="name"/>님 환영합니다.
</sec:authorize>
<ul>
	<li><a href="<c:url value='/home/main.do'/>">/home/main</a></li>
	<li><a href="<c:url value='/member/main.do'/>">/member/main</a></li>
	<li><a href="<c:url value='/manager/main.do'/>">/manager/main</a></li>
	<li><a href="<c:url value='/admin/main.do'/>">/admin/main</a></li>
	<sec:authorize access="isAuthenticated()">
		<!-- 사용자가 로그인(인증)을 하지 않았으므로(isAuthenticated()) 아래의 코드는 출력되지 않는다. -->
		<li><a href="<c:url value='/j_spring_security_logout'/>">/j_spring_security_logout</a></li>
	</sec:authorize>
</ul>
</body>
</html>