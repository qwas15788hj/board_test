package egovframework.LocalBoard.config;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@MapperScan("egovframework.LocalBoard.mapper")
public class MyBatisConfig {
}
