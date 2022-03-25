url: jdbc:postgresql://10.122.81.62:5432/npi_pss?currentSchema=public
username: a_appconnect
password: Q7uz^tWI


-- 序列问题
-- 主键冲突(duplicate key value violates unique constraint "sys_dict_copy1_pkey")
-- 序列自生会维护一个自增列表，将自增的元素作为主键，仅此而已；
-- 序列元素不会检查数据库最大id,只会维护自己的，即使数据库已经存在（出现相同会报错）；
SELECT setval('se_xxx_id ', (SELECT MAX(id) FROM xxx)+1);


-- 9. 新增表：country/geo/week(已同步到生产)
CREATE TABLE "public"."${表名称}" (
  "id" int8 NOT NULL DEFAULT nextval('${表名称}_id_seq'::regclass),
  "name" varchar(63) NOT NULL COLLATE "pg_catalog"."default",
  "value" varchar(63) NOT NULL COLLATE "pg_catalog"."default",
  "description" varchar(511) COLLATE "pg_catalog"."default",
  "sort" int4 ,

  "gmt_create" timestamp(6) NOT NULL DEFAULT now(),
  "gmt_update" timestamp(6) NOT NULL DEFAULT now(),
  "creator" varchar(31) COLLATE "pg_catalog"."default",
  "update_by" varchar(31)  COLLATE "pg_catalog"."default",
  CONSTRAINT "${表名称}_pkey" PRIMARY KEY ("id")
);

--postgreSQL dim_pss_calendar 新增字段(已同步到生产)
ALTER  table "public"."dim_pss_calendar" ADD COLUMN "normal_quarter" int2 DEFAULT null;
COMMENT ON COLUMN "public"."dim_pss_calendar"."normal_quarter" IS '自然季度';

ALTER  table "public"."dim_pss_calendar" ADD COLUMN "normal_month" int2 DEFAULT null;
COMMENT ON COLUMN "public"."dim_pss_calendar"."normal_month" IS '自然月';














--------------------- 生成环境需要执行 ---------------------

ALTER  table "public"."dim_pss_calendar" ADD COLUMN "normal_fiscal_year" varchar(32) COLLATE "pg_catalog"."default";
COMMENT ON COLUMN "public"."dim_pss_calendar"."normal_fiscal_year" IS '自然财年';

ALTER  table "public"."dim_pss_calendar" ADD COLUMN   "normal_fiscal_quarter" varchar(16) COLLATE "pg_catalog"."default";
COMMENT ON COLUMN "public"."dim_pss_calendar"."normal_fiscal_quarter" IS '自然财季度';


alter table datahub_project_schedule add COLUMN base varchar(32) DEFAULT null;
COMMENT ON COLUMN "public"."dim_product_mapping"."img" IS '产品图片访问连接';


-- postgreSQL dim_product_mapping 新增字段(已同步到生产)
ALTER  table "public"."datahub_project_schedule" ADD COLUMN "base" varchar(32) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'cfaa30e2436a47fabfedc6d835a13c70'::character varying,
COMMENT ON COLUMN "public"."datahub_project_schedule"."base" IS 'Base';


-- 修改 common_dataset sql(已同步到生产)
select * from common_dataset where id=3036
select dict_name as value from sys_dict where parent_id =(select id from sys_dict where dict_code='c173752b52564790ac766e7ac8cfbac6') and is_delete=0 order by dict_name;

-- 修改 sys_log 新增字段(已同步到生产)
ALTER  table "public"."sys_log" ADD COLUMN "level4_menu" varchar(255) DEFAULT null;
COMMENT ON COLUMN "public"."sys_log"."level4_menu" IS '四级菜单名称';

ALTER  table "public"."sys_log" ADD COLUMN "level5_menu" varchar(255) DEFAULT null;
COMMENT ON COLUMN "public"."sys_log"."level5_menu" IS '五级菜单名称';

ALTER  table "public"."sys_log" ADD COLUMN "level6_menu" varchar(255) DEFAULT null;
COMMENT ON COLUMN "public"."sys_log"."level6_menu" IS '六级菜单名称';

ALTER  table "public"."sys_log" ADD COLUMN "level7_menu" varchar(255) DEFAULT null;
COMMENT ON COLUMN "public"."sys_log"."level7_menu" IS '七级菜单名称';

ALTER  table "public"."sys_log" ADD COLUMN "level8_menu" varchar(255) DEFAULT null;
COMMENT ON COLUMN "public"."sys_log"."level8_menu" IS '八级菜单名称';


--- 用户组
-- 1. 新增 ac_group_user 表
CREATE TABLE "public"."ac_group_user" (
  "id" int4 NOT NULL,
  "user_id" int4,
  "group_id" int4,
  "gmt_create" timestamp(6),
  "gmt_modified" timestamp(6)
)
;

ALTER TABLE "public"."ac_group_user"
  OWNER TO "postgres";

COMMENT ON COLUMN "public"."ac_group_user"."id" IS '主键id';
COMMENT ON COLUMN "public"."ac_group_user"."user_id" IS '用户id';
COMMENT ON COLUMN "public"."ac_group_user"."group_id" IS '组id';
COMMENT ON COLUMN "public"."ac_group_user"."gmt_create" IS '创建时间';
COMMENT ON COLUMN "public"."ac_group_user"."gmt_modified" IS '更新日期';
COMMENT ON TABLE "public"."ac_group_user" IS '用户组-用户';
-- 2. 绑定序列
CREATE SEQUENCE ac_group_user_id_seq START 1;
alter table ac_group_user alter column id set default nextval('ac_group_user_id_seq');

--- 3. fix 1776
CREATE TABLE "public"."dim_mapping_region_country_product" (
  "npi_product_id" varchar(32) COLLATE "pg_catalog"."default",
  "npi_region" varchar(32) COLLATE "pg_catalog"."default",
  "country" varchar(32) COLLATE "pg_catalog"."default",
  "country_code" varchar(32) COLLATE "pg_catalog"."default"
);

-- 增加级联
insert into common_dataset(id,name,sql)values (3066,'region country_code','SELECT region,concat_ws(''---'',country,country_code) as country from dim_mapping_region_country GROUP BY region,country_code,country ORDER BY region,country_code,country');
-- product mapping 绑定用户组关系
insert into common_dataset(id,name,sql)values (3067,'user and user group','SELECT 'user' as type,username as label,username as value from ac_user
union all
SELECT 'group' as type,group_name as label,id::varchar as value from ac_group');

insert into common_dataset(id,name,sql)values (3070,'ltf group region sub region','SELECT pgroup,region,sub_region from ludp_ltf group by pgroup,region,sub_region order by pgroup,region,sub_region');
insert into common_dataset(id,name,sql)values (3069,'ltf region sub region','SELECT region,sub_region from ludp_ltf group by region,sub_region order by region,sub_region');



-- 4. productMapping 再次增加字段
ALTER TABLE dim_product_mapping ADD COLUMN mgmt_team_group varchar(127) ;
COMMENT ON COLUMN "public"."dim_product_mapping"."mgmt_team_group" IS '用户组id，逗号拼接';
ALTER TABLE dim_product_mapping ADD COLUMN npi_biz_admin_group varchar(127) ;
COMMENT ON COLUMN "public"."dim_product_mapping"."npi_biz_admin_group" IS '用户组id，逗号拼接';
ALTER TABLE dim_product_mapping ADD COLUMN confidential_product_access_id_group varchar(127) ;
COMMENT ON COLUMN "public"."dim_product_mapping"."confidential_product_access_id_group" IS '用户组id，逗号拼接';

ALTER TABLE dim_product_mapping ADD COLUMN product_name_in_qes varchar(127) ;
COMMENT ON COLUMN "public"."dim_product_mapping"."product_name_in_qes" IS 'qes 产品名称';


-- 5. product mapping 新增关联表
CREATE TABLE "public"."dim_mapping_ltf_product" (
  "npi_product_id" varchar(127) COLLATE "pg_catalog"."default",
  "pgroup_in_ltf" varchar(127) COLLATE "pg_catalog"."default",
  "region_in_ltf" varchar(127) COLLATE "pg_catalog"."default",
  "sub_region_in_ltf" varchar(127) COLLATE "pg_catalog"."default"
)
;

COMMENT ON COLUMN "public"."dim_mapping_ltf_product"."npi_product_id" IS '产品 id';
COMMENT ON COLUMN "public"."dim_mapping_ltf_product"."pgroup_in_ltf" IS '下拉单选，数据源来自LTF的字段【PGROUP 】';
COMMENT ON COLUMN "public"."dim_mapping_ltf_product"."region_in_ltf" IS '下拉多选，数据源来自LTF的字段【Region 】';
COMMENT ON COLUMN "public"."dim_mapping_ltf_product"."sub_region_in_ltf" IS '下拉多选，数据源来自LTF的字段【SUB_Region】';

-- 创建 sql 函数
CREATE OR REPLACE FUNCTION "public"."array_distinct"(anyarray)
  RETURNS "pg_catalog"."anyarray" AS $BODY$
 SELECT ARRAY(SELECT DISTINCT unnest($1));
$BODY$
  LANGUAGE sql VOLATILE
  COST 100


--  新建 ac_group_user
CREATE SEQUENCE ac_group_user_id_seq START 1;
CREATE TABLE "public"."ac_group_user" (
  "id" int4 NOT NULL DEFAULT nextval('ac_group_user_id_seq'::regclass),
  "user_id" int4,
  "group_id" int4,
  "gmt_create" timestamp(6),
  "gmt_modified" timestamp(6)
);

COMMENT ON COLUMN "public"."ac_group_user"."id" IS '主键id';
COMMENT ON COLUMN "public"."ac_group_user"."user_id" IS '用户id';
COMMENT ON COLUMN "public"."ac_group_user"."group_id" IS '组id';
COMMENT ON COLUMN "public"."ac_group_user"."gmt_create" IS '创建时间';
COMMENT ON COLUMN "public"."ac_group_user"."gmt_modified" IS '更新日期';
COMMENT ON TABLE "public"."ac_group_user" IS '用户组-用户';



-------------------------- 第二阶段 --------------------------
-- 0. 新建表
CREATE TABLE "public"."dim_kpi_summary" (
  "id" int4 NOT NULL,
  "fiscal_year" varchar(255) COLLATE "pg_catalog"."default",
  "kpi_summary_type_code" varchar(255) COLLATE "pg_catalog"."default",
  "budget" numeric(4,2),
  "target" numeric(4,2),
  "remark_file" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_time" timestamp(6),
  "create_time" timestamp(6)
)
;
COMMENT ON COLUMN "public"."dim_kpi_summary"."id" IS '主键id';
COMMENT ON COLUMN "public"."dim_kpi_summary"."fiscal_year" IS '财年';
COMMENT ON COLUMN "public"."dim_kpi_summary"."kpi_summary_type_code" IS 'kpiTypeCode';
COMMENT ON COLUMN "public"."dim_kpi_summary"."budget" IS 'budget';
COMMENT ON COLUMN "public"."dim_kpi_summary"."target" IS '目标';
COMMENT ON COLUMN "public"."dim_kpi_summary"."update_by" IS '编辑人';
COMMENT ON COLUMN "public"."dim_kpi_summary"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."dim_kpi_summary"."update_time" IS '编辑时间';
COMMENT ON COLUMN "public"."dim_kpi_summary"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."dim_kpi_summary"."remark_file" IS 'pdf 附件 uri';

-- 绑定序列
CREATE SEQUENCE dim_kpi_summary_id_seq START 1;
alter table dim_kpi_summary alter column id set default nextval('dim_kpi_summary_id_seq');

-- 1. 创建表 dim_kpi_detail
CREATE TABLE "public"."dim_kpi_detail" (
  "id" int4 NOT NULL,
  "npi_product_id" varchar(32) COLLATE "pg_catalog"."default",
  "npi_product_name" varchar(255) COLLATE "pg_catalog"."default",
  "kpi_detail_type_code" varchar(255) COLLATE "pg_catalog"."default",
  "goal" numeric(4,2),

  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_time" timestamp(6),
  "create_time" timestamp(6),
  CONSTRAINT "dim_kpi_detail_pkey" PRIMARY KEY ("id")
--   ,
--   CONSTRAINT "npi_product_name_uk" UNIQUE ("npi_product_name")
)
;
COMMENT ON COLUMN "public"."dim_kpi_detail"."id" IS '主键id';
COMMENT ON COLUMN "public"."dim_kpi_detail"."npi_product_id" IS '产品id';
COMMENT ON COLUMN "public"."dim_kpi_detail"."npi_product_name" IS '产品名称';
COMMENT ON COLUMN "public"."dim_kpi_detail"."kpi_detail_type_code" IS 'detail 类型';
COMMENT ON COLUMN "public"."dim_kpi_detail"."goal" IS 'goal目标';
COMMENT ON COLUMN "public"."dim_kpi_detail"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."dim_kpi_detail"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."dim_kpi_detail"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."dim_kpi_detail"."create_time" IS '创建时间';

CREATE SEQUENCE dim_kpi_detail_id_seq START 1;
alter table dim_kpi_detail alter column id set default nextval('dim_kpi_detail_id_seq');


-- 2.新增配置 common_dataset
insert into common_dataset(id,name,sql)values (3065,'kpi summary type',
'SELECT dict_name as label,dict_code as value from sys_dict where parent_id=(SELECT id from sys_dict where dict_code=''KPI Summary Type'')');
insert into common_dataset(id,name,sql)values (3068,'kpi detail type',
'SELECT dict_name as label,dict_code as value from sys_dict where parent_id=(SELECT id from sys_dict where dict_code=''KPI Detail Type'')');

-- 3.新增 sys_dict
-- 见 sys_dict_insert_20220112.sql 中的新增部分

-- 4. 新增 ac_res
-- 见 ac_res_insert_20220112.sql ,删除原表中所有数据， 实现全量新增；

-- 5. 新增 OD 模块；
CREATE TABLE "public"."datahub_product_od_and_picture" (
  "id" int4 NOT NULL,
  "npi_product_id" varchar(63) COLLATE "pg_catalog"."default" NOT NULL,
  "npi_product_name" varchar(127) COLLATE "pg_catalog"."default",
  "od_name_level_one" varchar(1023) COLLATE "pg_catalog"."default" NOT NULL,
  "od_name_level_two" varchar(1023) COLLATE "pg_catalog"."default",
  "spec" varchar(1023) COLLATE "pg_catalog"."default" NOT NULL,
  "remark" varchar(1023) COLLATE "pg_catalog"."default",
  "version" varchar(255) COLLATE "pg_catalog"."default",
  "display" varchar(6) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_time" timestamp(6),
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6)
)
;
-- ALTER TABLE "public"."datahub_product_od_and_picture" OWNER TO "postgres";
COMMENT ON COLUMN "public"."datahub_product_od_and_picture"."id" IS '主键id';
COMMENT ON COLUMN "public"."datahub_product_od_and_picture"."npi_product_id" IS '产品id';
COMMENT ON COLUMN "public"."datahub_product_od_and_picture"."npi_product_name" IS '产品名称';
COMMENT ON COLUMN "public"."datahub_product_od_and_picture"."od_name_level_one" IS '部件一级名称';
COMMENT ON COLUMN "public"."datahub_product_od_and_picture"."od_name_level_two" IS '部件二级名称';
COMMENT ON COLUMN "public"."datahub_product_od_and_picture"."spec" IS '描述';
COMMENT ON COLUMN "public"."datahub_product_od_and_picture"."remark" IS '备注';
COMMENT ON COLUMN "public"."datahub_product_od_and_picture"."version" IS '版本';
COMMENT ON COLUMN "public"."datahub_product_od_and_picture"."display" IS '当前数据是否展示';
COMMENT ON COLUMN "public"."datahub_product_od_and_picture"."update_by" IS '修改时间';
COMMENT ON COLUMN "public"."datahub_product_od_and_picture"."update_time" IS '修改人';
COMMENT ON COLUMN "public"."datahub_product_od_and_picture"."create_by" IS '创建时间';
COMMENT ON COLUMN "public"."datahub_product_od_and_picture"."create_time" IS '创建人';

CREATE SEQUENCE datahub_product_od_and_picture_id_seq START 1;
alter table datahub_product_od_and_picture alter column id set default nextval('datahub_product_od_and_picture_id_seq');


-- 6. 新建 datahub_product_attachment
CREATE TABLE "public"."datahub_product_attachment" (
  "id" int4 NOT NULL,
  "npi_product_id" varchar(63) COLLATE "pg_catalog"."default" NOT NULL,
  "type" int2 NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default",
  "origin_name" varchar(255) COLLATE "pg_catalog"."default",
  "postfix" varchar(31) COLLATE "pg_catalog"."default",
  "uri" varchar(1023) COLLATE "pg_catalog"."default",
  "is_default_one" bool DEFAULT false,
  "update_by" varchar COLLATE "pg_catalog"."default",
  "update_time" timestamp(6),
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6)
);

COMMENT ON COLUMN "public"."datahub_product_attachment"."id" IS '主键id';
COMMENT ON COLUMN "public"."datahub_product_attachment"."npi_product_id" IS '关联的产品id';
COMMENT ON COLUMN "public"."datahub_product_attachment"."type" IS '附件类型，1：图片；2：文件';
COMMENT ON COLUMN "public"."datahub_product_attachment"."name" IS '文件名称';
COMMENT ON COLUMN "public"."datahub_product_attachment"."origin_name" IS '文件原名';
COMMENT ON COLUMN "public"."datahub_product_attachment"."postfix" IS '文件后缀';
COMMENT ON COLUMN "public"."datahub_product_attachment"."uri" IS '资源路径';
COMMENT ON COLUMN "public"."datahub_product_attachment"."is_default_one" IS '是否默认被选中';
COMMENT ON COLUMN "public"."datahub_product_attachment"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."datahub_product_attachment"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."datahub_product_attachment"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."datahub_product_attachment"."create_time" IS '创建时间';

CREATE SEQUENCE datahub_product_attachment_id_seq START 1;
alter table datahub_product_attachment alter column id set default nextval('datahub_product_attachment_id_seq');

-- 7 product mapping 新增字段
ALTER TABLE dim_product_mapping ADD COLUMN product_name_in_sci_order varchar(127) ;
COMMENT ON COLUMN "public"."dim_product_mapping"."product_name_in_sci_order" IS '新增 产品名称';

-- 8 od 级联关系数据集
insert into common_dataset(id,name,sql)values (3072,'od cascade','SELECT od_name_level_one,od_name_level_two FROM "datahub_product_od_and_picture" where npi_product_name=''{npi_product_name}'' group by od_name_level_one,od_name_level_two');
insert into common_dataset(id,name,sql)values (3073,'od version','SELECT npi_product_name,version FROM "datahub_product_od_and_picture"
group by npi_product_name,version order by npi_product_name,replace(replace(version,'Ver.',''),'_','')::int DESC');

insert into common_dataset(id,name,sql)values (3075,'npi product name and id',
'select npi_product_name as label,id as value  from dim_product_mapping where npi_product_name !='' order by npi_product_name');



-- 9. 新建表dim_kpi_actual_maintenance
CREATE SEQUENCE dim_kpi_actual_maintenance_id_seq START 1;

CREATE TABLE "public"."dim_kpi_actual_maintenance" (
  "id" int4 NOT NULL DEFAULT nextval('dim_kpi_actual_maintenance_id_seq'::regclass),
  "fiscal_year" varchar(255) COLLATE "pg_catalog"."default",
  "kpi_summary_type_code" varchar(255) COLLATE "pg_catalog"."default",
  "actual" numeric(1000,2),
  "update_time" timestamp(6),
  "create_time" timestamp(6),
  "update_by" varchar(127) COLLATE "pg_catalog"."default",
  "create_by" varchar(127) COLLATE "pg_catalog"."default",
  CONSTRAINT "dim_kpi_actual_maintenance_pkey" PRIMARY KEY ("id")
)
;
COMMENT ON COLUMN "public"."dim_kpi_actual_maintenance"."id" IS '主键';
COMMENT ON COLUMN "public"."dim_kpi_actual_maintenance"."fiscal_year" IS '财年';
COMMENT ON COLUMN "public"."dim_kpi_actual_maintenance"."kpi_summary_type_code" IS 'KPI SUMMARY TYPE';
COMMENT ON COLUMN "public"."dim_kpi_actual_maintenance"."actual" IS '数字，可以为0';
COMMENT ON COLUMN "public"."dim_kpi_actual_maintenance"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."dim_kpi_actual_maintenance"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."dim_kpi_actual_maintenance"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."dim_kpi_actual_maintenance"."create_by" IS '创建人';



-- ltf 级联接口

insert into common_dataset(id,name,sql)values (3077,'ltf fiscalYear-productStatus-product','with
max_ver AS(
select npi_product_name,npi_product_id, max(replace(replace(version,''Ver.'',''''),''_'','''')::BIGINT) as ver_num
from datahub_project_schedule  group by npi_product_name,npi_product_id
)
,t_actual as(
SELECT dps.npi_product_name,dps.npi_product_id, max(id) as id
FROM max_ver as tem
JOIN datahub_project_schedule as dps on tem.npi_product_id= dps.npi_product_id and tem.ver_num=(replace(replace(dps.version,''Ver.'',''''),''_'','''')::BIGINT)
where plant in (select factory from dim_factory_list where type!=''EMS'' )
and dps.base=''cfaa30e2436a47fabfedc6d835a13c70''
and milestone =''d8f49c3a7a5244d1baf24b764438bfbf''
and ok2ship is not null
group by dps.npi_product_name,dps.npi_product_id
order by dps.npi_product_name,dps.npi_product_id
)
,t_plan as (
SELECT dps.npi_product_name,dps.npi_product_id, max(id) as id
FROM max_ver as tem
JOIN datahub_project_schedule as dps on tem.npi_product_id= dps.npi_product_id and tem.ver_num=(replace(replace(dps.version,''Ver.'',''''),''_'','''')::BIGINT)
where plant in (select factory from dim_factory_list where type!=''EMS'' )
and dps.base=''cfaa30e2436a47fabfedc6d835a13c70''
and milestone =''c55c93979d0c420292e8fad70979fa4d''
and ok2ship is not null
and dps.npi_product_id not in (SELECT npi_product_id from t_actual)
group by dps.npi_product_name,dps.npi_product_id
order by dps.npi_product_name,dps.npi_product_id
)
SELECT dpc.normal_fiscal_year as fiscal_year,concat_ws(''---'',sd.dict_name,sd.dict_code) as  product_status,concat_ws(''---'',dps.npi_product_name,dps.npi_product_id) as product_name_and_id
from datahub_project_schedule as dps
JOIN dim_pss_calendar as dpc on dpc.date::date=dps.ok2ship::date
join sys_dict as sd on sd.dict_code=dps.product_status
where (dps.id in (SELECT id from t_actual) or dps.id in (SELECT id from t_plan))
order by dpc.normal_fiscal_year,sd.dict_name,dps.npi_product_name;');


insert into common_dataset(id,name,sql)values (3078,'ltf history version-product',
'SELECT
rir.version ,concat_ws(''---'',dpm.npi_product_name,dpm.id)
from "report_instance_R4" as rir
join report_profile as rp on rp.id=rir.report_id
join dim_product_mapping as dpm on dpm.id=rir.product_id
where rp.status=3
group by rir.version,concat_ws(''---'',dpm.npi_product_name,dpm.id);');

update common_dataset set sql ='SELECT
rir.version ,concat_ws(''---'',dpm.npi_product_name,dpm.id)
from "report_instance_R4" as rir
join dim_product_mapping as dpm on dpm.id=rir.product_id
where rir.report_id=0 and rir.creator=''history''
group by rir.version,concat_ws(''---'',dpm.npi_product_name,dpm.id)
order by rir.version desc,concat_ws(''---'',dpm.npi_product_name,dpm.id)' where id =3078;

update common_dataset set sql ='SELECT
rir.version ,concat_ws(''---'',dpm.npi_product_name,dpm.id)
from "report_instance_R4" as rir
join dim_product_mapping as dpm on dpm.id=rir.product_id
where rir.report_id=0
group by rir.version,concat_ws(''---'',dpm.npi_product_name,dpm.id)' where id=3078;


insert into common_dataset(id,name,sql)values (3079,'ltf Field Config',
'select two_component_name from dim_sourcing_board_component_list group by two_component_name
ORDER BY two_component_name;');

update common_dataset set sql='select two_component_name as value,two_component_name as label,sort
from dim_sourcing_board_component_list
ORDER BY sort' where id=3079;


-- powerBI 建表
CREATE TABLE "public"."bi_report" (
  "id" varchar(63) COLLATE "pg_catalog"."default" NOT NULL,
  "title" varchar(127) COLLATE "pg_catalog"."default" NOT NULL,
  "dataset_id" varchar(63) COLLATE "pg_catalog"."default" NOT NULL,
  "embed_url" varchar(511) COLLATE "pg_catalog"."default",
  "create_by" varchar(32) COLLATE "pg_catalog"."default",
  "creator_name" varchar(32) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_by" varchar(32) COLLATE "pg_catalog"."default",
  "update_time" timestamp(6),
  CONSTRAINT "bi_report_pkey" PRIMARY KEY ("id")
)
;
COMMENT ON COLUMN "public"."bi_report"."id" IS 'powerBI报表主键';
COMMENT ON COLUMN "public"."bi_report"."title" IS 'powerBI报表名称';
COMMENT ON COLUMN "public"."bi_report"."dataset_id" IS 'powerBI数据集id';
COMMENT ON COLUMN "public"."bi_report"."embed_url" IS 'embedUrl属性';
COMMENT ON COLUMN "public"."bi_report"."create_by" IS '创建人itCode';
COMMENT ON COLUMN "public"."bi_report"."creator_name" IS '创建人name';
COMMENT ON COLUMN "public"."bi_report"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."bi_report"."update_by" IS '修改人的itCode';
COMMENT ON COLUMN "public"."bi_report"."update_time" IS '修改时间';


CREATE TABLE "public"."bi_dataset" (
  "id" varchar(63) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(63) COLLATE "pg_catalog"."default" NOT NULL,
  "embed_url" varchar(511) COLLATE "pg_catalog"."default" NOT NULL,
  "visible" int2 NOT NULL,
  "description" varchar(255) COLLATE "pg_catalog"."default",
  "model_category" varchar(63) COLLATE "pg_catalog"."default",
  "image" varchar(255) COLLATE "pg_catalog"."default",
  "create_by" varchar(31) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_by" varchar(31) COLLATE "pg_catalog"."default",
  "update_time" timestamp(6),
  "ac_role" varchar(255) COLLATE "pg_catalog"."default",
  "display_name" varchar(255) COLLATE "pg_catalog"."default",
  CONSTRAINT "bi_dataset_pkey" PRIMARY KEY ("id")
)
;
COMMENT ON COLUMN "public"."bi_dataset"."id" IS 'dataSet对象主键';
COMMENT ON COLUMN "public"."bi_dataset"."name" IS 'dataSet对象的name';
COMMENT ON COLUMN "public"."bi_dataset"."embed_url" IS 'embedUrl';
COMMENT ON COLUMN "public"."bi_dataset"."visible" IS '是否可见，0：否；1：是';
COMMENT ON COLUMN "public"."bi_dataset"."description" IS '描述';
COMMENT ON COLUMN "public"."bi_dataset"."model_category" IS 'dataset的类别';
COMMENT ON COLUMN "public"."bi_dataset"."image" IS '图片';
COMMENT ON COLUMN "public"."bi_dataset"."create_by" IS '创建人的itcode';
COMMENT ON COLUMN "public"."bi_dataset"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."bi_dataset"."update_by" IS '修改人的itcode';
COMMENT ON COLUMN "public"."bi_dataset"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."bi_dataset"."ac_role" IS '可访问信息的角色id组合，以,相隔，eg：1,2,3';
COMMENT ON COLUMN "public"."bi_dataset"."display_name" IS '用户展示的名字';




-- 报表类型数据集
insert into common_dataset(id,name,sql)values (3081,'reportCategoryCode',
'with tem as(
select rc.name as label,rc.code as value
from report_category as rc
where 1=1
and rc.customized=true
group by rc.name ,rc.code
)
SELECT rc.name as label,rc.code as value from report_category as rc
join tem on tem.label = rc.name and tem.value=rc.code
ORDER by rc.create_time desc');

update common_dataset set sql='with tem as(
select rc.name as label,rc.code as value
from report_category as rc
where 1=1
and rc.customized=true
group by rc.name ,rc.code
)
SELECT rc.name as label,rc.code as value from report_category as rc
join tem on tem.label = rc.name and tem.value=rc.code
ORDER by rc.create_time desc' where id=3081


-- 产品按创建时间倒序排序
insert into common_dataset(id,name,sql)values (3082,'npi_product_name by create time desc',
'select npi_product_name as label,id as value  from dim_product_mapping where npi_product_name !='''' order by  create_time desc');

insert into common_dataset(id,name,sql)values (3083,'report status',
'select dict_name as label,dict_value::int as value from sys_dict where parent_id=196');

insert into common_dataset(id,name,sql)values (3088,'product_name_in_qes',
'SELECT product_name_in_qes as value,product_name_in_qes as label from qes_actual_fpy group by product_name_in_qes order by product_name_in_qes');
update common_dataset set sql ='SELECT product_name_in_qes as value,product_name_in_qes as label from qes_actual_fpy group by product_name_in_qes order by product_name_in_qes' where id=3088


insert into common_dataset(id,name,sql)values (3090,'warning_light',
'select dict_name as label,dict_code as value from sys_dict where parent_id=(SELECT id from sys_dict where dict_code=''f7beb9e86cf2401a9326ed2c9ee7cead'');');

insert into common_dataset(id,name,sql)values (3091,'npi_notepad_catgory',
'select dict_name as label,dict_code as value from sys_dict where parent_id = (SELECT id from sys_dict where dict_code=''3e4f441f3585436db01885bbf6e17ff5'');');

update common_dataset set sql ='with v_business_case_quarterly as (
	SELECT npi_product_name as product,pss_version FROM (
	SELECT DISTINCT program,pss_version,substr("pss_version", 5,30) AS date
	FROM ludp_business_case
	WHERE program IS NOT NULL AND program != '''' AND pss_version IS NOT NULL AND pss_version != ''''
	ORDER BY date DESC
	) t
	join dim_product_mapping as dpm on dpm.business_case_program_name=t.program
	ORDER BY REPLACE(REPLACE(replace(pss_version,''POR'',''''),''CWV'',''''),''_'','''')::BIGINT desc
)
SELECT product,concat_ws(''---'',split_part(pss_version, ''-'', 1),pss_version) AS pss_version
FROM (
		SELECT product,pss_version,substr("pss_version", 5,30) AS date FROM (
				SELECT DISTINCT product,pss_version || ''-Quarterly'' AS pss_version FROM v_business_case_quarterly
				UNION
				SELECT DISTINCT product,pss_version || ''-PRC'' AS pss_version FROM v_business_case_prc_quarterly
		) t ORDER BY date DESC
) t1' where id =16;

update common_dataset set sql ='SELECT DISTINCT normal_fiscal_year as fiscal_year FROM dim_pss_calendar WHERE "date" = current_date' where id=600;
update common_dataset set sql ='SELECT DISTINCT normal_fiscal_year as fiscal_year FROM dim_pss_calendar
WHERE normal_fiscal_year < (SELECT (''FY'' || (SELECT to_char((SELECT now()::timestamp + ''3 year''),''yyyy''))))
ORDER BY normal_fiscal_year DESC;' where id=3032;


create index idx_product_name on ludp_order_detail(product_name);
insert into common_dataset(id,name,sql)values (3092,'order_product_name','SELECT product_name as label,product_name as value  from ludp_order_detail where product_name !='''' group  by product_name order by product_name;');

update common_dataset set sql ='SELECT product_name as label,product_name as value  from ludp_order_detail_product where product_name !=''''  group  by product_name order by product_name'
where id =3092;



