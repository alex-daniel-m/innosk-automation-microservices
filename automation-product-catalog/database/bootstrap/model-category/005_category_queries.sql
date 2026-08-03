-- Select By Id
-- E-commerce
select * from category where id = 'd1e3870b-2515-4c06-b544-74b41e3d9d49';
-- Other
select * from category where id = 'bf604f6c-21b0-4894-bd45-f85acd25ceda';

-- Select by Root Categories
select * from category where is_root = TRUE order by display_order;
select * from category where is_root = FALSE order by display_order;

-- Select By OTHER Children's Categories
select * from category where parent_category_id = 'bf604f6c-21b0-4894-bd45-f85acd25ceda' order by display_order;

-- Select By Active Categories
select * from category where is_active = TRUE order by display_order;

-- by name
SELECT * FROM category WHERE name = $1;
SELECT * FROM category WHERE LOWER(name) LIKE LOWER('%real%') ORDER BY name;
SELECT * FROM category WHERE name ILIKE '%real%';

-- Select By Category Type
-- INDUSTRY
select * from category where category_type = 'PRIMARY_PROBLEM' order by display_order;
select * from category where category_type = 'SECONDARY_PROBLEM' order by display_order;
select * from category where category_type = 'TOOL' order by display_order;
select * from category where category_type = 'INDUSTRY' order by display_order;
select * from category where category_type = 'OTHER' order by display_order;

-- system categories
SELECT * FROM category WHERE is_system = TRUE;

-- approved categories
SELECT * FROM category WHERE approved = TRUE;

-- all visible categories
SELECT * FROM category WHERE approved = TRUE AND is_active = TRUE ORDER BY display_order;

-- 
WITH RECURSIVE category_tree AS (

    SELECT * FROM category WHERE id = $1
    UNION ALL
    SELECT c.* FROM category c INNER JOIN category_tree ct ON c.parent_category_id = ct.id

)

SELECT * FROM category_tree;

-- number of childs
SELECT COUNT(*) FROM category WHERE parent_category_id = $1;

-- update usage count
UPDATE category SET usage_count = usage_count + 1 WHERE id = $1;

-- soft delete
UPDATE category SET is_active = FALSE WHERE id = $1;

-- pagination
SELECT * FROM category ORDER BY display_order LIMIT 20 OFFSET 40;

-- by source
SELECT * FROM category WHERE source = 'SYSTEM';

-- some filters
SELECT * FROM category WHERE is_active = TRUE AND approved = TRUE AND category_type = 'INDUSTRY' ORDER BY display_order;