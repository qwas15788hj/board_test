package egovframework.LocalBoard.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

@Configuration
public class RootConfig {
	
	@Bean
	public CommonsMultipartResolver multipartResolver() {
		CommonsMultipartResolver resolver = new CommonsMultipartResolver(); 
		resolver.setMaxUploadSize(5248800);
		resolver.setMaxInMemorySize(10485760);
		return resolver; 
	}
	
}
