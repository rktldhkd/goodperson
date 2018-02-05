package goodperson.common.service;

import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import goodperson.common.dao.CommonDAO;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

@Service("commonService")
public class CommonServiceImpl implements CommonService{
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="commonDAO")
	private CommonDAO commonDAO;

	@Override
	public Map<String, Object> selectFileInfo(Map<String, Object> map) throws Exception {
		//map에 값이 들어있는지 체크.
		Iterator<Entry<String,Object>> it = map.entrySet().iterator();
		Entry<String,Object> entry = null;
		while(it.hasNext())
		{
			entry = it.next();
            log.debug("key : "+entry.getKey()+", value : "+entry.getValue());
		}//while
		
		return commonDAO.selectFileInfo(map);
	}
}//class
