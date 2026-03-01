package com.mycompany.ocean_view.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    private static final String URL =
            "jdbc:mysql://localhost:3306/ocean_view?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASS = "20031026";

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}