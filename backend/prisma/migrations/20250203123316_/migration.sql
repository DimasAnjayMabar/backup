/*
  Warnings:

  - You are about to drop the column `expired` on the `tokens` table. All the data in the column will be lost.

*/
-- DropIndex
DROP INDEX "tokens_expired_idx";

-- AlterTable
ALTER TABLE "tokens" DROP COLUMN "expired";
