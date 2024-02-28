import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient();

export default defineEventHandler(async(event) => {
    const body = await readBody(event);

    if(!body.userId || !body.lessonNumber || !body.completed || !body.chapterNumber) {
        console.log("Data not submitted in body", body)
        return createError({statusCode: 500, statusMessage: 'Server error'})
    }

    let error = null;

    const res = await prisma.lessonsHistory.upsert({
        where: {
            userId_lessonNumber: {
                userId: body.userId,
                lessonNumber: body.lessonNumber
            }
        },
        update: {
            completed: body.completed
        }, 
        create: {
            completed: body.completed,
            userId: body.userId,
            lessonNumber: body.lessonNumber,
            chapterNumber: body.chapterNumber
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