import { z } from 'zod';
import { CategoryTypeEnum, SourceTypeEnum } from '../../../infraestructure/generated/prisma/enums';

export const createCategoryDto = z.object({
  name: z.string().min(1).max(200),
  description: z.string(),
  category_type: z.enum(CategoryTypeEnum),
  parent_category_id: z.uuid().optional(),
  is_root: z.boolean().default(false),
  is_system: z.boolean().default(true),
  approved: z.boolean().default(true),
  is_active: z.boolean().default(true),
  source: z.enum(SourceTypeEnum).optional().default(SourceTypeEnum.SYSTEM),
});

