import { readFileSync, writeFileSync } from "node:fs";

let sql = readFileSync("004_category_seed.sql", "utf8");

sql = sql.replace(
  /(insert\s+into\s+\w+\s*)\(([\s\S]*?)\)(\s*values)/gi,
  (_, insert, columns, values) => {
    const oneLine = columns
      .split("\n")
      .map((l) => l.trim())
      .filter(Boolean)
      .join(" ");

    return `${insert}(${oneLine})${values}`;
  }
);

writeFileSync("004_category_seed.sql", sql);