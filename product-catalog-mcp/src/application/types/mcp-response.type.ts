type McpTextContent = {
  type: "text";
  text: string;
};

type McpImageContent = {
  type: "image";
  data: string; // Base64
  mimeType: string;
};

type McpResourceContent = {
  type: "resource";
  resource: {
    uri: string;
    text?: string;
    blob?: string;
  };
};

type McpContent = McpTextContent | McpImageContent | McpResourceContent;

export type McpResponseType = {
  isError?: boolean;
  content: McpContent[];
};