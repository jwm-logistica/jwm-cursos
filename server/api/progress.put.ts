import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient();

export default defineEventHandler(async(event) => {
    const body = await readBody(event);

    if(!body.courseId || !body.userId) {
        console.log("Data not submitted in progress body", body)
        return createError({statusCode: 500, statusMessage: 'Server error'})
    }

    let error = null;

    const res = await prisma.coursesOnUsers.update({
        where: {
            courseId_userId: {
                courseId: body.courseId,
                userId: body.userId,
            }
        },
        data: {
            progress: body.progress,
        }
    }).catch(e => {
        error = e;
    })

    if(error) {
        console.log(error);
        return createError({statusCode: 500, statusMessage: 'Server error'})
    }

    if(res) {  
        return { res };
    }
})