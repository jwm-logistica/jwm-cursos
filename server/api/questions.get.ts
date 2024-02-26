import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient();

export default defineEventHandler(async(event) => {
    const id = parseInt(getQuery(event)?.id as string);
    const chapterNumber = parseInt(getQuery(event)?.chapterNumber as string);

    if(!id || !chapterNumber) {
        console.log("IDs not submited in URI")
    }

    let error = null;

    const res = await prisma.lessons.findUnique({
        where: {
            number_chapterNumber: {
                number: id,
                chapterNumber: chapterNumber,
            },
        }, 
        include: {
            _count: {
                select: { questions: true }
            },
            questions: {
                include: {
                    alternatives: true,
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