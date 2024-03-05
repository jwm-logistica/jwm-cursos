/*
  Warnings:

  - The primary key for the `alternatives` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `lessonNumber` on the `alternatives` table. All the data in the column will be lost.
  - The primary key for the `chapters` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `lessons` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `courseId` on the `lessons` table. All the data in the column will be lost.
  - You are about to drop the column `chapterNumber` on the `lessonshistory` table. All the data in the column will be lost.
  - The primary key for the `questions` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `chapterNumber` on the `questions` table. All the data in the column will be lost.
  - You are about to drop the column `chapterNumber` on the `testsresults` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[number]` on the table `Alternatives` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[number]` on the table `Chapters` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[number]` on the table `Lessons` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[number]` on the table `Questions` will be added. If there are existing duplicate values, this will fail.

*/
-- DropForeignKey
ALTER TABLE `alternatives` DROP FOREIGN KEY `Alternatives_questionNumber_lessonNumber_fkey`;

-- DropForeignKey
ALTER TABLE `lessons` DROP FOREIGN KEY `Lessons_chapterNumber_courseId_fkey`;

-- DropForeignKey
ALTER TABLE `lessonshistory` DROP FOREIGN KEY `LessonsHistory_lessonNumber_chapterNumber_fkey`;

-- DropForeignKey
ALTER TABLE `questions` DROP FOREIGN KEY `Questions_lessonNumber_chapterNumber_fkey`;

-- DropForeignKey
ALTER TABLE `testsresults` DROP FOREIGN KEY `TestsResults_lessonNumber_chapterNumber_fkey`;

-- DropIndex
DROP INDEX `Alternatives_number_questionNumber_key` ON `alternatives`;

-- DropIndex
DROP INDEX `Chapters_number_courseId_key` ON `chapters`;

-- DropIndex
DROP INDEX `Lessons_number_chapterNumber_key` ON `lessons`;

-- DropIndex
DROP INDEX `Questions_number_lessonNumber_key` ON `questions`;

-- AlterTable
ALTER TABLE `alternatives` DROP PRIMARY KEY,
    DROP COLUMN `lessonNumber`,
    ADD PRIMARY KEY (`number`);

-- AlterTable
ALTER TABLE `chapters` DROP PRIMARY KEY,
    ADD PRIMARY KEY (`number`);

-- AlterTable
ALTER TABLE `lessons` DROP PRIMARY KEY,
    DROP COLUMN `courseId`,
    ADD PRIMARY KEY (`number`);

-- AlterTable
ALTER TABLE `lessonshistory` DROP COLUMN `chapterNumber`;

-- AlterTable
ALTER TABLE `questions` DROP PRIMARY KEY,
    DROP COLUMN `chapterNumber`,
    ADD PRIMARY KEY (`number`);

-- AlterTable
ALTER TABLE `testsresults` DROP COLUMN `chapterNumber`;

-- CreateIndex
CREATE UNIQUE INDEX `Alternatives_number_key` ON `Alternatives`(`number`);

-- CreateIndex
CREATE UNIQUE INDEX `Chapters_number_key` ON `Chapters`(`number`);

-- CreateIndex
CREATE UNIQUE INDEX `Lessons_number_key` ON `Lessons`(`number`);

-- CreateIndex
CREATE UNIQUE INDEX `Questions_number_key` ON `Questions`(`number`);

-- AddForeignKey
ALTER TABLE `LessonsHistory` ADD CONSTRAINT `LessonsHistory_lessonNumber_fkey` FOREIGN KEY (`lessonNumber`) REFERENCES `Lessons`(`number`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Lessons` ADD CONSTRAINT `Lessons_chapterNumber_fkey` FOREIGN KEY (`chapterNumber`) REFERENCES `Chapters`(`number`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Questions` ADD CONSTRAINT `Questions_lessonNumber_fkey` FOREIGN KEY (`lessonNumber`) REFERENCES `Lessons`(`number`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Alternatives` ADD CONSTRAINT `Alternatives_questionNumber_fkey` FOREIGN KEY (`questionNumber`) REFERENCES `Questions`(`number`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `TestsResults` ADD CONSTRAINT `TestsResults_lessonNumber_fkey` FOREIGN KEY (`lessonNumber`) REFERENCES `Lessons`(`number`) ON DELETE CASCADE ON UPDATE CASCADE;
