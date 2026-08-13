-- CreateEnum
CREATE TYPE "CategoryTypeEnum" AS ENUM ('PRIMARY_PROBLEM', 'SECONDARY_PROBLEM', 'TOOL', 'INDUSTRY', 'PROJECT_TYPE', 'SOURCE_PLATFORM', 'OTHER');

-- CreateEnum
CREATE TYPE "SourceTypeEnum" AS ENUM ('SYSTEM', 'LLM', 'USER');

-- CreateEnum
CREATE TYPE "CSTypeEnum" AS ENUM ('PRODUCT_SPECIFICATION_CHARACTERISTIC', 'PARTY');

-- CreateEnum
CREATE TYPE "PSNameTypeEnum" AS ENUM ('PRODUCT_OFFERING_SPECIFICATION');

-- CreateTable
CREATE TABLE "category" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "name" VARCHAR(200) NOT NULL,
    "description" TEXT NOT NULL,
    "category_type" "CategoryTypeEnum" NOT NULL DEFAULT 'OTHER',
    "parent_category_id" UUID,
    "is_root" BOOLEAN NOT NULL DEFAULT false,
    "is_system" BOOLEAN NOT NULL DEFAULT true,
    "approved" BOOLEAN NOT NULL DEFAULT true,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "source" "SourceTypeEnum" NOT NULL DEFAULT 'SYSTEM',
    "usage_count" INTEGER NOT NULL DEFAULT 0,
    "display_order" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product_offering" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "name" VARCHAR(200) NOT NULL,
    "description" TEXT NOT NULL,
    "llm_overview" TEXT,
    "last_updated" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "product_offering_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product_offering_category" (
    "product_offering_id" UUID NOT NULL,
    "category_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "pk_product_offering_category" PRIMARY KEY ("product_offering_id","category_id")
);

-- CreateTable
CREATE TABLE "product_specification" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "product_offering_id" UUID NOT NULL,
    "name" "PSNameTypeEnum" NOT NULL DEFAULT 'PRODUCT_OFFERING_SPECIFICATION',
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "product_specification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "characteristic_specification" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "product_specification_id" UUID NOT NULL,
    "key" VARCHAR(100) NOT NULL,
    "value" TEXT NOT NULL,
    "type" "CSTypeEnum" NOT NULL DEFAULT 'PRODUCT_SPECIFICATION_CHARACTERISTIC',

    CONSTRAINT "characteristic_specification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product_offering_price" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "product_offering_id" UUID NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "price_min" BIGINT NOT NULL DEFAULT 0,
    "price_max" BIGINT NOT NULL DEFAULT 0,

    CONSTRAINT "product_offering_price_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "idx_parent_category_id" ON "category"("parent_category_id");

-- CreateIndex
CREATE UNIQUE INDEX "uk_name_category_type" ON "category"("name", "category_type");

-- CreateIndex
CREATE INDEX "idx_product_offering_category_category_id" ON "product_offering_category"("category_id");

-- CreateIndex
CREATE UNIQUE INDEX "product_specification_product_offering_id_key" ON "product_specification"("product_offering_id");

-- CreateIndex
CREATE INDEX "idx_product_specification_offering_id" ON "product_specification"("product_offering_id");

-- CreateIndex
CREATE INDEX "idx_characteristic_specification_ps_id" ON "characteristic_specification"("product_specification_id");

-- CreateIndex
CREATE UNIQUE INDEX "uk_product_specification_id_key" ON "characteristic_specification"("product_specification_id", "key");

-- CreateIndex
CREATE INDEX "idx_product_offering_price_offering_id" ON "product_offering_price"("product_offering_id");

-- AddForeignKey
ALTER TABLE "category" ADD CONSTRAINT "category_parent_category_id_fkey" FOREIGN KEY ("parent_category_id") REFERENCES "category"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "product_offering_category" ADD CONSTRAINT "product_offering_category_product_offering_id_fkey" FOREIGN KEY ("product_offering_id") REFERENCES "product_offering"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_offering_category" ADD CONSTRAINT "product_offering_category_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "category"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_specification" ADD CONSTRAINT "product_specification_product_offering_id_fkey" FOREIGN KEY ("product_offering_id") REFERENCES "product_offering"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "characteristic_specification" ADD CONSTRAINT "characteristic_specification_product_specification_id_fkey" FOREIGN KEY ("product_specification_id") REFERENCES "product_specification"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_offering_price" ADD CONSTRAINT "product_offering_price_product_offering_id_fkey" FOREIGN KEY ("product_offering_id") REFERENCES "product_offering"("id") ON DELETE CASCADE ON UPDATE CASCADE;
