package goodperson.user.controller;

import goodperson.common.common.CommandMap;
import goodperson.user.service.UserService;

import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class UserController {
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name = "UserService")
	private UserService userService;
	
	/**
	 * 아이디 찾기 화면으로 이동. 부모창=로그인 view
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/user/findIdPw/findId.do",method=RequestMethod.GET)
	public String openFindId() throws Exception{
		return "/user/findIdPw/findId";
	}//openFindId
	
	
	/**
	 * 비밀번호 찾기 화면으로 이동. 부모창=로그인 view
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/user/findIdPw/findPw.do",method=RequestMethod.GET)
	public String openFindPw() throws Exception{
		return "/user/findIdPw/findPw";
	}//openFindId
	
	
	@RequestMapping(value="/user/searchId.do", method=RequestMethod.POST)
	public ModelAndView searchId(CommandMap commandMap) throws Exception{
		ModelAndView mv	=	new ModelAndView();
		
		mv.setViewName("/user/findIdPw/findId");
		
		//test starts.
	    log.debug("========== UserController - 사용자 정보 확인 ==========");
	    log.debug("commandMap 데이터 량 : " + commandMap.getMap().size());
	    Iterator<Entry<String,Object>> it = commandMap.entrySet().iterator();
        Entry<String,Object> entry = null;
        while(it.hasNext())
        {
               entry = it.next();
               log.debug("key : "+entry.getKey()+", value : "+entry.getValue());
        }//while
        //test ends.
        
		
		Map<String, Object> resultMap = userService.searchIdPw(commandMap.getMap());
		
		log.debug("id size : "+resultMap.size());
	/*	log.debug("========== UserController- resultMap 확인 ==========");
		log.debug("resultMap 사이즈 : " + resultMap.size());
	  		//Map<String, Object> testMap = (Map<String, Object>)commandMap.get("map");
	  		it = resultMap.entrySet().iterator();
	  		Entry<String,Object> entry2 = null;
	  		while(it.hasNext()){
	  			entry2 = it.next();
	            log.debug("key : "+entry2.getKey()+", value : "+entry2.getValue());
	  		}//while
*/
		mv.addObject("map", resultMap);
		
		return mv;
	}//searchId
	
	@RequestMapping(value="/user/searchPw.do", method=RequestMethod.POST)
	public ModelAndView searchPw(CommandMap commandMap) throws Exception{
		ModelAndView mv	=	new ModelAndView();
		mv.setViewName("/user/findIdPw/findPw");
		
		Map<String, Object> resultMap = userService.searchIdPw(commandMap.getMap());
		
		log.debug("pwd resultMap size before Processing : "+resultMap.size());
		resultMap.put("tmpPwd", userService.issueTmpPwd(commandMap.getMap()));
		log.debug("pwd resultMap size after Processing : "+resultMap.size());
		
		mv.addObject("map", resultMap);
		
		return mv;
	}//searchPw
	
	@RequestMapping(value="/user/modifyInfo.do")
	public ModelAndView openModifyInfo(CommandMap commandMap) throws Exception{
		Map<String,Object> resultMap;
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/user/modifyInfo/modifyInfo");
		
		Authentication authentication 	=	 SecurityContextHolder.getContext().getAuthentication();//시큐리티 로그인 사용자 정보
		Object pricipal 						=	 authentication.getPrincipal();
		String id									= 	 ((UserDetails)pricipal).getUsername();
		
		commandMap.put("id", id);
		
		String param_auth = commandMap.get("auth").toString();
		boolean auth = Boolean.valueOf(param_auth).booleanValue(); //String 문자열을 boolean형으로 형변환.
		if(auth){//비밀번호 재확인이 되었을 때에만 사용자 정보를 가져온다.
			resultMap = userService.getTotalUserInfo(commandMap.getMap());
			mv.addObject("map", resultMap);
			log.debug("resultMap USERNAME 값 : ["+(String)resultMap.get("USERNAME") + "]");
		}else{
			mv.addObject("id", id); // 실패 시, 다시 인증화면으로 가서 로그인 할 때, 아이디 값.
		}//end if-else
	
		
		return mv;
	}//openModifyInfo
	
	@RequestMapping(value="/user/reconfirmPwd.do", method=RequestMethod.POST)
	public ModelAndView reconfirmPwd(CommandMap commandMap) throws Exception{
		ModelAndView mv = new ModelAndView();
		
		boolean result = userService.reconfirmUser(commandMap.getMap());
		if(result == false){
			mv.setViewName("redirect:/user/modifyInfo.do?auth="+result+"&fail=true");
		}else{
			mv.setViewName("redirect:/user/modifyInfo.do?auth="+result+"&fail=false");
		}//end if-else
		
		return mv;
	}//reconfirmPwd
	
	@RequestMapping(value="/user/updateModifiedInfo.do", method=RequestMethod.POST)
	public String updateModifiedInfo(CommandMap commandMap) throws Exception{
		log.debug("========== UserController - updateModifiedInfo - 사용자 정보 확인 ==========");
	    log.debug("commandMap 데이터 량 : " + commandMap.getMap().size());
	    Iterator<Entry<String,Object>> it = commandMap.entrySet().iterator();
        Entry<String,Object> entry = null;
        while(it.hasNext())
        {
               entry = it.next();
               log.debug("key : "+entry.getKey()+", value : "+entry.getValue());
        }//while
		
        Authentication authentication 	=	 SecurityContextHolder.getContext().getAuthentication();//시큐리티 로그인 사용자 정보
		Object pricipal 						=	 authentication.getPrincipal();
		String id									= 	 ((UserDetails)pricipal).getUsername();
		commandMap.put("id", id);
        
        //비밀번호값이 존재할 시, 비밀번호 update. 공란이면 기존 비밀번호 유지.
        String pw = (String)commandMap.get("pwd");
        if(!(pw == "" || pw == null)){
        	log.debug("비밀번호 수정작업 개시");
        	userService.modifyPwd(commandMap.getMap());
        }//end if
        userService.modifyUserInfo(commandMap.getMap()); // 수정된 회원정보 업데이트
        
		return "/main";
	}//reconfirmPwd
}//class
