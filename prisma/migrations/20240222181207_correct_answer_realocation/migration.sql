/*
  Warnings:

  - You are about to drop the column `correctAnswer` on the `questions` table. All the data in the column will be lost.
  - Added the required column `correctAnswer` to the `Alternatives` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `alternatives` ADD COLUMN `correctAnswer` BOOLEAN NOT NULL;

-- AlterTable
ALTER TABLE `questions` DROP COLUMN `correctAnswer`;
