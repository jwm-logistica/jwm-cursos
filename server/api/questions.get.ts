import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient();

export default defineEventHandler(async(event) => {
    const lessonNumber = parseInt(getQuery(event)?.lessonNumber as string);

    if(!lessonNumber) {
        console.log("ID not submited in URI")
    }

    let error = null;

    const res = await prisma.lessons.findUnique({
        where: {
            number: lessonNumber,
        }, 
        include: {
            _count: {
                select: { questions: true }
            },
            questions: {
                orderBy: {
                    number: 'asc'
                },
                include: {
                    alternatives: {
                        orderBy: {
                            number: 'asc'
                        },
                    },
                }
            },
        }
    }).catch(e => {
        error = e;
    })

    if(error) {
        console.log(error);
        return createError({statusCode: 500, statusMessage: 'Server error'})
    }

    if(res) {
        const questionsFromLesson = {
            questions: [
                ...res.questions,
            ],
            amount: res._count.questions,
        }
    
        return { questionsFromLesson };
    }
})