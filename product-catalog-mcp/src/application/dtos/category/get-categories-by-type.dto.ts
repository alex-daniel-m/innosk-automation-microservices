import { z } from "zod";
import { CategoryTypeEnum } from "../../../infraestructure/generated/prisma/enums";

export const getCategoriesByTypeDto = z.object({
  category_type: z.enum(CategoryTypeEnum),
  is_active: z.boolean().default(true),
  limit: z.number().default(100),
});