<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jsp" %>    
<!DOCTYPE html>
<html>
<head>
<title>:: 게시글 상세</title>
<script type="text/javascript">

function fn_loginChk(){
	var vali_login =  '<c:out value="${map.ID}"/>';
	var flag=false;
	if(vali_login == null || vali_login == ''){
		flag = true;
	}//end if
	return flag;
}//fn_loginChk()
function fn_insertRecomment(obj){ // 댓글옆의 '재댓글' 버튼 클릭 시, 재댓글 입력창 소환.
	if(fn_loginChk()){//비로그인 상태
		e.preventDefault();
		return false;
	}else{//로그인 상태
		//아래쪽에 댓글 작성창을 소환한다.
		obj.parent().parent().parent().toggleClass("border_bottom"); // 리코멘트 입력공간과 부모 댓글 사이의 경계선.
		var recommObj	=	obj.parent().parent().parent().next();
		recommObj.toggleClass("border_bottom");
		recommObj.toggleClass("display_tbl_row");
		recommObj.toggleClass("recomment_area");
	}//end if-else
	
}//fn_insertRecomment
function fn_writeComment(){
   	$(function(){
   		var obj_write_btn				=	$(this);
   		var comment_txtArea_val 	=  $("#comment_txtArea").val(); // 댓글 내용.
   		var ITEM_IDX						=  $('#ITEM_IDX').val(); // 게시판 인덱스
   		
   		if(chkNull($("#comment_txtArea"))){//빈칸,null체크
   			alert("댓글을 입력하세요.");
   			return false;
   		}//end if
   		
   		var comSubmit = new ComSubmit();
   	    comSubmit.setUrl("<c:url value='/board/writeComment.do'/>");
   	    comSubmit.addParam("comment_contents", comment_txtArea_val);
   	    comSubmit.addParam("IDX", ITEM_IDX);
   	    comSubmit.submit();
   	});//jQuery
}//write_comment
function fn_deleteComment(obj){
	var flag = confirm("정말 댓글을 삭제하시겠습니까?");
	
	if(flag){
		var comment_idx	= obj.parent().parent().parent().find(".comment_id").find("#COMMENT_IDX").val();
		var IDX					= '${map.IDX}';
		var comSubmit 		= new ComSubmit();
		
	    comSubmit.setUrl("<c:url value='/board/deleteComment.do' />");
	    comSubmit.addParam("COMMENT_IDX", comment_idx);
	    comSubmit.addParam("IDX", IDX);
	    comSubmit.submit();
	}else{
		return false;
	}//end if-else
}//fn_deleteComment
function fn_openBoardList(){
    var comSubmit = new ComSubmit();
    comSubmit.setUrl("<c:url value='/board/openBoardList.do' />");
    comSubmit.submit();
}//fn_openBoardList()
function fn_openBoardUpdate(){
    var idx = "${map.IDX}";
    var comSubmit = new ComSubmit();
    comSubmit.setUrl("<c:url value='/board/openBoardUpdate.do' />");
    comSubmit.addParam("IDX", idx);
    comSubmit.submit();
}//fn_openBoardUpdate()
function fn_writeReComment(obj_write_btn){
	var obj_recomm_textArea	=  obj_write_btn.parent().parent().find("#comment_recomm_txtArea");
	$(function(){
		if(chkNull(obj_recomm_textArea)){//빈칸,null체크
			alert("댓글을 입력하세요.");
			return false;
		}//end if
		
		var IDX								=  $('#ITEM_IDX').val(); // 게시판 인덱스
		var PARENTS_IDX				=	obj_write_btn.parent().parent().parent().parent().prev().find('#COMMENT_IDX').val(); //부모댓글이 될 댓글의 COMMENT_IDX
		var comment_contents		 	=  obj_recomm_textArea.val(); // 댓글 내용.
		var GROUP_IDX					=	obj_write_btn.parent().parent().parent().parent().prev().find("#GROUP_IDX").val();
		
		var comSubmit = new ComSubmit();
	    comSubmit.setUrl("<c:url value='/board/writeComment.do'/>");
	    comSubmit.addParam("comment_contents", comment_contents);
	    comSubmit.addParam("IDX", IDX);
	    comSubmit.addParam("PARENTS_IDX", PARENTS_IDX);
	    comSubmit.addParam("GROUP_IDX", GROUP_IDX);
	    comSubmit.submit();
	});//inner_jQuery
}//fn_writeReComment()
function fn_downloadFile(obj){
	var idx = obj.parent().find("#IDX").val();
	/*
	[ 해결법 참조 ]
	HTML인지 자바스크립트인지는 모르겠지만 버그입니다. ComSubmit을 생성할 때 form이 초기화가 된 후, 
	addParam을 할 때 하나의 태그가 추가되는데, 전송할 때 2개가 날아가는 버그입니다. 저도 개발을 하다보니 그런 경우가 발생을 하더라구요. 
	방법은 몇가지가 있는데, addParam을 할 때 해당 key를 가진 태그가 존재하면, 그 태그를 삭제하는 로직을 추가하거나, 
	그런 버그가 생성된 Controller에서 해당 값이 배열인지 아닌지 검사해서 배열이면 하나의 값만 추가하도록 하면 됩니다.
	
	[ My solution ]
		* 아래의 remove()를 꼭 집어넣어야 에러가 안난다.
		* because, input의 value가 하나가 넘어가야 하는데, 두 개가 넘어가서 value값이 정수값에서
		* 전혀 다른 값([Ljava.lang.String;@12fa8ef 같은 값이나 undefine 같은 값으로..)으로 변하게 된다.
		* 그러므로 첨부파일이 여러 개더라도, 한 번 보낼때 input hidden 값도 하나씩 보내게 이전에 썻던 input 태그를 지우는 것.
	*/
	$("input[name='IDX']").remove();
    var comSubmit = new ComSubmit();
    comSubmit.setUrl("<c:url value='/common/downloadFile.do'/>");
    comSubmit.addParam("IDX", idx);
    comSubmit.submit();
}//fn_downloadFile()
function addClassToRecomm(obj){// 리코멘트 댓글 배경색 지정.
	var len = obj.length;
	
	for(var i=0; i<len; i++){
		if(obj[i].value > 0){
			//jQuery의 addClass()와 같다.
			//주의점 : 클래스 네임 주입 시, 앞에 빈칸 한칸을 주어야 여러 개의 클래스가 잘 적용됨. 빈 칸 안주면,
			//클래스네임1클래스네임2클래스네임3... 형식으로 class name들이 붙어있게 됨
			obj[i].parentNode.parentNode.className += " recommBackColor"; // 리코멘트 입력공간과 부모 댓글 사이의 경계선.
		}//end if
	}//end for
}//toggleClassToRecomm

$(function(){//jQuery
	var vali_login;
	
	addClassToRecomm($(".STEP_IDX"));
	
	
	// 댓글과 관련된 기능을 하는 버튼에, 기능이 작동되는데에 대해 조건을 줌.
	// 조건 - 로그인 여부.
	$(".comment_btn a").on("click", function(e){
		if(fn_loginChk()){//로그인 체크. 비로그인시, true.
			e.preventDefault();
			alert("로그인 후, 이용 가능합니다.");
			return false;
		}//end if
	});
	
	$('.comment_btn_re').on('click', function(e){
		e.preventDefault();
		fn_insertRecomment($(this));
	});
	
	$("#list").on("click", function(e){ //목록으로 버튼
        e.preventDefault();
        fn_openBoardList();
    });//#list
     
    $("#update").on("click", function(e){
        e.preventDefault();
        fn_openBoardUpdate();
    });//update
    
    $("a[name='file']").on("click", function(e){
        e.preventDefault();
        fn_downloadFile($(this))
    });//a[name='file']
    
    $("#comment_txtArea").keyup(function(e){
    	var obj			= $(this);
    	var inputLen	= obj.val().length;
    	var maxLen	=	document.getElementById("comment_txtArea").maxLength;
    	
    	$(this).height(function(){//자동 높이 조절.
    		if(this.clientHeight < this.scrollHeight){
    			obj.height(this.scrollHeight);
    		}//end if
    	});//#comment_txtArea
    	
    	if(maxLen == inputLen){
    		$(".inputLen").text(inputLen);
	        e.preventDefault();
    	}else if(maxLen < inputLen){
    		obj.val().length(300);
    		inputLen = obj.val().length();
    		obj.val().length(inputLen);
    		$(".inputLen").text(inputLen);
    	}else{
    		$(".inputLen").text(inputLen);
    	}//end if-else
    });
    
    //댓글 입력.
    $("#write_comment").click(function(e){
    	e.preventDefault();
    	fn_writeComment();
    });//#write_comment
    
    
    
    //재댓글 입력. 리코멘트 버튼개수 = 여러 개.
    //id value로 탐색 시, 맨 처음 하나만 탐색 됨.
    //개체 여러 개 탐색하여 작업 시, 밑에 처럼 클래스 value로 탐색.
    $(".write_recomm").click(function(e){
    	var obj_write_btn = $(this);
    	e.preventDefault();
    	fn_writeReComment(obj_write_btn);
    });
    
});//jQuery

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
		
		
		<!-- It's the main contents area after this line. -->
		
		<div id="board_content_wrapper" class="board_content_wrapper">
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
		                <td>${map.IDX }</td>
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
		                <td colspan="3">${map.TITLE }</td>
		            </tr>
		            <tr>
		                <th scope="row">첨부파일</th>
		                <td colspan="3">
		                    <c:forEach var="row" items="${list }">
		                    	<div class="attachment">
			                        <input type="hidden" id="IDX" value="${row.IDX }">
			                        <a href="#this" id="file" class="file" name="file">${row.ORIGINAL_FILE_NAME }</a> (${row.FILE_SIZE } KB)
		                        </div>
		                    </c:forEach>
		                </td>
		            </tr>
		            <tr>
		                <td colspan="4">
		                	<pre>${map.CONTENTS }</pre>
		                </td>
		            </tr>
		        </tbody>
    		</table>
    		<div class="btn_area" style="margin-bottom: 20px;">
		    	<a href="#this" class="btn" id="list">목록으로</a>
		    	<c:if test="${sec_id ne null and sec_id eq map.CREA_ID}">
		    		<a href="#this" class="btn" id="update">수정하기</a>
		    	</c:if>
		    </div>
    		
    		<div class="comment_wrapper" style="border: 3px solid #ccc; margin-bottom: 40px;">
    			<div class="comment_header" style="padding:4px 18px; border-bottom: 1px solid #ccc; background-color: #eaeaea; overflow: hidden;">
    				<span><strong>댓글 마당(${TotalComments})</strong></span><!-- list=답글들을 담은 객체 -->
    				<span style="float: right;">
    					<img alt="/common/images/btn/cmt_del.gif" src="<c:url value="/common/images/btn/cmt_del.gif" />" style="cursor: default;">&nbsp;삭제
    					<img alt="/common/images/btn/cmt_re.gif" src="<c:url value="/common/images/btn/cmt_re.gif" />" style="cursor: default;">&nbsp;재댓글
    				</span>
    			</div>
    			
    			<div class="comment_body" style="padding:12px 18px;">
	    			<div class="comment_list_area" style="margin-bottom: 20px;">
	    				<table>
							<colgroup>
								<col width="18%" />
								<col width="*" />
								<col width="5%"/>
								<col width="10%" />
							</colgroup>
							<tbody id="comment_tbody">
								<c:choose>
									<c:when test="${fn:length(comments) > 0}">
										<c:forEach items="${comments}" var="row">
											<tr class="border_bottom">
												<td class="comment_id">
													<input type="hidden" id="COMMENT_IDX" class="COMMENT_IDX" value="${row.COMMENT_IDX}">
													<input type="hidden" id="PARENTS_IDX" value="${row.PARENTS_IDX}">
													<input type="hidden" id="GROUP_IDX"  value="${row.GROUP_IDX}">
													<input type="hidden" id="STEP_IDX" class="STEP_IDX" value="${row.STEP_IDX}">
													<c:if test="${row.PARENTS_IDX ne null}"><!-- PARENTS_IDX ne '' 하니까 true가 나옴... null도 아니고 값도 아님... -->
														<span>
															<img alt="" src="<c:url value='/common/images/contents/blt_cmt_re_new.gif' />"/>
														</span>
													</c:if>
													<span>${row.CREA_ID}</span>
												</td>
												<td class="comment_contents"><span>${row.CONTENTS}</span></td>
												<td class="comment_btn">
													<c:if test="${row.CREA_ID eq  map.ID}">
														<!-- 내가 작성한 댓글만 삭제 버튼 표시. -->
														<span>
															<a href="javascript:;" class="comment_btn_del">
																<img alt="/common/images/btn/cmt_del.gif"  src="<c:url value="/common/images/btn/cmt_del.gif" />">
															</a>
														</span>
													</c:if>
													<c:if test="${row.PARENTS_IDX eq null}">
															<span>
																<a href="javascript:;" class="comment_btn_re">
																	<img alt="/common/images/btn/cmt_re.gif"  src="<c:url value="/common/images/btn/cmt_re.gif" />">
																</a>
															</span>
													</c:if>
												</td>
												<td class="comment_dtm"><span>${row.CREA_DTM}</span></td>
											</tr>
											<c:if test="${row.PARENTS_IDX eq null}">
												<tr style="display: none;">
													<td colspan="4">
														<div class="comment_write_area" style="height:85px; position: relative;">
															<span style="position:absolute; top: 0px;">
																<img alt="" src="<c:url value='/common/images/contents/blt_cmt_re_new.gif' />"/>
															</span>
															
								    						<textarea id="comment_recomm_txtArea" class="comment_recomm_txtArea" rows="10" cols="90"
								    							style="line-height:18px; overflow-y:hidden; width:650px; height:64px; resize:none; padding:0.5em 1.0em; top:0px; left:25px; position:absolute;"
								    							maxlength="300" placeholder="리코멘트를 입력하세요."></textarea>
								    						<input type="hidden" id="ITEM_IDX" value="${map.IDX}"/>
										    				<div style="position: absolute; top:0; right:0;">
										    					<a href="javascript:;" id="write_recomm" class="btn write_recomm" style="width:48px; height: 52px; text-align: center; line-height: 4em; border-radius:0px;">등록</a>
										    				</div>
										    				<div class="cal_txtLen" style="margin-top: 2px; position: absolute; bottom: 0px; left:25px;">
										    					<span class="inputLen bold_text">0</span>/300자
										    				</div>
										    			</div><!-- comment_write_area -->
													</td>
												</tr>
											</c:if>
										</c:forEach>
									</c:when>
									<c:otherwise>
									</c:otherwise>
								</c:choose>
							</tbody>
						</table>
					</div><!-- comment_list_area -->
	    			
	    			<div class="comment_write_area" style="position: relative;">
	    				<div class="search_result" style="position:relative; border: 4px solid #bbb; padding: 10px 12px 10px 12px;">
							<ul>
								<li>
									<span><img alt="common/images/contents/arrow_right.gif" src="<c:url value='/common/images/contents/arrow_right.gif'/>"/></span>
									상대방에 대한 배려는 네티켓의 기본입니다.게시물에 상관없는 댓글이나 유도성 댓글을 달지 마세요.
								</li>
								<li>
									<span><img alt="common/images/contents/arrow_right.gif" src="<c:url value='/common/images/contents/arrow_right.gif'/>"/></span>
									스포일러성 답글이 신고되거나 발견되면 이유불문 삭제 혹은 제제처리 됩니다. 유의 부탁 드립니다.
								</li>
							</ul>	    				
	    				</div>
	    				
	    				<div style="overflow:hidden;">
	    					<!-- main_user_info div 태그 부분에 jstl 변수 roles 선언한 것을 재활용 -->
		    				<c:choose>
		    					<c:when test="${roles eq '' or roles eq null}"><!-- roles는 시큐리티부분의 변수 roles. -->
		    						<textarea rows="10" cols="90" style="height:64px; overflow-y:hidden;  resize:none; padding:8px 8px;" maxlength="300" readonly="readonly" placeholder="로그인 후 댓글 입력 가능합니다."></textarea>
		    					</c:when>
		    					<c:otherwise><!-- padding:1.1em -->
		    						<textarea id="comment_txtArea" rows="10" cols="90" style="width:650px; line-height:18px; overflow-y:hidden; height:64px; resize:none; padding:0.5em 1.0em;"
		    							maxlength="300" placeholder="의견을 입력하세요."></textarea>
		    						<input type="hidden" id="ITEM_IDX" value="${map.IDX}"/>
		    					</c:otherwise>
		    				</c:choose>
		    				<div style="position: absolute; top:66px; right:0px;">
		    					<a href="javascript:;" id="write_comment" class="btn" style="width:48px; height: 52px; text-align: center; line-height: 4em; border-radius:0px;">등록</a>
		    				</div>
		    				<div class="cal_txtLen" style="margin-top: 2px;">
		    					<span class="inputLen bold_text">0</span>/300자
		    				</div>
	    				</div>
	    			</div><!-- comment_write_area -->
	    		</div><!-- comment_body -->
    		</div><!-- comment_wrapper -->
		</div><!-- board_content_wrapper -->
		
		<jsp:include page="/WEB-INF/include/include-body.jsp" />
	</main>
</div><!-- wrap_container -->
</body>
</html>