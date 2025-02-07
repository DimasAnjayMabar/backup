# Login Page API Spec

## Public Error 
Code 404 : Not Found -> not found page
Code 401 : Unauthorized -> alert dialog

## Register User
Registering user must be directly inside database with high authorization person (or adding a register page depends with the situation)

Request Body (required field) : 
{
    "username" : "username",
    "password" : "password",
    "name" : "name",
    "email" : "email",
    "phone" : "phone", 
    "profilePicture" : "profilePicture"
}

## Login User
Endpoint : POST /api/users/login

Request Body (json) : 
{
    "username" : "username",
    "password" : "password"
}

Result Success (json) : 
{
    "token" : "token",
    "message" : "$name has logged in successfully"
}
Directed to : /api/users/dashboard  (dashboard page)

Result Error (json) :
{
    "message" : "Invalid username or password"
}
Directed to : login failed alert dialog
Then : to login page