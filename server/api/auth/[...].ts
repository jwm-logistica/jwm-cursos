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

async function GetUser(email: string) {
    const data = await $fetch('/api/user', { params: { email: email }}) as UserData
    return data.user
}

interface Credentials {
    email: string,
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
                if (!credentials?.email || !credentials?.password) {
                    throw createError({
                      statusCode: 500,
                      statusMessage: 'Missing Info'
                    })
                  }

                const user = await GetUser(credentials?.email);

                //email incorrect
                if (!user || !user.password) {
                    throw createError({
                      statusCode: 401,
                      statusMessage: 'Invalid Credentials'
                    })
                  }

                const correctPassword = await bcrypt.compare(
                    credentials.password,
                    user.password
                )

                if(correctPassword) {
                    return {
                        name: user.name,
                        email: user.id + '-' + user.email, //cheese way to get the user id without using local credentials
                        image: user.imageUrl
                    }
                } else {
                    //wrong password
                }
            }
        })
    ]
})