import { NuxtAuthHandler } from '#auth'
import CredentialsProvider from 'next-auth/providers/credentials'

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
    const data = await $fetch(`/api/user?email=${encodeURIComponent(email)}`) as UserData
    return data.user
}

interface Credentials {
    email: string,
    password: string,
}

export default NuxtAuthHandler({
    pages: {
        //change the default behavior to use '/' as the default login page
        signIn: '/',
    },
    providers: [
        CredentialsProvider.default({
            name: "Credentials",
            async authorize(credentials: Credentials) {
                //the code below is not safe for production or proper authentication (used in dev)

                const user = await GetUser(credentials?.email);
                //if(!user) wrong email

                if(credentials?.password === user?.password) {
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