package goodperson.security.controller;

import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.annotation.Secured;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class SecurityController {
	Logger log = Logger.getLogger(this.getClass());

	@Autowired
	private BCryptPasswordEncoder BcryptPasswordEncoder;
	
	@RequestMapping(value = "/index.do")
	public String openIndex() throws Exception{
		return "redirect:index.jsp";
	}
	
	@Secured("ROLE_USER")
	@RequestMapping(value = "/member/main.do")
	public String openMemberMain() throws Exception{
		log.debug("open member main page.");
		return "/security/memberMain";
	}//openMemberMain
	
	@Secured("ROLE_ADMIN")
	@RequestMapping(value = "/admin/main.do")
	public String openAdminMain() throws Exception{
		log.debug("open admin main page.");
		return "/security/adminMain";
	}//openMemberMain
	
	@RequestMapping(value = "/home/main.do")
	public String openHomeMain() throws Exception{
		log.debug("open home main page.");
		return "/security/homeMain";
	}//openMemberMain
	
	@Secured("ROLE_MANAGER")
	@RequestMapping(value = "/manager/main.do")
	public String openManagerMain() throws Exception{
		log.debug("open manager main page.");
		return "/security/managerMain";
	}//openMemberMain
	
	@RequestMapping(value="/user/login/login.do", method=RequestMethod.GET)
	public String openLoginPage(HttpSession session) throws Exception{
		/*PasswordEncoder passwordEncoder = BcryptPasswordEncoder;
		String encodedPwd = passwordEncoder.encode("test1!");
		log.debug("인코딩 한 비밀번호 : [" + encodedPwd + "]");
		if(passwordEncoder.matches("test1!", "$2a$10$mvKFJU4qLGxcsMsFQjX68.Rux/pRl5.yT9Qn65w/4Q0oRQAzCQOHe")){
			log.debug("비밀번호가 일치합니다.");
		}else{
			log.debug("비밀번호 불일치!!!!!!!!!!!");
		}
		
		log.debug("This is login page! [sessuibid = " + session.getId() + "]");*/
		return "/user/login/login";
	}//openLoginPage
	
	@RequestMapping(value="/exception/accessDenied.do", method=RequestMethod.GET)
	public String e_accessDenied() throws Exception{
		log.debug("exception - 403 error occured.");
		return "redirect:/main.do";
	}//e_accessDenied
	
	/*@RequestMapping(value="/user/logout.do")
	public void logout(HttpSession session) throws Exception{
		log.debug("You've loged out!");
		session.invalidate();
	}//logout*/
}//class
