import { z } from 'zod';

export const getCategoryByIdDto = z.object({
  id: z.uuid(),
});