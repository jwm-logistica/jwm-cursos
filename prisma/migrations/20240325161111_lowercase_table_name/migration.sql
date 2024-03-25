/*
  Warnings:

  - You are about to drop the column `email` on the `users` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[login]` on the table `users` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `login` to the `users` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE `alternatives` DROP FOREIGN KEY `Alternatives_questionNumber_fkey`;

-- DropForeignKey
ALTER TABLE `chapters` DROP FOREIGN KEY `Chapters_courseId_fkey`;

-- DropForeignKey
ALTER TABLE `coursesonusers` DROP FOREIGN KEY `CoursesOnUsers_courseId_fkey`;

-- DropForeignKey
ALTER TABLE `coursesonusers` DROP FOREIGN KEY `CoursesOnUsers_userId_fkey`;

-- DropForeignKey
ALTER TABLE `lessons` DROP FOREIGN KEY `Lessons_chapterNumber_fkey`;

-- DropForeignKey
ALTER TABLE `lessonshistory` DROP FOREIGN KEY `LessonsHistory_lessonNumber_fkey`;

-- DropForeignKey
ALTER TABLE `lessonshistory` DROP FOREIGN KEY `LessonsHistory_userId_fkey`;

-- DropForeignKey
ALTER TABLE `questions` DROP FOREIGN KEY `Questions_lessonNumber_fkey`;

-- DropForeignKey
ALTER TABLE `testsresults` DROP FOREIGN KEY `TestsResults_lessonNumber_fkey`;

-- DropForeignKey
ALTER TABLE `testsresults` DROP FOREIGN KEY `TestsResults_userId_fkey`;

-- DropIndex
DROP INDEX `Users_email_key` ON `users`;

-- AlterTable
ALTER TABLE `users` DROP COLUMN `email`,
    ADD COLUMN `login` VARCHAR(191) NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX `users_login_key` ON `users`(`login`);

-- AddForeignKey
ALTER TABLE `coursesonusers` ADD CONSTRAINT `coursesonusers_courseId_fkey` FOREIGN KEY (`courseId`) REFERENCES `courses`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `coursesonusers` ADD CONSTRAINT `coursesonusers_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `chapters` ADD CONSTRAINT `chapters_courseId_fkey` FOREIGN KEY (`courseId`) REFERENCES `courses`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `lessonshistory` ADD CONSTRAINT `lessonshistory_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `lessonshistory` ADD CONSTRAINT `lessonshistory_lessonNumber_fkey` FOREIGN KEY (`lessonNumber`) REFERENCES `lessons`(`number`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `lessons` ADD CONSTRAINT `lessons_chapterNumber_fkey` FOREIGN KEY (`chapterNumber`) REFERENCES `chapters`(`number`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `questions` ADD CONSTRAINT `questions_lessonNumber_fkey` FOREIGN KEY (`lessonNumber`) REFERENCES `lessons`(`number`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `alternatives` ADD CONSTRAINT `alternatives_questionNumber_fkey` FOREIGN KEY (`questionNumber`) REFERENCES `questions`(`number`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `testsresults` ADD CONSTRAINT `testsresults_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `testsresults` ADD CONSTRAINT `testsresults_lessonNumber_fkey` FOREIGN KEY (`lessonNumber`) REFERENCES `lessons`(`number`) ON DELETE CASCADE ON UPDATE CASCADE;

-- RedefineIndex
DROP INDEX `Alternatives_number_key` ON `alternatives`;
CREATE UNIQUE INDEX `alternatives_number_key` ON `alternatives`(`number`);

-- RedefineIndex
DROP INDEX `Chapters_number_key` ON `chapters`;
CREATE UNIQUE INDEX `chapters_number_key` ON `chapters`(`number`);

-- RedefineIndex
DROP INDEX `CoursesOnUsers_courseId_userId_key` ON `coursesonusers`;
CREATE UNIQUE INDEX `coursesonusers_courseId_userId_key` ON `coursesonusers`(`courseId`, `userId`);

-- RedefineIndex
DROP INDEX `Lessons_number_key` ON `lessons`;
CREATE UNIQUE INDEX `lessons_number_key` ON `lessons`(`number`);

-- RedefineIndex
DROP INDEX `LessonsHistory_userId_lessonNumber_key` ON `lessonshistory`;
CREATE UNIQUE INDEX `lessonshistory_userId_lessonNumber_key` ON `lessonshistory`(`userId`, `lessonNumber`);

-- RedefineIndex
DROP INDEX `Questions_number_key` ON `questions`;
CREATE UNIQUE INDEX `questions_number_key` ON `questions`(`number`);

-- RedefineIndex
DROP INDEX `TestsResults_userId_lessonNumber_key` ON `testsresults`;
CREATE UNIQUE INDEX `testsresults_userId_lessonNumber_key` ON `testsresults`(`userId`, `lessonNumber`);
