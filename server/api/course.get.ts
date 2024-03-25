import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient();

export default defineEventHandler(async(event) => {
    const id = parseInt(getQuery(event)?.id as string);
    const userId = parseInt(getQuery(event)?.userId as string);

    if(!id && !userId) {
        //dev environment testing
        console.log("IDs not submited in the query");
    }

    let error = null;

    const res = await prisma.coursesonusers.findUnique({
        where: {
            courseId_userId: {
                courseId: id,
                userId: userId
            }
        },
        include: {
            //courseId and userId are uniques together, so it is impossible to have another course
            courses: { 
                select: {
                    _count: {
                        select: {chapters: true}
                    },
                    name: true,
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
    
    if(res) {
        const course = {
            id: res.courseId,
            userId: res.userId,
            progress: res.progress,
            name: res.courses.name,
            average: res.average,
        }
    
        return { course };
    }
})