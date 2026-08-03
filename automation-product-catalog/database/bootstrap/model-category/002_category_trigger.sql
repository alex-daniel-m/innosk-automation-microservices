create trigger trg_category_updated_at
before update
on category
for each row
execute function set_updated_at();