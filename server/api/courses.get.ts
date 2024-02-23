import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient();

export default defineEventHandler(async(event) => {
    const id = parseInt(getQuery(event)?.id as string);

    if(!id) {
        console.log("ID not submited in URI")
    }

    let error = null;

    const res = await prisma.coursesOnUsers.findMany({
        where: {
            userId: id,
        }, 
        include: {
            courses: {
                include: {
                    _count: {
                        select: { chapters: true }
                    },
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
        const courses = res.map((r : any) => ({
            id: r.courseId,
            userId: r.userId,
            name: r.courses.name,
            description: r.courses.description,
            imageUrl: r.courses.imageUrl,
            chaptersAmount: r.courses._count.chapters,
            progress: r.progress,
            assignedAt: r.assignedAt,

        }));
    
        return { courses };
    }
})