/*
  Warnings:

  - Added the required column `imageUrl` to the `Courses` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `courses` ADD COLUMN `imageUrl` VARCHAR(191) NOT NULL;
