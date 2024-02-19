/*
  Warnings:

  - You are about to drop the column `correctAnswer` on the `testsresults` table. All the data in the column will be lost.
  - Added the required column `correctAnswers` to the `TestsResults` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `lessons` ADD COLUMN `videoUrl` VARCHAR(191) NULL,
    MODIFY `durationMinutes` INTEGER NULL,
    MODIFY `numQuestions` INTEGER NULL;

-- AlterTable
ALTER TABLE `testsresults` DROP COLUMN `correctAnswer`,
    ADD COLUMN `correctAnswers` INTEGER NOT NULL;
