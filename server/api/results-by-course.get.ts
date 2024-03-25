import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient();

interface TestResultsByCourse {
    correctAnswers: number,
    lessonNumber: number,
    questionsAmount: number,
}

export default defineEventHandler(async(event) => {
    const userId = parseInt(getQuery(event)?.userId as string);
    const courseId = parseInt(getQuery(event)?.courseId as string);

    if(!userId) {
        //dev environment testing
        console.log("ID not submited in the query");
    }

    let error = null;

    const res = await prisma.testsresults.findMany({
        where: {
            AND: [
                {
                    userId: userId
                },
                {
                    lesson: {
                        chapter: {
                            courseId: courseId
                        }
                    }
                }
            ]
        }, 
        select: {
            correctAnswers: true,
            lessonNumber: true,
            lesson: {
                select: {
                    _count: {
                        select: { questions: true }
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
    
    if(res) {    
        const testResultsByCourse : TestResultsByCourse[] = [];

        res.forEach(r => {
            testResultsByCourse.push({
                correctAnswers: r.correctAnswers,
                lessonNumber: r.lessonNumber,
                questionsAmount: r.lesson._count.questions,
            })
        })

        return { testResultsByCourse };
    }
})