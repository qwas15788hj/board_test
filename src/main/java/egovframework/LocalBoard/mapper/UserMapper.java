package egovframework.LocalBoard.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import egovframework.LocalBoard.dto.User;

@Mapper
public interface UserMapper {

	User findByLoginId(String loginId);
	void join(Map<String, Object> params);
	int checkId(String loginId);
	void modifyUserProfile(User user);
	void removeUser(int userId);

}
