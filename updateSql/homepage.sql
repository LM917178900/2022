
CREATE SEQUENCE tbl_quality_news_id_seq START 1;
CREATE TABLE "public"."tbl_quality_news" (
  "id" int4 NOT NULL DEFAULT nextval('tbl_quality_news_id_seq'::regclass),
  "head_line" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "header_image_path" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "file_details_path" varchar(255) COLLATE "pg_catalog"."default",
  "rich_text_details" text COLLATE "pg_catalog"."default",
  "up_status" int4,
  "only_internal" int4,
  "publish_status" varchar(10) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "create_account" varchar(50) COLLATE "pg_catalog"."default",
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_account" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_time" timestamp(6),
  "show_status" int4,
  "file_name" varchar(255) COLLATE "pg_catalog"."default",
  CONSTRAINT "tbl_quality_news_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "tbl_quality_news_head_line_key" UNIQUE ("head_line")
);

COMMENT ON COLUMN "public"."tbl_quality_news"."id" IS '主键';
COMMENT ON COLUMN "public"."tbl_quality_news"."head_line" IS '新闻标题';
COMMENT ON COLUMN "public"."tbl_quality_news"."header_image_path" IS '图像存储路径';
COMMENT ON COLUMN "public"."tbl_quality_news"."file_details_path" IS '上传附件路径(要求pdf)';
COMMENT ON COLUMN "public"."tbl_quality_news"."rich_text_details" IS '富文本内容';
COMMENT ON COLUMN "public"."tbl_quality_news"."up_status" IS '登录时是否弹出';
COMMENT ON COLUMN "public"."tbl_quality_news"."only_internal" IS '是否只在lenovo内部用户homepage展示';
COMMENT ON COLUMN "public"."tbl_quality_news"."publish_status" IS '新闻发布状态';
COMMENT ON COLUMN "public"."tbl_quality_news"."create_account" IS '创建人账号';
COMMENT ON COLUMN "public"."tbl_quality_news"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."tbl_quality_news"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."tbl_quality_news"."update_account" IS '更新人账号';
COMMENT ON COLUMN "public"."tbl_quality_news"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."tbl_quality_news"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."tbl_quality_news"."show_status" IS '逻辑删除状态';
COMMENT ON COLUMN "public"."tbl_quality_news"."file_name" IS '文件名称';


CREATE SEQUENCE tbl_quality_stars_id_seq START 1;
CREATE TABLE "public"."tbl_quality_star" (
  "id" int4 NOT NULL DEFAULT nextval('tbl_quality_stars_id_seq'::regclass),
  "fiscal_year" varchar(10) COLLATE "pg_catalog"."default" NOT NULL,
  "award_type" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "winner_account" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "winner_name" varchar(64) COLLATE "pg_catalog"."default",
  "winner_depart" varchar(128) COLLATE "pg_catalog"."default",
  "winner_image_path" varchar(255) COLLATE "pg_catalog"."default",
  "comment" text COLLATE "pg_catalog"."default",
  "create_account" varchar(128) COLLATE "pg_catalog"."default",
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_account" varchar(128) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_time" timestamp(6),
  "quarter" varchar(10) COLLATE "pg_catalog"."default" NOT NULL,
  CONSTRAINT "tbl_quality_stars_pkey" PRIMARY KEY ("id")
);

COMMENT ON COLUMN "public"."tbl_quality_star"."id" IS '主键';
COMMENT ON COLUMN "public"."tbl_quality_star"."fiscal_year" IS '财年';
COMMENT ON COLUMN "public"."tbl_quality_star"."award_type" IS '奖励类型';
COMMENT ON COLUMN "public"."tbl_quality_star"."winner_account" IS '获奖者账号';
COMMENT ON COLUMN "public"."tbl_quality_star"."winner_name" IS '获奖者姓名';
COMMENT ON COLUMN "public"."tbl_quality_star"."winner_depart" IS '获奖者部门';
COMMENT ON COLUMN "public"."tbl_quality_star"."winner_image_path" IS '获奖者图像路径';
COMMENT ON COLUMN "public"."tbl_quality_star"."comment" IS '评论';
COMMENT ON COLUMN "public"."tbl_quality_star"."create_account" IS '创建人账号';
COMMENT ON COLUMN "public"."tbl_quality_star"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."tbl_quality_star"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."tbl_quality_star"."update_account" IS '更新人账号';
COMMENT ON COLUMN "public"."tbl_quality_star"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."tbl_quality_star"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."tbl_quality_star"."quarter" IS '季度';





