import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { CallToolRequestSchema, ListToolsRequestSchema } from "@modelcontextprotocol/sdk/types.js";
import { categoryTools } from "./application/tools/category.tools";
import { productCatalogRouteTools } from "./infraestructure/product-catalog-tools.route";
import type { McpResponseType } from "./application/types/mcp-response.type";

// Init MCP Server
const mcpServer = new McpServer(
  {
    name: "product-catalog-mcp",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {},
    }
  }
);

// Register tools
mcpServer.server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      ...categoryTools
    ]
  }
});

// Route calls
mcpServer.server.setRequestHandler(
  CallToolRequestSchema, 
  async (request): Promise<McpResponseType> => {
    const { name, arguments: args } = request.params;
    try{
      const result = await productCatalogRouteTools(name, args);
      return result;
    }
    catch(err: any){
      return {
        isError: true,
        content: [
          {
            type: "text",
            text: `Error executing tool '${name}': ${err.message}`,
          },
        ],
      };
    }
  }
);

// main
async function main(){
  const transport = new StdioServerTransport();
  await mcpServer.connect(transport);
  console.error("Product Catalog MCP Server running on stdio");
}

main().catch(console.error);