import { type Tool } from "@modelcontextprotocol/sdk/types";
import { CategoryTypeEnum, SourceTypeEnum } from "../../infraestructure/generated/prisma/enums.ts";

export const categoryTools: Tool[] = [
  {
    name: "createCategory",
    description: "Creates a new taxonomy category in the catalog to classify leads, job offerings, tools, industries, or problem types. Use this tool when an agent identifies a novel classification tag (e.g., a new tool like 'n8n', a problem domain, or a job source platform) that does not yet exist in the database.",
    inputSchema: {
      type: "object",
      properties: {
        name: { 
          type: "string", 
          description: "The unique name of the category (e.g., 'Make.com', 'CRM Integration', 'UpWork')."
        },
        description: { 
          type: "string", 
          description: "A comprehensive explanation of what this category represents and its scope."
        },
        category_type: {
          type: "string",
          enum: Object.values(CategoryTypeEnum),
          description: "The functional type classification (e.g., PRIMARY_PROBLEM, SECONDARY_PROBLEM, TOOL, INDUSTRY, PROJECT_TYPE, SOURCE_PLATFORM, OTHER).",
        },
        parent_category_id: { 
          type: "string", 
          description: "Optional UUID of the parent category if this is a subcategory or sub-skill."
        },
        is_root: { 
          type: "boolean", 
          description: "Set to true if this category acts as a top-level node without any parent."
        },
        is_system: {
          type: "boolean",
          description: "Flags if the category is system-managed (true) or user-created/custom (false)."
        },
        approved: {
          type: "boolean",
          description: "Indicates if the category has been verified for global use across the catalog."
        },
        is_active: {
          type: "boolean",
          description: "Determines if the category is available for tagging active job offerings."
        },
        source: { 
          type: "string", 
          enum: Object.values(SourceTypeEnum),
          description: "The origin entity that generated this category (SYSTEM, LLM, or USER)."
        },
      },
      required: [
        "name", 
        "description", 
        "category_type",
        "is_root",
        "is_system",
        "approved",
        "is_active",
        "source"
      ],
    },
  },
  {
    name: "getCategoryById",
    description: "Retrieves full details for a specific category using its unique UUID, including its direct children (subcategories) and parent category node. Useful for inspecting taxonomy hierarchies.",
    inputSchema: {
      type: "object",
      properties: {
        id: { 
          type: "string", 
          description: "The valid UUID string of the target category to fetch."
        },
      },
      required: [
        "id"
      ],
    },
  },
  {
    name: "getCategoriesByType",
    description: "Fetches a list of existing categories filtered by their functional type (e.g., list all available TOOL categories, INDUSTRY categories, or PRIMARY_PROBLEM categories). Use this before creating a new category to check for existing duplicates.",
    inputSchema: {
      type: "object",
      properties: {
        category_type: { 
          type: "string", 
          enum: Object.values(CategoryTypeEnum),
          description: "The functional type classification (e.g., PRIMARY_PROBLEM, SECONDARY_PROBLEM, TOOL, INDUSTRY, PROJECT_TYPE, SOURCE_PLATFORM, OTHER).",
        },
        is_active: { 
          type: "boolean", 
          default: true,
          description: "Filter by active status. Defaults to true to return only active categories."
        },
        limit: { 
          type: "number", 
          default: 100,
          description: "Maximum number of category records to return in a single call (default: 100)."
        },
      },
      required: [
        "category_type",
        "is_active",
        "limit",
      ],
    },
  },
];