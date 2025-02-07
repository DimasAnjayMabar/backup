import express from 'express'
import userController from '../controller/login_page_controller.js'
import {authMiddleware} from '../middleware/auth_middleware.js'

const userRouter = new express.Router()
userRouter.use(authMiddleware)
userRouter.get('/api/users/current', userController.get)
userRouter.delete('/api/users/logout', userController.logout)

export{
    userRouter
}