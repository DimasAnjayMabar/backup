/*
  Warnings:

  - You are about to drop the `tokens` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[token]` on the table `users` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `token` to the `users` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "tokens" DROP CONSTRAINT "tokens_userId_fkey";

-- AlterTable
ALTER TABLE "users" ADD COLUMN     "token" TEXT NOT NULL;

-- DropTable
DROP TABLE "tokens";

-- CreateIndex
CREATE UNIQUE INDEX "users_token_key" ON "users"("token");
