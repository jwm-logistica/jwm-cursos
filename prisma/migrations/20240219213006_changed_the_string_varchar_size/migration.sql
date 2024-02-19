/*
  Warnings:

  - You are about to alter the column `name` on the `chapters` table. The data in that column could be lost. The data in that column will be cast from `VarChar(191)` to `VarChar(100)`.
  - You are about to alter the column `name` on the `courses` table. The data in that column could be lost. The data in that column will be cast from `VarChar(191)` to `VarChar(100)`.
  - You are about to alter the column `name` on the `lessons` table. The data in that column could be lost. The data in that column will be cast from `VarChar(191)` to `VarChar(100)`.
  - You are about to alter the column `lessonName` on the `lessonshistory` table. The data in that column could be lost. The data in that column will be cast from `VarChar(191)` to `VarChar(100)`.
  - You are about to alter the column `name` on the `users` table. The data in that column could be lost. The data in that column will be cast from `VarChar(191)` to `VarChar(100)`.

*/
-- DropForeignKey
ALTER TABLE `lessonshistory` DROP FOREIGN KEY `LessonsHistory_lessonType_lessonName_lessonDuration_fkey`;

-- AlterTable
ALTER TABLE `alternatives` MODIFY `text` TEXT NOT NULL;

-- AlterTable
ALTER TABLE `chapters` MODIFY `name` VARCHAR(100) NOT NULL,
    MODIFY `description` MEDIUMTEXT NULL;

-- AlterTable
ALTER TABLE `courses` MODIFY `name` VARCHAR(100) NOT NULL,
    MODIFY `description` TEXT NOT NULL;

-- AlterTable
ALTER TABLE `lessons` MODIFY `name` VARCHAR(100) NOT NULL;

-- AlterTable
ALTER TABLE `lessonshistory` MODIFY `lessonName` VARCHAR(100) NOT NULL;

-- AlterTable
ALTER TABLE `questions` MODIFY `text` MEDIUMTEXT NOT NULL;

-- AlterTable
ALTER TABLE `users` MODIFY `name` VARCHAR(100) NOT NULL;

-- AddForeignKey
ALTER TABLE `LessonsHistory` ADD CONSTRAINT `LessonsHistory_lessonType_lessonName_lessonDuration_fkey` FOREIGN KEY (`lessonType`, `lessonName`, `lessonDuration`) REFERENCES `Lessons`(`type`, `name`, `durationMinutes`) ON DELETE RESTRICT ON UPDATE CASCADE;
