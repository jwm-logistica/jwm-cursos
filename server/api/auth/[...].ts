import { NuxtAuthHandler } from '#auth'
import CredentialsProvider from 'next-auth/providers/credentials'

// @ts-ignore
import bcrypt from 'bcrypt'

const runtimeConfig = useRuntimeConfig();

interface UserData {
    user: {
        id: number,
        email: string,
        name: string,
        password: string,
        imageUrl: string,
        createdAt: Date,
        updatedAt: Date,
    }
}

async function GetUser(login: string) {
    const data = await $fetch('/api/user', { params: { login: login }}) as UserData
    return data.user
}

interface Credentials {
    login: string,
    password: string,
}

export default NuxtAuthHandler({
    secret: runtimeConfig.AUTH_SECRET,
    pages: {
        //change the default behavior to use '/' as the default login page
        signIn: '/',
    },
    providers: [
        // @ts-expect-error
        CredentialsProvider.default({
            name: "Credentials",
            async authorize(credentials: Credentials) {
                try {  
                    const l = credentials?.login.replace(/[.-]/g, '') //login without . and/or -
                    const user = await GetUser(l);
    
                    const correctPassword = await bcrypt.compare(
                        credentials.password,
                        user.password
                    )
    
                    if(correctPassword) {
                        return {
                            name: user.id + '-' + user.name, //cheese way to get the user id without using local credentials
                            image: user.imageUrl
                        }
                    }
                } catch(err) {
                    console.log(err)
                    throw createError({ statusCode: 401, statusMessage: 'Unauthorized' })
                }
            }
        })
    ]
})