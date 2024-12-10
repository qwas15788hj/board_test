package egovframework.LocalBoard.service;

import java.util.List;
import java.util.Map;

import egovframework.LocalBoard.dto.User;

public interface UserService {
	public User findByLoginId(String loginId);
	public void join(Map<String, Object> params);
	public boolean checkId(String loginId);
	public void modifyUserProfile(User user);
	public void removeUser(int userId);
}
