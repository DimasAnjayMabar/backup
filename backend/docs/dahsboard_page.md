# Profile API Spec

## Public Error 
Code 404 : Not Found -> not found page
Code 401 : Unauthorized -> alert dialog

## Fetch Logged In User On Profile
Endpoint : GET /api/users/currentUser

Header : 
    - Authorization : token

Result Success (json) : 
{
    "name" : "name",
    "email" : "email",
    "phone" : "phone",
    "profilePicture" : "profilePicture"
}
Fetched to : profile dashboard

Result Error (json) : 
{
    "message" : "failed to fetch user",
    "name" : "failed",
    "email" : "failed",
    "phone" : "failed",
    "profilePicture" : "dangerIcon"
}
Fetched to : profile dashboard

## Logout User
Endpoint : POST /api/users/logout

Header : 
    - Authorization : token

Result Success (json) :
{
    "message" : "$name logged out successfully",
    "token" : "" (token deleted)
}
Directed to : login page

Result Error (json) : 
{
    "message" : "failed to logout user",
}