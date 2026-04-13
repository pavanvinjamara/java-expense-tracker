package com.example.backend.dto;

public class LoginResponse {
    private Long id;
    private String email;
    private String password;

    public LoginResponse(Long id, String email, String password){
        this.id = id;
        this.email = email;
        this.password = password;
    }
}
