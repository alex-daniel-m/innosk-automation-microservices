import { createCategoryService } from "../application/services/category/create-category.service"
import { getCategoriesByTypeService } from "../application/services/category/get-categories-by-type.service"
import { getCategoryByIdService } from "../application/services/category/get-category-by-id.service"

/**
 * 
 * key - value
 * 
 */
const toolHandlers = {
  // category
  createCategory: createCategoryService,
  getCategoryById: getCategoryByIdService,
  getCategoriesByType: getCategoriesByTypeService,
  // product_specification
  // product_offering_price
  // product_offering
} as const;


/**
 * 
 * Type of the tool
 * 
 */
type toolNameType = keyof typeof toolHandlers;


/**
 * 
 * Type guard
 * 
 */
const isToolName = (
  name: string
): name is toolNameType => {
  return name in toolHandlers;
};


/**
 * 
 * Route Handler
 * 
 */
export const productCatalogRouteTools = async (
  name: string, 
  args: unknown
) => {

  if (!isToolName(name)) {
    throw new Error(`Unknown product catalog tool: ${name}`);
  }

  const handler = toolHandlers[name];
  return handler(args);
};