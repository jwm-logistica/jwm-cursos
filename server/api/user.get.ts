import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient();

export default defineEventHandler(async(event) => {
    const login = getQuery(event)?.login as string;

    let error = null;
    
    const user = await prisma.users.findUnique({
        where: {
          login: login,
        },
      }).catch(e => {
        error = e;
      })

    if(error) {
        return createError({statusCode: 500, statusMessage: 'Server error'})
    }

    return { user: user };
})