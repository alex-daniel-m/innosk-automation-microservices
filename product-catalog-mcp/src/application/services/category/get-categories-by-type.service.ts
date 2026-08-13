import { prisma } from "../../../infraestructure/client";
import { getCategoriesByTypeDto } from "../../dtos/category/get-categories-by-type.dto";
import type { McpResponseType } from "../../types/mcp-response.type";

export const getCategoriesByTypeService = async (
  args: unknown
): Promise<McpResponseType> => {
  
  const {
    category_type,
    is_active,
    limit
  } = getCategoriesByTypeDto.parse(args);

  const categories = await prisma.category.findMany({
    where: { category_type, is_active },
    take: limit,
    orderBy: { display_order: "asc" },
  });

  return {
    content: [{
      type: "text",
      text: JSON.stringify(categories, null, 2)
    }]
  }
};