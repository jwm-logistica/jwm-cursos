import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient();

export default defineEventHandler(async(event) => {
    const body = await readBody(event);

    if(!body.userId || !body.lessonNumber || !body.correctAnswers) {
        console.log("Data not submitted in results body", body)
        return createError({statusCode: 500, statusMessage: 'Server error'})
    }

    let error = null;

    const res = await prisma.testsresults.upsert({
        where: {
            userId_lessonNumber: {
                userId: body.userId,
                lessonNumber: body.lessonNumber
            }
        },
        update: {
            correctAnswers: body.correctAnswers
        }, 
        create: {
            correctAnswers: body.correctAnswers,
            userId: body.userId,
            lessonNumber: body.lessonNumber
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