import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient();

export default defineEventHandler(async(event) => {
    const userId = parseInt(getQuery(event)?.userId as string);

    if(!userId) {
        //dev environment testing
        console.log("ID not submited in the query");
    }

    let error = null;

    const history = await prisma.lessonshistory.findMany({
        where: {
            userId: userId,
        }, 
        select : {
            updatedAt: true,
            completed: true,
            lesson: {
                select: {
                    number: true,
                    type: true,
                    name: true,
                    durationMinutes: true,
                    chapter: {
                        select: {
                            name: true,
                            course: {
                                select: { 
                                    name: true,
                                    id: true
                                }
                            }
                        }
                    }
                }
            }
        }
    }).catch(e => {
        error = e;
    })

    if(error) {
        console.log(error);
        return createError({statusCode: 500, statusMessage: 'Server error'})
    }
    
    if(history) {    
        return { history };
    }
})