/*
------------------------------------------------------------------------------
Table: category

Purpose:
Stores the controlled taxonomy used by AI agents to classify automation-related
job opportunities collected from freelance marketplaces such as UpWork, Fiverr,
Reddit and similar sources.

The catalog contains predefined business categories (e.g. Lead Management,
CRM Setup, Workflow Automation) and also supports AI-generated suggestions
through the "Other" parent category.

This table acts as the central knowledge catalog for all classification tasks
performed by OpenFang agents.

Design Notes:
- Categories are grouped by category_type.
- Only the "Other" category is expected to have dynamically generated children.
- AI-generated categories should be reviewed before being approved.
------------------------------------------------------------------------------
*/

create table category(
  -- Unique identifier of the category.
  id                        uuid primary key default gen_random_uuid(),

  -- Human-readable category name used to classify job offers.
  name                      varchar(200) not null,

  -- Detailed explanation of the category and the criteria for assigning job offers to it.
  description               text,

  -- Logical classification of the category (e.g. PRIMARY_PROBLEM, TOOL, INDUSTRY).
  category_type             varchar(50) not null,

  -- Self-reference to the parent category. Used primarily for the "Other" category,
  -- allowing LLM-generated suggestions to be stored as child categories.
  parent_category_id        uuid null,

  -- Indicates whether this category is a top-level category within its classification type.
  is_root                   boolean not null default false,

  -- Indicates whether the category is part of the predefined system catalog.
  -- System categories are created manually and should rarely change.
  is_system                 boolean not null default true,

  -- Indicates whether the category has been reviewed and approved for production use.
  -- LLM-generated categories should be created with approved = false until validated.
  approved                  boolean not null default true,

  -- Indicates whether the category is currently available for classification.
  -- Inactive categories remain in the catalog for historical reference but should
  -- not be assigned to new job offers.
  is_active                 boolean not null default true,

  -- Origin of the category.
  -- SYSTEM = predefined catalog.
  -- LLM = automatically suggested by an AI model.
  -- USER = manually created by a human.
  source                    varchar(20) not null default 'SYSTEM',

  -- Number of job offers currently classified under this category.
  -- Used for analytics, reporting and popularity ranking.
  usage_count               bigint not null default 0,

  -- Optional ordering value for displaying categories in user interfaces.
  display_order             integer not null default 0,

  -- Timestamp when the category was created.
  created_at                timestamptz not null default now(),

  -- Timestamp of the most recent modification.
  updated_at                timestamptz not null default now(),

  constraint chk_category_type
    check (
      category_type in (
        'PRIMARY_PROBLEM',
        'SECONDARY_PROBLEM',
        'TOOL',
        'INDUSTRY',
        'OTHER'
      )
    ),

  constraint chk_source
    check (
      source in (
        'SYSTEM',
        'LLM',
        'USER'
      )
    ),

  constraint chk_name
    check (trim(name) <> ''),

  constraint fk_parent_category_id 
    foreign key (parent_category_id) 
    references category(id) 
    on delete restrict 
    on update restrict,

  constraint uk_name_category_type 
    unique (name, category_type)
);

/*

Cheks:

1. Trigger de validación de jerarquía, para garantizar que únicamente 
    la categoría Other pueda tener hijos. Así esa regla de negocio queda 
    protegida por la base de datos y no depende del código de la aplicación.

2. Especificar explícitamente la acción de la clave foránea 
    (ON DELETE RESTRICT y, si lo deseas, ON UPDATE RESTRICT). Aunque PostgreSQL 
    ya tiene un comportamiento por defecto, dejarlo explícito hace el esquema 
    más claro y evita ambigüedades para cualquier persona que lo mantenga en el 
    futuro.

*/