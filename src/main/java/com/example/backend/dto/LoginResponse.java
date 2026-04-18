package com.example.backend.dto;

public class LoginResponse {

    private Long id;
    private String email;
    private String token;

    public LoginResponse(Long id, String email, String token){
        this.id = id;
        this.email = email;
        this.token = token;
    }

    // ✅ ADD THESE
    public Long getId() {
        return id;
    }

    public String getEmail() {
        return email;
    }

    public String getToken() {
        return token;
    }
}
