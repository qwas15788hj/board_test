package egovframework.LocalBoard.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.stereotype.Service;

import egovframework.LocalBoard.dto.User;
import egovframework.LocalBoard.mapper.UserMapper;

@Service
public class UserServiceImpl implements UserService {
	
	private static final Logger logger = LoggerFactory.getLogger(UserServiceImpl.class);
	
	@Autowired
	private UserMapper userMapper;

	@Override
	public User findByLoginId(String loginId) {
		return userMapper.findByLoginId(loginId);
	}

	@Override
	public void join(Map<String, Object> params) {
		userMapper.join(params);
	}

	@Override
	public boolean checkId(String loginId) {
		logger.info("service loginId 호출 : " + loginId);
		logger.info("userMapper.checkId(loginId) 호출 : " + userMapper.checkId(loginId));
		if (userMapper.checkId(loginId) >= 1) {
			return false;
		}
		return true;
	}

	@Override
	public void modifyUserProfile(User user) {
		userMapper.modifyUserProfile(user);
	}

	@Override
	public void removeUser(int userId) {
		userMapper.removeUser(userId);
	}
	
}
