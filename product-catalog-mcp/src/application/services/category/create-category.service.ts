import { prisma } from "../../../infraestructure/client";
import { createCategoryDto } from "../../dtos/category/create-category.dto"
import type { McpResponseType } from "../../types/mcp-response.type";

export const createCategoryService = async (
  args: unknown
): Promise<McpResponseType> => {

  const parsed = createCategoryDto.parse(args);
  const category = await prisma.category.create({
    data: parsed,
  });
  
  return {
    content: [{
      type: "text",
      text: JSON.stringify(category, null, 2),
    }]
  }
}