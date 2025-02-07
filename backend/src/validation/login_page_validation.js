import Joi from 'joi'

const registerUserValidation = Joi.object({
    username : Joi.string().max(100).required(),
    password : Joi.string().max(100).required(),
    name : Joi.string().max(100).required(),
    email : Joi.string().max(100),
    phone : Joi.string().max(100),
    profilePicture : Joi.string(),
})

const loginUserValidation = Joi.object({
    username : Joi.string().max(100).required(),
    password : Joi.string().max(100).required()
})

const getUserValidation = Joi.string().required()

export{
    loginUserValidation, registerUserValidation, getUserValidation
}