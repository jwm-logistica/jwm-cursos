-- DropForeignKey
ALTER TABLE `alternatives` DROP FOREIGN KEY `Alternatives_questionNumber_lessonNumber_fkey`;

-- DropForeignKey
ALTER TABLE `chapters` DROP FOREIGN KEY `Chapters_courseId_fkey`;

-- DropForeignKey
ALTER TABLE `coursesonusers` DROP FOREIGN KEY `CoursesOnUsers_courseId_fkey`;

-- DropForeignKey
ALTER TABLE `coursesonusers` DROP FOREIGN KEY `CoursesOnUsers_userId_fkey`;

-- DropForeignKey
ALTER TABLE `lessons` DROP FOREIGN KEY `Lessons_chapterNumber_courseId_fkey`;

-- DropForeignKey
ALTER TABLE `lessonshistory` DROP FOREIGN KEY `LessonsHistory_lessonType_lessonName_lessonDuration_fkey`;

-- DropForeignKey
ALTER TABLE `lessonshistory` DROP FOREIGN KEY `LessonsHistory_userId_fkey`;

-- DropForeignKey
ALTER TABLE `questions` DROP FOREIGN KEY `Questions_lessonNumber_chapterNumber_fkey`;

-- DropForeignKey
ALTER TABLE `testsresults` DROP FOREIGN KEY `TestsResults_lessonNumber_chapterNumber_fkey`;

-- DropForeignKey
ALTER TABLE `testsresults` DROP FOREIGN KEY `TestsResults_userId_fkey`;

-- AddForeignKey
ALTER TABLE `CoursesOnUsers` ADD CONSTRAINT `CoursesOnUsers_courseId_fkey` FOREIGN KEY (`courseId`) REFERENCES `Courses`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `CoursesOnUsers` ADD CONSTRAINT `CoursesOnUsers_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `Users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Chapters` ADD CONSTRAINT `Chapters_courseId_fkey` FOREIGN KEY (`courseId`) REFERENCES `Courses`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `LessonsHistory` ADD CONSTRAINT `LessonsHistory_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `Users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `LessonsHistory` ADD CONSTRAINT `LessonsHistory_lessonType_lessonName_lessonDuration_fkey` FOREIGN KEY (`lessonType`, `lessonName`, `lessonDuration`) REFERENCES `Lessons`(`type`, `name`, `durationMinutes`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Lessons` ADD CONSTRAINT `Lessons_chapterNumber_courseId_fkey` FOREIGN KEY (`chapterNumber`, `courseId`) REFERENCES `Chapters`(`number`, `courseId`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Questions` ADD CONSTRAINT `Questions_lessonNumber_chapterNumber_fkey` FOREIGN KEY (`lessonNumber`, `chapterNumber`) REFERENCES `Lessons`(`number`, `chapterNumber`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Alternatives` ADD CONSTRAINT `Alternatives_questionNumber_lessonNumber_fkey` FOREIGN KEY (`questionNumber`, `lessonNumber`) REFERENCES `Questions`(`number`, `lessonNumber`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `TestsResults` ADD CONSTRAINT `TestsResults_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `Users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `TestsResults` ADD CONSTRAINT `TestsResults_lessonNumber_chapterNumber_fkey` FOREIGN KEY (`lessonNumber`, `chapterNumber`) REFERENCES `Lessons`(`number`, `chapterNumber`) ON DELETE CASCADE ON UPDATE CASCADE;
