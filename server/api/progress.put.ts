import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient();

export default defineEventHandler(async(event) => {
    const body = await readBody(event);

    if(!body.courseId || !body.userId) {
        console.log("Data not submitted in progress body", body)
        return createError({statusCode: 500, statusMessage: 'Server error'})
    }

    let error = null;
    
    let data = {}
    if(body.progress && body.average) {
        data = {
            progress: body.progress,
            average: body.average,
        }
    } else if(body.progress) {
        data = {
            progress: body.progress,
        }
    } else if(body.average) {
        data = {
            average: body.average
        }
    }

    const res = await prisma.coursesonusers.update({
        where: {
            courseId_userId: {
                courseId: body.courseId,
                userId: body.userId,
            }
        },
        data: data,
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