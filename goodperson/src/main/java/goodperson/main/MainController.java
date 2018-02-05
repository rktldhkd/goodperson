package goodperson.main;

import goodperson.board.service.BoardService;

import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;


@Controller
public class MainController {
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name = "boardService")
	private BoardService boardService;
	
	@RequestMapping(value = "/main.do")
	public ModelAndView openMain(){
		ModelAndView mv = new ModelAndView("/main");
		
		Map<String, Object> resultMap;
		try {
			resultMap = boardService.getNewestBoardItems();
		} catch (Exception e) {
			resultMap = null;
			e.printStackTrace();
		}
		
		Iterator<Entry<String, Object>> it = resultMap.entrySet().iterator();
		Entry<String, Object> entry = null;
		while (it.hasNext()) {
			entry = it.next();
			log.debug("key : " + entry.getKey() + ", value : "
					+ entry.getValue());
		}// while
		log.debug("newest 확인 끝!");
		
		mv.addObject("items", resultMap.get("result"));

		return mv;
	}//openMain
}//class