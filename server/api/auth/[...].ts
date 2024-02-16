import { NuxtAuthHandler } from '#auth'
import CredentialsProvider from 'next-auth/providers/credentials'

export default NuxtAuthHandler({
    pages: {
        //change the default behavior to use '/' as the default login page
        signIn: '/',
    },
    providers: [
        CredentialsProvider.default({
            name: "Credentials",
            authorize(credentials: any) {
                //the code below is not safe for production or proper authentication (used in dev)

                const user = {
                    email: "test@gmail.com",
                    password: "password"
                }

                if(credentials?.email === user?.email && credentials?.password === credentials?.password) {
                    return user;
                }
            }
        })
    ]
})