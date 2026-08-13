-- 1. Función genérica para tablas con columna "updated_at"
CREATE OR REPLACE FUNCTION set_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW."updated_at" = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. Función específica para product_offering (su columna se llama "last_updated")
CREATE OR REPLACE FUNCTION set_product_offering_last_updated_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW."last_updated" = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para la tabla "category"
DROP TRIGGER IF EXISTS trg_category_updated_at ON "category";
CREATE TRIGGER trg_category_updated_at
BEFORE UPDATE ON "category"
FOR EACH ROW
EXECUTE FUNCTION set_updated_at_column();

-- Trigger para la tabla "product_specification"
DROP TRIGGER IF EXISTS trg_product_specification_updated_at ON "product_specification";
CREATE TRIGGER trg_product_specification_updated_at
BEFORE UPDATE ON "product_specification"
FOR EACH ROW
EXECUTE FUNCTION set_updated_at_column();

-- Trigger para la tabla "product_offering"
DROP TRIGGER IF EXISTS trg_product_offering_last_updated ON "product_offering";
CREATE TRIGGER trg_product_offering_last_updated
BEFORE UPDATE ON "product_offering"
FOR EACH ROW
EXECUTE FUNCTION set_product_offering_last_updated_column();

-- Función para forzar la actualización de la fecha en la oferta padre
CREATE OR REPLACE FUNCTION touch_parent_product_offering_from_spec()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE "product_offering"
    SET "last_updated" = CURRENT_TIMESTAMP
    WHERE "id" = NEW."product_offering_id";
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger cuando cambie una especificación de producto
DROP TRIGGER IF EXISTS trg_touch_offering_on_spec_change ON "product_specification";
CREATE TRIGGER trg_touch_offering_on_spec_change
AFTER INSERT OR UPDATE ON "product_specification"
FOR EACH ROW
EXECUTE FUNCTION touch_parent_product_offering_from_spec();