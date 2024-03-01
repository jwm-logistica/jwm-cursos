import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient();

export default defineEventHandler(async(event) => {
    const id = parseInt(getQuery(event)?.id as string);

    if(!id) {
        console.log("ID not submited in URI ")
    }

    let error = null;

    const res = await prisma.chapters.findMany({
        where: {
            courseId: id,
        }, 
        orderBy: {
            number: 'asc'
        },
        include: {
            _count: {
                select: { lessons: true }
            },
            lessons: {
                orderBy: {
                    number: 'asc'
                },
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
        const chapters = res.map((r : any) => ({
            number: r.number,
            name: r.name,
            title: r.title,
            description: r.description,
            lessonsAmount: r._count.lessons,
            courseId: r.courseId,
            lessons: r.lessons,
        }));
    
        return { chapters };
    }
})