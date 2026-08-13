import { prisma } from "../../../infraestructure/client";
import { getCategoryByIdDto } from "../../dtos/category/get-category-by-id.dto";
import type { McpResponseType } from "../../types/mcp-response.type";

export const getCategoryByIdService = async (
  args: unknown
): Promise<McpResponseType> => {

  const { id } = getCategoryByIdDto.parse(args);
  const category = await prisma.category.findUnique({
    where: { id },
    include: { children: true, parent: true },
  });

  if(!category){
    return {
      isError: true,
      content: [{
        type: "text",
        text: `Not found Category with ID ${id}`,
      }]
    }
  }

  return {
    content: [{
      type: "text",
      text: JSON.stringify(category, null, 2),
    }]
  }
};