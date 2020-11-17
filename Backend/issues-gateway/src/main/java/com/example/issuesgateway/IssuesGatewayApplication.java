package com.example.issuesgateway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class IssuesGatewayApplication {

    public static void main(String[] args) {
        SpringApplication.run(IssuesGatewayApplication.class, args);
    }

}
