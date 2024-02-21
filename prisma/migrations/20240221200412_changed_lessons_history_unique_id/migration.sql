/*
  Warnings:

  - The primary key for the `lessonshistory` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `id` on the `lessonshistory` table. All the data in the column will be lost.
  - You are about to drop the column `lessonDuration` on the `lessonshistory` table. All the data in the column will be lost.
  - You are about to drop the column `lessonName` on the `lessonshistory` table. All the data in the column will be lost.
  - You are about to drop the column `lessonType` on the `lessonshistory` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[userId,lessonNumber]` on the table `LessonsHistory` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `chapterNumber` to the `LessonsHistory` table without a default value. This is not possible if the table is not empty.
  - Added the required column `lessonNumber` to the `LessonsHistory` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE `lessonshistory` DROP FOREIGN KEY `LessonsHistory_lessonType_lessonName_lessonDuration_fkey`;

-- DropIndex
DROP INDEX `Lessons_type_name_durationMinutes_key` ON `lessons`;

-- AlterTable
ALTER TABLE `lessonshistory` DROP PRIMARY KEY,
    DROP COLUMN `id`,
    DROP COLUMN `lessonDuration`,
    DROP COLUMN `lessonName`,
    DROP COLUMN `lessonType`,
    ADD COLUMN `chapterNumber` INTEGER NOT NULL,
    ADD COLUMN `lessonNumber` INTEGER NOT NULL,
    ADD PRIMARY KEY (`userId`, `lessonNumber`);

-- CreateIndex
CREATE UNIQUE INDEX `LessonsHistory_userId_lessonNumber_key` ON `LessonsHistory`(`userId`, `lessonNumber`);

-- AddForeignKey
ALTER TABLE `LessonsHistory` ADD CONSTRAINT `LessonsHistory_lessonNumber_chapterNumber_fkey` FOREIGN KEY (`lessonNumber`, `chapterNumber`) REFERENCES `Lessons`(`number`, `chapterNumber`) ON DELETE CASCADE ON UPDATE CASCADE;
