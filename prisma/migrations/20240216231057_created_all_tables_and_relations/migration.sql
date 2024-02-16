-- CreateTable
CREATE TABLE `Users` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `email` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `password` VARCHAR(191) NOT NULL,
    `imageUrl` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NULL,

    UNIQUE INDEX `Users_email_key`(`email`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Courses` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `description` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `CoursesOnUsers` (
    `courseId` INTEGER NOT NULL,
    `userId` INTEGER NOT NULL,
    `progress` INTEGER NOT NULL,
    `assignedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `CoursesOnUsers_courseId_userId_key`(`courseId`, `userId`),
    PRIMARY KEY (`courseId`, `userId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Chapters` (
    `number` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `title` VARCHAR(191) NOT NULL,
    `description` VARCHAR(191) NULL,
    `courseId` INTEGER NOT NULL,

    UNIQUE INDEX `Chapters_number_courseId_key`(`number`, `courseId`),
    PRIMARY KEY (`number`, `courseId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `LessonsHistory` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `completed` BOOLEAN NOT NULL DEFAULT false,
    `userId` INTEGER NOT NULL,
    `lessonType` ENUM('VIDEO', 'TEST') NOT NULL,
    `lessonName` VARCHAR(191) NOT NULL,
    `lessonDuration` INTEGER NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `LessonsHistory_userId_key`(`userId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Lessons` (
    `number` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `type` ENUM('VIDEO', 'TEST') NOT NULL DEFAULT 'VIDEO',
    `durationMinutes` INTEGER NOT NULL,
    `numQuestions` INTEGER NOT NULL,
    `chapterNumber` INTEGER NOT NULL,
    `courseId` INTEGER NOT NULL,

    UNIQUE INDEX `Lessons_number_chapterNumber_key`(`number`, `chapterNumber`),
    UNIQUE INDEX `Lessons_type_name_durationMinutes_key`(`type`, `name`, `durationMinutes`),
    PRIMARY KEY (`number`, `chapterNumber`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Questions` (
    `number` INTEGER NOT NULL AUTO_INCREMENT,
    `text` VARCHAR(191) NOT NULL,
    `correctAnswer` INTEGER NOT NULL,
    `lessonNumber` INTEGER NOT NULL,
    `chapterNumber` INTEGER NOT NULL,

    UNIQUE INDEX `Questions_number_lessonNumber_key`(`number`, `lessonNumber`),
    PRIMARY KEY (`number`, `lessonNumber`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Alternatives` (
    `number` INTEGER NOT NULL AUTO_INCREMENT,
    `text` VARCHAR(191) NOT NULL,
    `questionNumber` INTEGER NOT NULL,
    `lessonNumber` INTEGER NOT NULL,

    UNIQUE INDEX `Alternatives_number_questionNumber_key`(`number`, `questionNumber`),
    PRIMARY KEY (`number`, `questionNumber`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `TestsResults` (
    `totalQuestions` INTEGER NOT NULL,
    `correctAnswer` INTEGER NOT NULL,
    `userId` INTEGER NOT NULL,
    `lessonNumber` INTEGER NOT NULL,
    `chapterNumber` INTEGER NOT NULL,

    UNIQUE INDEX `TestsResults_userId_lessonNumber_key`(`userId`, `lessonNumber`),
    PRIMARY KEY (`userId`, `lessonNumber`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `CoursesOnUsers` ADD CONSTRAINT `CoursesOnUsers_courseId_fkey` FOREIGN KEY (`courseId`) REFERENCES `Courses`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `CoursesOnUsers` ADD CONSTRAINT `CoursesOnUsers_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `Users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Chapters` ADD CONSTRAINT `Chapters_courseId_fkey` FOREIGN KEY (`courseId`) REFERENCES `Courses`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `LessonsHistory` ADD CONSTRAINT `LessonsHistory_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `Users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `LessonsHistory` ADD CONSTRAINT `LessonsHistory_lessonType_lessonName_lessonDuration_fkey` FOREIGN KEY (`lessonType`, `lessonName`, `lessonDuration`) REFERENCES `Lessons`(`type`, `name`, `durationMinutes`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Lessons` ADD CONSTRAINT `Lessons_chapterNumber_courseId_fkey` FOREIGN KEY (`chapterNumber`, `courseId`) REFERENCES `Chapters`(`number`, `courseId`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Questions` ADD CONSTRAINT `Questions_lessonNumber_chapterNumber_fkey` FOREIGN KEY (`lessonNumber`, `chapterNumber`) REFERENCES `Lessons`(`number`, `chapterNumber`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Alternatives` ADD CONSTRAINT `Alternatives_questionNumber_lessonNumber_fkey` FOREIGN KEY (`questionNumber`, `lessonNumber`) REFERENCES `Questions`(`number`, `lessonNumber`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `TestsResults` ADD CONSTRAINT `TestsResults_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `Users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `TestsResults` ADD CONSTRAINT `TestsResults_lessonNumber_chapterNumber_fkey` FOREIGN KEY (`lessonNumber`, `chapterNumber`) REFERENCES `Lessons`(`number`, `chapterNumber`) ON DELETE RESTRICT ON UPDATE CASCADE;
