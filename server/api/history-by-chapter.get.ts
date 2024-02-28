import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient();

interface History {
    courseId: number,
    chapterNumber: number,
    lessons: {
        number: number,
        completed: boolean,
        createdAt: Date,
    }[];
}

export default defineEventHandler(async(event) => {
    const userId = parseInt(getQuery(event)?.userId as string);
    const courseId = parseInt(getQuery(event)?.courseId as string);

    if(!userId || !courseId) {
        //dev environment testing
        console.log("IDs not submited in the query");
    }

    let error = null;

    const res = await prisma.lessonsHistory.findMany({
        where: {
            AND: [
                {
                    userId: userId,
                },
                {
                    lesson: {
                        courseId: courseId,
                    }
                }  
            ]
        }, 
        select : {
            createdAt: true,
            completed: true,
            lessonNumber: true,
            lesson: {
                select: {
                    courseId: true,
                    chapterNumber: true
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

    const historyByChapter: History[] = [];
    res?.forEach(element => {
        const chapterIndex = historyByChapter.findIndex(item => item.chapterNumber = element.lesson.chapterNumber);

        if(chapterIndex == -1) {
            historyByChapter.push({
                courseId: element.lesson.courseId,
                chapterNumber: element.lesson.chapterNumber,
                lessons: [{
                    number: element.lessonNumber,
                    completed: element.completed,
                    createdAt: element.createdAt
                }]
            })
        } else {
            historyByChapter[chapterIndex].lessons.push({
                number: element.lessonNumber,
                completed: element.completed,
                createdAt: element.createdAt,
            })
        }
    });
    
    if(historyByChapter) {    
        return { historyByChapter };
    }
})