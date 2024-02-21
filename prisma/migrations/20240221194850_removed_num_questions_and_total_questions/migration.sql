/*
  Warnings:

  - You are about to drop the column `numQuestions` on the `lessons` table. All the data in the column will be lost.
  - You are about to drop the column `totalQuestions` on the `testsresults` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE `lessons` DROP COLUMN `numQuestions`;

-- AlterTable
ALTER TABLE `testsresults` DROP COLUMN `totalQuestions`;
