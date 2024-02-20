import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient();

export default defineEventHandler(async(event) => {
    const id = parseInt(getQuery(event)?.id as string);

    if(!id) {
        console.log("ID not submited in URI ")
    }

    let error = null;

    const res = await prisma.coursesOnUsers.findMany({
        where: {
            userId: id,
        }, 
        select: {
            courses: {
                include: {
                    _count: {
                        select: { chapters: true }
                    },
                }
            },
            progress: true,
            assignedAt: true,
        }
    }).catch(e => {
        error = e;
    })

    if(error) {
        console.log(error);
        return createError({statusCode: 500, statusMessage: 'Server error'})
    }
    
    if(res) {
        const courses = res.map((resCourse : any) => ({
            id: resCourse.courses.id,
            name: resCourse.courses.name,
            description: resCourse.courses.description,
            imageUrl: resCourse.courses.imageUrl,
            chaptersAmount: resCourse.courses._count.chapters,
            progress: resCourse.progress,
            assignedAt: resCourse.assignedAt,
        }));
    
        return { courses };
    }
})