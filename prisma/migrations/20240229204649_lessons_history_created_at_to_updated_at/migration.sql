/*
  Warnings:

  - You are about to drop the column `createdAt` on the `lessonshistory` table. All the data in the column will be lost.
  - Added the required column `updatedAt` to the `LessonsHistory` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `lessonshistory` DROP COLUMN `createdAt`,
    ADD COLUMN `updatedAt` DATETIME(3) NOT NULL;
