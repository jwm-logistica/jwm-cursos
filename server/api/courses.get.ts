import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient();

export default defineEventHandler(async(event) => {
    const courses = await prisma.courses.findMany()

    return { courses };
})