import userService from "../service/login_page_service.js";

const register = async (req, res, next) => {
    try{    
        const result = await userService.register(req.body)

        res.status(200).json({
            data : result
        })
    }catch(e){
        next(e)
    }
}

const login = async (req, res, next) => {
    try{
        const result = await userService.login(req.body)
        res.status(200).json({
            data : result
        })
    }catch(e){
        next(e)
    }
}

const get = async (req, res, next) => {
    try{    
        const username = req.user.username
        const result = await userService.get(username)
        res.status(200).json({
            data : result
        })
    }catch(e){
        next(e)
    }
}

const logout = async(req, res, next) => {
    try{
        await userService.logout(req.user.username)
        res.status(200).json({
            data: "Logged out successfully"
        })
    }catch(e){
        next(e)
    }
}

export default {
    register, login, get, logout
}